#!/bin/bash
set -eu

TOOL_DIR=$(cd $(dirname $0); pwd)
HTML_TOOL_PATH=${TOOL_DIR%%\/utils}
INDEX_DIR=${TOOL_DIR%%\/customs\/html\/utils}

echo ${TOOL_DIR}
echo ${HTML_TOOL_PATH}
echo ${INDEX_DIR}

cd ${INDEX_DIR}

SOURCE_DIR=/public/html
DESTNATION_DIR=/public
SVGBADGES_MAKETOOL_DIR=images/contents/images/SvgBadges/maketool
CUSTOMS_PDF_DIR=images/customs/pdf

cp -rf .${SOURCE_DIR}/* .${DESTNATION_DIR}/.
rm -rf .${SOURCE_DIR}

rm -rf .${SVGBADGES_MAKETOOL_DIR}
rm -rf .${CUSTOMS_PDF_DIR}
