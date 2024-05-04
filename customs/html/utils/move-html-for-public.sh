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

cp -rf .${SOURCE_DIR}/* .${DESTNATION_DIR}/.
rm -rf .${SOURCE_DIR}

