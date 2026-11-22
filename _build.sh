#!/bin/bash
# Build entry point for humans and agents.
#   ./_build.sh sushi   compile FSH only (fast)
#   ./_build.sh         SUSHI and the IG Publisher (authoritative)
# The IG Publisher runs directly when Jekyll and SUSHI are on the PATH, as on
# the GitHub runner, and in a container otherwise.
set -euo pipefail
cd "$(dirname "$0")"

SUSHI_VERSION=3.21.0
JAR=input-cache/publisher.jar
IMAGE=hl7fhir/ig-publisher-base:latest

if [ "${1:-}" = "sushi" ]; then
  if command -v sushi >/dev/null 2>&1; then
    exec sushi .
  fi
  exec npx -y "fsh-sushi@${SUSHI_VERSION}" .
fi

if [ ! -f "$JAR" ]; then
  mkdir -p input-cache
  curl -fsSL -o "$JAR" https://github.com/HL7/fhir-ig-publisher/releases/latest/download/publisher.jar
fi

# The IG Publisher refuses to run SUSHI when the IG folder has an .npmrc file.
# The command sandbox of the agent workflows puts empty placeholder files such
# as .npmrc into the working copy, and a command inside the sandbox cannot
# remove them. An empty .npmrc that git does not track is such a placeholder.
# Remove it. If it is still there, build in a copy of the sources without it
# and bring the results back. Any other .npmrc is left for the IG Publisher to
# report.
IG_DIR=$PWD
if [ -e .npmrc ] && [ ! -s .npmrc ] && ! git ls-files --error-unmatch .npmrc >/dev/null 2>&1; then
  rm -f .npmrc 2>/dev/null || true
  if [ -e .npmrc ]; then
    IG_DIR=$(mktemp -d "${TMPDIR:-/tmp}/ig-build.XXXXXX")
    trap 'rm -rf "$IG_DIR"' EXIT
    echo "Empty .npmrc that cannot be removed: building in a copy in $IG_DIR"
    git ls-files -co --exclude-standard -z | while IFS= read -r -d '' f; do
      if [ -f "$f" ] && [ "$f" != .npmrc ]; then
        mkdir -p "$IG_DIR/$(dirname "$f")"
        cp -p "$f" "$IG_DIR/$f"
      fi
    done
    if [ -d input-cache/txcache ]; then
      mkdir -p "$IG_DIR/input-cache"
      cp -R input-cache/txcache "$IG_DIR/input-cache/"
    fi
  fi
fi

status=0
if command -v jekyll >/dev/null 2>&1 && command -v sushi >/dev/null 2>&1; then
  java -Xmx4g -jar "$PWD/$JAR" -ig "$IG_DIR" ${@+"$@"} || status=$?
else
  mkdir -p "$HOME/.fhir"
  docker run --rm \
    -v "$IG_DIR":/home/publisher/ig \
    -v "$PWD/$JAR":/home/publisher/publisher.jar:ro \
    -v "$HOME/.fhir":/home/publisher/.fhir \
    -w /home/publisher/ig \
    "$IMAGE" \
    java -Xmx4g -jar /home/publisher/publisher.jar -ig . ${@+"$@"} || status=$?
fi

if [ "$IG_DIR" != "$PWD" ]; then
  for d in output fsh-generated input-cache/txcache; do
    if [ -d "$IG_DIR/$d" ]; then
      rm -rf "$d"
      cp -R "$IG_DIR/$d" "$d"
    fi
  done
fi
if [ "$status" -ne 0 ]; then
  echo "The IG Publisher ended with exit code $status."
  exit "$status"
fi

echo
echo "QA summary (output/qa.json):"
grep -E '"(errs|warnings|hints)"' output/qa.json
