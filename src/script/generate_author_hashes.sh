#!/bin/sh
set -eu

XSLTPROC="xsltproc"
XML_SRC="$1"
XSLT_DIR="$2"
HASH_SCRIPT="$3"
OUTPUT_FILE="$4"

{
    echo "<authors>"
    $XSLTPROC "${XSLT_DIR}/script/author_vs_hash.xsl" "${XML_SRC}" |
        ruby "${HASH_SCRIPT}" |
        awk -F'\t' '{gsub(/&/, "\\&amp;", $2); gsub(/</, "\\&lt;", $2); gsub(/>/, "\\&gt;", $2); print "<author><name>"$2"</name><hash>"$1"</hash></author>"}'
    echo "</authors>"
} >"${OUTPUT_FILE}"

