#!/bin/sh
set -eu

XSLTPROC="xsltproc"
XML_SRC="$1"
XSLT_DIR="$2"
HASH_SCRIPT="$3"
OUTPUT_FILE="$4"

$XSLTPROC "${XSLT_DIR}/get_authors.xsl" "${XML_SRC}" \
| ruby "${HASH_SCRIPT}" \
| awk -F'\t' '{gsub(/&/, "\\&amp;", $2); gsub(/</, "\\&lt;", $2); gsub(/>/, "\\&gt;", $2); print "<author><name>"$2"</name><hash>"$1"</hash></author>"}' \
| sed '1i<authors>' \
| sed '$a</authors>' \
> "${OUTPUT_FILE}"
