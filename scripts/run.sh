# /bin/bash

INSTANCE_DIR=${APACHEDS_DATA}/${INSTANCE_ID}
INSTANCE_CONF_DIR=${INSTANCE_DIR}/conf 

if [ "${INSTANCE_ID}" != "default" ]; then
  # user requested a non default instance id  
  echo Checking "${INSTANCE_DIR}" ....
  if [ -d ${INSTANCE_DIR} ]; then
    echo Instance already setup ...
  else    
    echo Setting up new instance with id "${INSTANCE_ID}" in ${INSTANCE_DIR} ...

    # build folder structure for instance
    mkdir ${INSTANCE_DIR} \
     ${INSTANCE_DIR}/cache \
     ${INSTANCE_DIR}/conf \
     ${INSTANCE_DIR}/log \
     ${INSTANCE_DIR}/partitions \
     ${INSTANCE_DIR}/run

    cp ${INSTANCE_TEMPLATE_DIR}/* ${INSTANCE_CONF_DIR}    

    # build context entry for root domain
    IFS=\, read -a parts <<< "${BASE_DN}"
    IFS=\= read -a dc <<< "${parts[0]}"

    printf "dn: %s\n" ${BASE_DN} > temp.txt
    printf "dc: %s\n" ${dc[1]} >> temp.txt
    printf "objectclass: domain\n" >> temp.txt
    printf "objectclass: top\n\n" >> temp.txt

    CONTEXT_ENTRY=`cat temp.txt | base64 -w 0`

    # build transformation commands
    echo "s/{PARTITION_ID}/${PARTITION_ID}/g" > ${INSTANCE_CONF_DIR}/sed-commands.txt
    echo "s/{BASE_DN}/${BASE_DN}/g" >> ${INSTANCE_CONF_DIR}/sed-commands.txt
    echo "s/{KERBEROS_PRIMARY_REALM}/${KERBEROS_PRIMARY_REALM}/g" >> ${INSTANCE_CONF_DIR}/sed-commands.txt
    echo "s/{CONTEXT_ENTRY}/${CONTEXT_ENTRY}/g" >> ${INSTANCE_CONF_DIR}/sed-commands.txt

    # apply transformations to config.ldif
    sed -i -f ${INSTANCE_CONF_DIR}/sed-commands.txt ${INSTANCE_CONF_DIR}/config.ldif

    # change ownership of all files
    chown -v -R apacheds:apacheds ${INSTANCE_DIR}
  fi
fi

echo Starting ...
/opt/apacheds-${APACHEDS_VERSION}/bin/apacheds console "${INSTANCE_ID}"