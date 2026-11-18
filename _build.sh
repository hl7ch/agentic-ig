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

if command -v jekyll >/dev/null 2>&1 && command -v sushi >/dev/null 2>&1; then
  java -Xmx4g -jar "$JAR" -ig . ${@+"$@"}
else
  mkdir -p "$HOME/.fhir"
  docker run --rm \
    -v "$PWD":/home/publisher/ig \
    -v "$HOME/.fhir":/home/publisher/.fhir \
    -w /home/publisher/ig \
    "$IMAGE" \
    java -Xmx4g -jar "$JAR" -ig . ${@+"$@"}
fi

echo
echo "QA summary (output/qa.json):"
grep -E '"(errs|warnings|hints)"' output/qa.json
