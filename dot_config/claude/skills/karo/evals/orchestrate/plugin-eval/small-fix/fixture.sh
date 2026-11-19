#!/bin/bash
set -eu
cat > README.md <<'MD'
# csvtool

csvtool splits CSV rows and prints the columns you recieve on standard output.

## Usage

    csvtool [--delimiter CHAR] FILE
MD
