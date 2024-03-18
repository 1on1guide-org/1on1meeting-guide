#!/bin/bash
set -eu

echo ${GITHUB_EVENT_NAME}
echo ${GITHUB_REF}
echo ${GITHUB_BASE_REF}
echo ${GITHUB_HEAD_REF}

########################
##### 日本語環境を作成 ####
########################
export LANG=ja_JP.UTF-8
apk update
# 日本語フォントがないと幅が取れず綺麗に出力できない
apk add --upgrade font-noto-cjk
# 日本時間の構築
apk add tzdata
cp /usr/share/zoneinfo/Asia/Tokyo /etc/localtime


########################
#####    共通処理    ####
########################
# Get file path
CURRENT_PATH=`pwd`
# Output path
OUTPUT_PATH=${CURRENT_PATH}/public
# common path
COMMON_PATH=${CURRENT_PATH}/customs/common

set -x

# asciidoctor command arguments
# -a, --attribute = ATTRIBUTE
# -B, --base-dir = DIR
# -D, --destination-dir = DIR
# -o, --out-file = OUT_FILE
# -R, --source-dir = DIR
# -b, --backend = BACKEND
# -d, --doctype = DOCTYPE
# -r, --require = LIBRARY


# Common parameters & Attributes
COMMON_PARAMETERS=" -B ${CURRENT_PATH}/ -R ${CURRENT_PATH}/ -a diagram-cachedir=${OUTPUT_PATH}/diagram-cache -r asciidoctor-diagram -v --failure-level=ERROR --trace -r ${COMMON_PATH}/extensions/common-extensions.rb -a allow-uri-read "


########################
##### Output PDF   #####
########################
# PDF Output path
PDF_OUTPUT_PATH=${OUTPUT_PATH}/pdf
mkdir -p ${PDF_OUTPUT_PATH}
mkdir -p ${PDF_OUTPUT_PATH}/images
# PDF出力要素path
PDF_PARTS_PATH=${CURRENT_PATH}/customs/pdf
# parameters & Attributes
PDF_PARAMETERS=" -D ${PDF_OUTPUT_PATH}/ -a imagesdir=${CURRENT_PATH}/ -a imagesoutdir=${PDF_OUTPUT_PATH}/images/ -a chapter-label= -r ${PDF_PARTS_PATH}/diagram-configs/config.rb -a pdf-themesdir=${PDF_PARTS_PATH}/themes -a pdf-fontsdir=${PDF_PARTS_PATH}/fonts "
# convert
asciidoctor-pdf ${COMMON_PARAMETERS} ${PDF_PARAMETERS}  -a convert-for-all -a pdf-theme=${PDF_PARTS_PATH}/themes/user-analog-theme.yml 'index-*.adoc'

########################
##### Output HTML  #####
########################
# HTML Output path
HTML_OUTPUT_PATH=${OUTPUT_PATH}/html
mkdir -p ${HTML_OUTPUT_PATH}
# HTML出力要素path
HTML_PARTS_PATH=${CURRENT_PATH}/customs/html
# parameters & Attributes
HTML_PARAMETERS=" -D ${HTML_OUTPUT_PATH}/ -a imagesdir=images/ -a imagesoutdir=${HTML_OUTPUT_PATH}/images/ -a docinfodir=${HTML_PARTS_PATH}/docinfo -a nofooter "
# convert
asciidoctor ${COMMON_PARAMETERS} ${HTML_PARAMETERS} -a convert-for-all 'index*.adoc'
# サイト表示用の階層のためにコピー
cp -rf ./public/html/index.html ./public/index.html