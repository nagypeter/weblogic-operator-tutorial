# Pull base image
# ---------------
FROM store/oracle/weblogic:12.2.1.3-190111

ENV DOMAIN_NAME="sample-domain1"
ENV DOMAIN_HOME="/u01/oracle/user_projects/domains/${DOMAIN_NAME}"

USER root

RUN mkdir -p $DOMAIN_HOME && \
    chown -R oracle:oracle $DOMAIN_HOME && \
    chmod -R a+xwr $DOMAIN_HOME && \
    mkdir ${DOMAIN_HOME}/docker-build-tmp && \
    mkdir -p $DOMAIN_HOME/wlsdeploy/applications/

COPY scripts/* ${DOMAIN_HOME}/docker-build-tmp/

COPY target/opdemo.war $DOMAIN_HOME/wlsdeploy/applications/

RUN wlst.sh -skipWLSModuleScanning -loadProperties ${DOMAIN_HOME}/docker-build-tmp/datasource.properties \
      ${DOMAIN_HOME}/docker-build-tmp/model.py

RUN rm -rf ${DOMAIN_HOME}/docker-build-tmp && \
    chown -R oracle:oracle ${DOMAIN_HOME} && \
    chmod -R a+xwr ${DOMAIN_HOME}

WORKDIR ${DOMAIN_HOME}
