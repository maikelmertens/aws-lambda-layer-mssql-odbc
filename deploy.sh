#!/usr/bin/env sh

aws lambda publish-layer-version \
  --layer-name mssql-odbc \
  --description "A MSSQL ODBC driver AWS Lambda layer" \
  --license-info "GPL-3.0" \
  --compatible-runtimes python3.7 \
  --zip-file fileb://layer.zip
