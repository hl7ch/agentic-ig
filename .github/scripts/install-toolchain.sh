#!/bin/bash
# Installs what ./_build.sh needs to run without Docker on a GitHub runner:
# SUSHI and Jekyll on the PATH, and the IG Publisher jar in input-cache/.
# Java and Ruby are already on ubuntu-latest.
set -euo pipefail

SUSHI_VERSION=3.21.0

npm install --global --silent "fsh-sushi@${SUSHI_VERSION}"
sudo gem install jekyll --no-document --quiet
mkdir -p input-cache
curl -fsSL -o input-cache/publisher.jar \
  https://github.com/HL7/fhir-ig-publisher/releases/latest/download/publisher.jar

sushi --version
jekyll --version
java -version
