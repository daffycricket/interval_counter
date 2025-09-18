#!/usr/bin/env bash
set -euo pipefail
SCREEN="${1:?usage: make_targets <screen>}"
flutter analyze
flutter test --plain-name "${SCREEN}_screen"
