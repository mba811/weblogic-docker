# LICENSE CDDL 1.0 + GPL 2.0
#
# ORACLE DOCKERFILES PROJECT
# --------------------------
# This is the Dockerfile for WebLogic 12.1.3 ZIP Distro
# 
# REQUIRED BASE IMAGE TO BUILD THIS IMAGE
# ---------------------------------------
# Make sure you have oraclelinux:7.0 Docker image installed.
# Visit for more info: http://public-yum.oracle.com/docker-images/
#
# REQUIRED FILES TO BUILD THIS IMAGE
# ----------------------------------
# (1) wls1213_dev.zip
#     Download from http://www.oracle.com/technetwork/middleware/weblogic/downloads/index.html
#
# (2) jdk-8u25-linux-x64.rpm
#     Download from http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html
#
# HOW TO BUILD THIS IMAGE
# -----------------------
# Put all downloaded files in the same directory as this Dockerfile
# Run: 
#      $ sudo sh build.sh
#

# Pull base image
# ---------------
FROM oraclelinux:7.0

# Maintainer
# ----------
MAINTAINER Bruno Borges <bruno.borges@oracle.com>

# Environment variables required for this build (do NOT change)
ENV JAVA_RPM jdk-8u25-linux-x64.rpm
ENV WLS_ZIP  wls1213_dev.zip
ENV WLS_DIR wls12130

# WLS Admin Password (you may change)
# This password is used for:
#  (a) 'weblogic' admin user of WebLogic 
#  (b) 'oracle' Linux user in this image
# -----------------------------------
ENV WLS_ADMIN_PASSWORD welcome1

# Install and configure Oracle JDK 8u25
# -------------------------------------
ADD $JAVA_RPM /root/
RUN rpm -i /root/$JAVA_RPM
ENV JAVA_HOME /usr/java/default
ENV CONFIG_JVM_ARGS -Djava.security.egd=file:/dev/./urandom

# Setup required packages (unzip), filesystem, and oracle user
# ------------------------------------------------------------
# Enable this if behind proxy
# RUN sed -i -e '/^\[main\]/aproxy=http://proxy.com:80' /etc/yum.conf
RUN yum install -y unzip
RUN mkdir /u01
RUN chmod a+x /u01
RUN chmod a+r /u01
RUN useradd -b /u01 -m -s /bin/bash oracle
RUN echo oracle:$WLS_ADMIN_PASSWORD | chpasswd

# Add files required to build this image
ADD $WLS_ZIP /u01/
ADD container-scripts/jaxrs2-template.jar /u01/
ADD container-scripts/create-wls-domain.py /u01/
ADD container-scripts/commEnv.sh /u01/oracle/
ADD container-scripts/add-machine.py /u01/oracle/
ADD container-scripts/createMachine.sh /u01/oracle/

# Adjust file permissions, go to /u01 as user 'oracle' to proceed with WLS installation
RUN chown oracle:oracle -R /u01
WORKDIR /u01
USER oracle

# Installation of Weblogic 
RUN unzip /u01/$WLS_ZIP -d /u01/oracle/ > /dev/null
RUN ln -s /u01/oracle/$WLS_DIR /u01/oracle/weblogic
WORKDIR /u01/oracle/$WLS_DIR
RUN sh configure.sh -silent
RUN /u01/oracle/$WLS_DIR/wlserver/common/bin/wlst.sh -skipWLSModuleScanning /u01/create-wls-domain.py
RUN mkdir -p /u01/oracle/$WLS_DIR/user_projects/domains/base_domain/servers/AdminServer/security
RUN cp /u01/oracle/commEnv.sh /u01/oracle/$WLS_DIR/wlserver/common/bin/commEnv.sh
RUN echo "username=weblogic" > /u01/oracle/$WLS_DIR/user_projects/domains/base_domain/servers/AdminServer/security/boot.properties
RUN echo "password=$WLS_ADMIN_PASSWORD" >> /u01/oracle/$WLS_DIR/user_projects/domains/base_domain/servers/AdminServer/security/boot.properties
RUN rm /u01/create-wls-domain.py /u01/$WLS_ZIP /u01/jaxrs2-template.jar
RUN echo ". /u01/oracle/$WLS_DIR/user_projects/domains/base_domain/bin/setDomainEnv.sh" >> /u01/oracle/.bashrc
RUN echo "export PATH=$PATH:/u01/oracle/$WLS_DIR/user_projects/domains/base_domain/bin" >> /u01/oracle/.bashrc

# Expose Node Manager default port, and also default http/https ports for admin console
EXPOSE 5556 7001 7002

# Make sure root has also right PATH and WLS environment variables configured
USER root
RUN echo ". /u01/oracle/$WLS_DIR/user_projects/domains/base_domain/bin/setDomainEnv.sh" >> /root/.bashrc
RUN echo "export PATH=$PATH:/u01/oracle/$WLS_DIR/user_projects/domains/base_domain/bin" >> /root/.bashrc

# WORKDIR /u01/oracle/home

# Define default command to start bash. 
CMD ["/u01/oracle/$WLS_DIR/user_projects/domains/base_domain/bin/startWebLogic.sh"]
