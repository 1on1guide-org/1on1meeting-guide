#!/bin/bash
set -u

##############################
# 利用する際はあらかじめ「 define-version-headeronly.adoc 」にバージョンを入れておく
##############################

TOOL_DIR=$(cd $(dirname $0); pwd)
INDEX_DIR=${TOOL_DIR%%\/customs\/common\/utils}

echo ${TOOL_DIR}
echo ${INDEX_DIR}

while read data value
do
  if  [[ ${data} = :revnumber: ]] || [[ ${data} = :revdate: ]]
  then
    DATA_NAME=${data//:/}
    eval $DATA_NAME=${data}"\ "${value}
  fi
done <  ${INDEX_DIR}/contents/partials/define-version-headeronly.adoc

echo ${revnumber}
echo ${revdate}

