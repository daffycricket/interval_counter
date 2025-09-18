#!/usr/bin/env bash
set -euo pipefail
SCREEN="${1:?usage: preflight <screen>}"
DESIGN="design/${SCREEN}_design.json"
SPEC="specs/${SCREEN}_specification.md"
SCHEMA="schemas/minifigma.schema.json"

if ! command -v jq >/dev/null; then echo "jq required"; exit 1; fi
if ! command -v ajv >/dev/null; then echo "ajv required"; exit 1; fi

jq -e . "$DESIGN" >/dev/null
ajv validate -s "$SCHEMA" -d "$DESIGN"

echo "SHA256 design: $(shasum -a 256 "$DESIGN" | awk '{print $1}')"
echo "SHA256 spec  : $(shasum -a 256 "$SPEC"   | awk '{print $1}')"
