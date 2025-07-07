#!/bin/sh
set -eu

XSLTPROC="xsltproc"

XML_SRC="$1"
XSLT_DIR="$2"
HASH_SCRIPT="$3"
WWW_DIR="$4"
BASE_URL_ARG="$5"

AUTHORS_OUTPUT_DIR="${WWW_DIR}/authors"

# Ensure the output directory exists
mkdir -p "${AUTHORS_OUTPUT_DIR}"

$XSLTPROC "${XSLT_DIR}/script/author_vs_hash.xsl" "${XML_SRC}" \
| ruby "${HASH_SCRIPT}" \
| while IFS=$(printf '\t') read -r author_file author_name_slug; do
    author_name=$(echo "$author_name_slug" | tr '+' ' ')
    if [ -n "$author_file" ]; then
        echo "  → ${author_file}.html for ${author_name}"
        # 引数で受け取ったURLを使用
        $XSLTPROC --stringparam base_url "${BASE_URL_ARG}" \
                    --stringparam author_name "${author_name}" \
                    "${XSLT_DIR}/page/author_detail.xsl" "${XML_SRC}" \
          > "${AUTHORS_OUTPUT_DIR}/${author_file}.html"
    fi
done
