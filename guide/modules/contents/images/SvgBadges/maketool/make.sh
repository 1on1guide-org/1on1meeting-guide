#!/bin/bash
# data.csvの定義とアイコンの組み合わせ分のsvgを作るよ

set -eu

TOOL_DIR=$(cd $(dirname $0); pwd)
ALL=`cat ${TOOL_DIR}/all.svg`
CHECK=`cat ${TOOL_DIR}/check.svg`
EYE=`cat ${TOOL_DIR}/eye.svg`
PEN=`cat ${TOOL_DIR}/pen.svg`
USER=`cat ${TOOL_DIR}/user.svg`
SMARTPHONE=`cat ${TOOL_DIR}/smartphone.svg`
BADGES_DIR=${TOOL_DIR/SvgBadges\/maketool/SvgBadges\/badges}

echo "TOOL_DIR: ${TOOL_DIR}"

while IFS=, read data value
do
    eval $data=$value
done <  ${TOOL_DIR}/size.csv

# size.csv
# FULLLEN = パディング含めて定義された全体長の調整幅
# STEPLEN = 一文字の長さ
# CLASSLEN = 略称文字列長の調整幅
# NAMELEN = 名称文字列長の調整幅
# NAMEPOSI = 色の変わり目の調整幅
# data.csv
# id = 略称でファイル名に出力
# code = 略称でSVGに出力
# name = 名称でSVGに出力
# cnum = 略称文字列長
# nnum = 名称文字列長
# color = 名称部の背景色

while IFS=, read id code name cnum nnum color
do

    TEMP=$ALL
    NUMLEN=`echo " scale=5; ${nnum} * ${STEPLEN} " | bc`
    NAMELENNUM=`echo " scale=5; ${NUMLEN} + ${NAMELEN} " | bc`
    CLASSLENNUM=`echo " scale=5; ${cnum} * ${STEPLEN} + ${CLASSLEN} " | bc`
    NAMEPOSINUM=`echo " scale=5; ${CLASSLENNUM} + ${NAMEPOSI} " | bc`
    FULLLENNUM=`echo " scale=5; ${NAMEPOSINUM} + ${NAMELENNUM} + ${FULLLEN} " | bc`

    TEMP=${TEMP//\{%cord%\}/${code}}
    TEMP=${TEMP//\{%name%\}/${name}}
    TEMP=${TEMP//\{%color%\}/${color}}
    TEMP=${TEMP//\{%full-length%\}/${FULLLENNUM}}
    TEMP=${TEMP//\{%name-length%\}/${NAMELENNUM}}
    TEMP=${TEMP//\{%class-length%\}/${CLASSLENNUM}}
    TEMP=${TEMP//\{%name-position%\}/${NAMEPOSINUM}}

    echo ${TEMP} | sed -e "s|{%icon%}|$CHECK|g" > "${BADGES_DIR}/badge-user-${id}-check.svg"
    echo ${TEMP} | sed -e "s|{%icon%}|$EYE|g" > "${BADGES_DIR}/badge-user-${id}-eye.svg"
    echo ${TEMP} | sed -e "s|{%icon%}|$PEN|g" > "${BADGES_DIR}/badge-user-${id}-pen.svg"
    echo ${TEMP} | sed -e "s|{%icon%}|$USER|g" > "${BADGES_DIR}/badge-user-${id}-user.svg"
    echo ${TEMP} | sed -e "s|{%icon%}|$SMARTPHONE|g" > "${BADGES_DIR}/badge-user-${id}-smartphone.svg"

done < ${TOOL_DIR}/data.csv