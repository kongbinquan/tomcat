FROM kbqallan/jdk:1.8.0
MAINTAINER kbqallan(443831995@qq.com)

ARG TOMCAT_MAJOR=${TOMCAT_MAJOR:-8}
ARG TOMCAT_VERSION=${TOMCAT_VERSION:-8.5.23}

ENV TOMCAT_HOME=/opt/tomcat \
	CATALINA_HOME=/opt/tomcat \
	CATALINA_OUT=/dev/null \
	DEPLOY_DIR=/data/webapps \
	LIBS_DIR=/libs \
	LANG=zh_CN.UTF-8 \
	TERM=linux

RUN set -ex && \
[ ! -d ${TOMCAT_HOME} ] && mkdir -p ${TOMCAT_HOME} && \
[ ! -d ${DEPLOY_DIR} ] && mkdir -p ${DEPLOY_DIR} && \
yum update &&\
yum -y install curl chown  && \
TomcatUrl="http://archive.apache.org/dist/tomcat/tomcat-${TOMCAT_MAJOR}/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz" && \
curl -jkSL ${TomcatUrl} | tar xz -C /opt/tomcat --strip-components=1 && \
groupadd -g 433 tomcat && \
useradd -u 433 -h ${CATALINA_HOME} -s /sbin/nologin  tomcat && \
chown -R 433.433 ${CATALINA_HOME}/ && \
rm -rf /tmp/* /var/lib/{apt,dpkg,cache,log}/*

ENV PATH=$CATALINA_HOME/bin:$PATH \
	JAVA_MAXMEMORY=256 \
	TOMCAT_MAXTHREADS=250 \
	TOMCAT_MINSPARETHREADS=4 \
	TOMCAT_HTTPTIMEOUT=20000 \
	TOMCAT_JVM_ROUTE=tomcat80

COPY conf/ ${CATALINA_HOME}/conf/
COPY bin/ ${CATALINA_HOME}/bin/

EXPOSE 8080
EXPOSE 8009

#USER tomcat
CMD ["/opt/tomcat/bin/tomcat.sh"]
