FROM java:7u111-jre

#######################################
# Docker file build arguments
#######################################
ARG APACHEDS_VERSION=2.0.0-M24

#######################################
# User customizable environment variables
#######################################
ENV INSTANCE_ID=default
ENV PARTITION_ID=example
ENV BASE_DN=dc=example,dc=com
ENV KERBEROS_PRIMARY_REALM=EXAMPLE.COM
ENV SASL_HOST=ldap.example.com
ENV SASL_PRINCIPAL=ldap/ldap.example.com@EXAMPLE.COM
ENV SASL_REALM=example.com

#######################################
# Env variables used through building and bootstrapping
#######################################
ENV APACHEDS_VERSION=${APACHEDS_VERSION}
ENV APACHEDS_DATA=/var/lib/apacheds-${APACHEDS_VERSION}
ENV INSTANCE_TEMPLATE_DIR=/template

RUN apt-get update \
    && apt-get install -y wget ldap-utils

WORKDIR /tmp

RUN wget http://www-eu.apache.org/dist/directory/apacheds/dist/${APACHEDS_VERSION}/apacheds-${APACHEDS_VERSION}-amd64.deb \
    && chmod +x apacheds-${APACHEDS_VERSION}-amd64.deb \
    && dpkg -i apacheds-${APACHEDS_VERSION}-amd64.deb

WORKDIR /

ADD ./instance ${INSTANCE_TEMPLATE_DIR}
ADD scripts/run.sh /run.sh

ENTRYPOINT [ "/bin/bash" ]
CMD [ "/run.sh" ]