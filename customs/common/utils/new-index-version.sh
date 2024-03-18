#!/bin/bash
set -u

##############################
# 利用する際はあらかじめ「 index-version.adoc 」にバージョンを入れておく
##############################

###############################
# ここにバージョン表記対象ファイルを記載#
###############################
FILE_ARRAY=("README.adoc")
FILE_ARRAY+=("index.adoc")
##############################

echo ${FILE_ARRAY[@]}

TOOL_DIR=$(cd $(dirname $0); pwd)
INDEX_DIR=${TOOL_DIR%%\/shell-utility}

while read data value
do
  if  [[ ${data} = :revnumber: ]] || [[ ${data} = :revdate: ]]
  then
    DATA_NAME=${data//:/}
    eval $DATA_NAME=${data}"\ "${value}
  fi
done <  ${INDEX_DIR}/index-version.adoc

echo ${revnumber}
echo ${revdate}

for FILE in ${FILE_ARRAY[@]}
do
  sed -i "" -e "s/^:revnumber:.*/${revnumber}/g" ${INDEX_DIR}/${FILE}
  sed -i "" -e "s/^:revdate:.*/${revdate}/g" ${INDEX_DIR}/${FILE}
done
