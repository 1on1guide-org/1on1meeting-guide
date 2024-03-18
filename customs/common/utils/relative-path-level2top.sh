#!/bin/bash
set -eu

##############################
# ディレクトリ階層を辿ってbase directoryまでの相対パスを『:includedir:』の値として書き込むよ。
# bashが使える環境でこの子をキックしてね。
# 利用する際はあらかじめ対象のファイルに『:includedir:』を定義してね。
##############################

TOOL_DIR=$(cd $(dirname $0); pwd)
INDEX_DIR=${TOOL_DIR%%\/customs\/common\/utils}

echo ${TOOL_DIR}
echo ${INDEX_DIR}

cd ${INDEX_DIR}

FILE_ARRAY=()
FILE_ARRAY+=`find . -iname "*.adoc" -type f -not -iname "index*.adoc" -type f -not -iname "define*.adoc"  -type f`

for FILE in ${FILE_ARRAY[@]}
do
  PATH_LEVEL=${FILE#./}
  PATH_LEVEL=`echo ${PATH_LEVEL} | sed -e "s/[^\/]*\//..\//g"`
  PATH_LEVEL=`echo ${PATH_LEVEL} | sed -e "s/\/[^\/]*\.adoc/\//"`
  PATH_LEVEL=${PATH_LEVEL//\//\\/}
  echo ${FILE}
  if [ "$(uname)" == 'Darwin' ]; then
    sed -i "" -e "s/^:includedir:.*/:includedir: ${PATH_LEVEL}/g" "${INDEX_DIR}${FILE#.}"
    sed -i "" -e "s/^:imagesdir:.*/:imagesdir: ${PATH_LEVEL}/g" "${INDEX_DIR}${FILE#.}"
  else
    sed -i -e "s/^:includedir:.*/:includedir: ${PATH_LEVEL}/g" "${FILE}"
    sed -i -e "s/^:imagesdir:.*/:imagesdir: ${PATH_LEVEL}/g" "${FILE}"
  fi
done
