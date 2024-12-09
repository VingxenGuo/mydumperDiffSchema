#!/bin/bash
BASEDIR=$(dirname "$0")

if [[ -z $1 ]]; then
    echo bash ./dumper.sh {CONFIG_FILE_NAME}
    exit
fi
CONFIG_FILE=${BASEDIR}/$1

if [[ ! -f ${CONFIG_FILE} ]]; then
    echo "${CONFIG_FILE} config file not exists"
    exit
fi

echo read config file from: ${CONFIG_FILE}

OUTPUT_DIR=${BASEDIR}/backup/$1
# Clear diff_result and tar.gz files and create diff_result folder if not exists
rm -rf ${OUTPUT_DIR}/diff_result/*.tar.gz
rm -rf ${OUTPUT_DIR}/diff_result/*.diff.result.txt
mkdir -p ${OUTPUT_DIR}/diff_result/

while IFS=, read -r product host port user pass
do
    if [[ -z "${product}" ]]; then
        continue
    fi 

    # Create product latest dump folder if not exists
    mkdir -p ${OUTPUT_DIR}/${product}/latest
    echo ${product} | tee ${OUTPUT_DIR}/diff_result/${product}.diff.result.txt
    echo "Start Compare Schema At: $(date)" | tee -a ${OUTPUT_DIR}/diff_result/${product}.diff.result.txt

    # Remove product previous dump folder
    rm -rf ${OUTPUT_DIR}/${product}/previous

    # Move latest foler to previous folder
    mv ${OUTPUT_DIR}/${product}/latest ${OUTPUT_DIR}/${product}/previous

    # Create new product latest dump folder
    mkdir -p ${OUTPUT_DIR}/${product}/latest

    # Copy omit file from BASEDIR
    cp ${BASEDIR}/omit_file.txt ${OUTPUT_DIR}/${product}/latest/omit_file.txt

    if [[ -f "${BASEDIR}/use-docker" ]]; then
        docker run --name mydumper --rm -v ${OUTPUT_DIR}/${product}/latest:/backups mydumper/mydumper sh -c "rm -rf /backups/data; mydumper --host ${host} --port ${port} --user ${user} --password '${pass}' -o /backups/data --verbose=3 --no-data --triggers --events --routines --trx-consistency-only --build-empty-files --threads=4 --omit-from-file=/backups/omit_file.txt --logfile=/backups/mydumper.log; sed -i -E 's/(AUTO_INCREMENT=[0-9]+)//g' /backups/data/*.sql"
    else
        mydumper --host ${host} --port ${port} --user ${user} --password "${pass}" -o ${OUTPUT_DIR}/${product}/latest/data --verbose=3 --no-data --triggers --events --routines --trx-consistency-only --build-empty-files --threads=4 --omit-from-file=${OUTPUT_DIR}/${product}/latest/omit_file.txt --logfile=${OUTPUT_DIR}/${product}/latest/mydumper.log;
        sed -i -E 's/(AUTO_INCREMENT=[0-9]+)//g' ${OUTPUT_DIR}/${product}/latest/data/*.sql
    fi

    diff --exclude=metadata ${OUTPUT_DIR}/${product}/previous/data ${OUTPUT_DIR}/${product}/latest/data >> ${OUTPUT_DIR}/diff_result/${product}.diff.result.txt
    echo "End At: $(date)" | tee -a ${OUTPUT_DIR}/diff_result/${product}.diff.result.txt
done < ${CONFIG_FILE}
tar -zcf "${OUTPUT_DIR}/diff_result/$(date '+%Y%m%d%H%M%S').tar.gz" ${OUTPUT_DIR}/diff_result/*.diff.result.txt

python3 $BASEDIR/sendmail.py 