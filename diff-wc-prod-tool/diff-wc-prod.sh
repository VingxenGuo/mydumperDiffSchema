#!/bin/bash

BASEDIR=$(dirname "$0")
CONFIG_FILE=${BASEDIR}/diff-wc-prod.config
TARGET_PATH=${BASEDIR}/../mydumper-tool/backup

if [[ ! -f ${CONFIG_FILE} ]]; then
    echo "config file diff-wc-prod.config not found!"
    exit 0
fi

mkdir -p ${BASEDIR}/diff_result
rm -rf ${BASEDIR}/diff_result/*.tar.gz
rm -rf ${BASEDIR}/diff_result/*.diff.result.txt

while IFS=, read -r path1 path2
do
    DIFF_FILE_NAME_1=$(echo ${path1} | rev | cut -d '/' -f 1 | rev) 
    DIFF_FILE_NAME_2=$(echo ${path2} | rev | cut -d '/' -f 1 | rev) 
    OUTPUT_DIFF_FILE=${BASEDIR}/diff_result/${DIFF_FILE_NAME_1}.${DIFF_FILE_NAME_2}.diff.result.txt
    echo "diff ${DIFF_FILE_NAME_1} to ${DIFF_FILE_NAME_2}" > ${OUTPUT_DIFF_FILE}
    diff --exclude=metadata ${TARGET_PATH}/${path1}/latest/data ${TARGET_PATH}/${path2}/latest/data >> ${OUTPUT_DIFF_FILE}
done < ${CONFIG_FILE}

tar -zcf "${BASEDIR}/diff_result/$(date '+%Y%m%d%H%M%S').diff_wc_prod.tar.gz" ${BASEDIR}/diff_result/*.diff.result.txt
python3 $BASEDIR/sendmail.py ${BASEDIR}/diff_result/*.tar.gz