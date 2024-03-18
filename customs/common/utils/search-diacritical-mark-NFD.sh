#!/bin/bash
# set -e をするとgrepのnotfoundで止まるよ
set -u

TOOL_DIR=$(cd $(dirname $0); pwd)
INDEX_DIR=${TOOL_DIR%%\/customs\/common\/utils}

echo ${TOOL_DIR}
echo ${INDEX_DIR}

STATUS=0

# 濁点「 ゙ 」を検索
LOG_ARRAY=`grep -rn '゙' ${INDEX_DIR}`
for LOG in ${LOG_ARRAY}
do
  # BusyBoxのgrepは--includeが使えないので後判断
  if [[ ${LOG} =~ .*.adoc.* ]]
  then
    echo "ERROR: Unicode normalization NFD! diacritical mark exists. 「 ゙ 」 ${LOG}" >&2
    STATUS=1
  fi
done

# 半濁点「 ゚ 」を検索
LOG_ARRAY=`grep -rn '゚' ${INDEX_DIR}`

for LOG in ${LOG_ARRAY}
do
  # BusyBoxのgrepは--includeが使えないので後判断
  if [[ ${LOG} =~ .*.adoc.* ]]
  then
    echo "ERROR: Unicode normalization NFD! diacritical mark exists. 「 ゚ 」 ${LOG}" >&2
    STATUS=1
  fi
done

exit ${STATUS}
