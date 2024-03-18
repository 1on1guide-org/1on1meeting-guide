#!/bin/bash
set -eu

TOOL_DIR=$(cd $(dirname $0); pwd)
HTML_TOOL_PATH=${TOOL_DIR%%\/utils}
INDEX_DIR=${TOOL_DIR%%\/customs\/html\/utils}

echo ${TOOL_DIR}
echo ${HTML_TOOL_PATH}
echo ${INDEX_DIR}

cd ${INDEX_DIR}

DESTNATION_DIR=/public/html
IMAGES_DIR=${DESTNATION_DIR}/images
mkdir -p ${INDEX_DIR}/${DESTNATION_DIR}

find ./ -path *${DESTNATION_DIR} -prune -o -iname *.png  -type f -exec rsync -r -R {} ${INDEX_DIR}/${IMAGES_DIR} \;
find ./ -path *${DESTNATION_DIR} -prune -o -iname *.svg  -type f -exec rsync -r -R {} ${INDEX_DIR}/${IMAGES_DIR} \;
find ./ -path *${DESTNATION_DIR} -prune -o -iname *.jpeg -type f -exec rsync -r -R {} ${INDEX_DIR}/${IMAGES_DIR} \;
cp -rf ${HTML_TOOL_PATH}/js ${INDEX_DIR}/${DESTNATION_DIR}
cp -rf ${HTML_TOOL_PATH}/css ${INDEX_DIR}/${DESTNATION_DIR}


