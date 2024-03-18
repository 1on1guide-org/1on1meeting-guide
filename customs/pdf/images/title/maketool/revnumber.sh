#!/bin/bash
set -eu

TOOL_DIR=$(cd $(dirname $0); pwd)
TITLE_DIR=${TOOL_DIR%%\/maketool}
INDEX_DIR=${TOOL_DIR%%\/pdf\/images\/title\/maketool}

echo ${TOOL_DIR}
echo ${TITLE_DIR}
echo ${INDEX_DIR}

REVISION_NUMBER=`cat ${INDEX_DIR}/index.adoc | grep revnumber | awk '{print $2}'`
TITLE_BACKGROUND=`cat ${TITLE_DIR}/title-background.svg`
echo ${TITLE_BACKGROUND} | sed -e "s|{%revnumber%}|$REVISION_NUMBER|g" > "${TITLE_DIR}/title-background.svg"
