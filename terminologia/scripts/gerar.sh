#!/bin/bash
# FSH -> FHIR JSON (fhir/) -> JSON Lines do OCL (ocl/).
set -e
cd "$(dirname "$0")/.."
npx --yes fsh-sushi@3.20.1 .
rm -f fhir/*.json
cp fsh-generated/resources/*.json fhir/
python3 scripts/gerar_ocl.py "$@"
