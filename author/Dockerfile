FROM ubuntu:14.04

MAINTAINER Marcus <marcus@dylanic.com>
# Set locales
RUN locale-gen en_GB.UTF-8
ENV LANG en_GB.UTF-8
ENV LC_CTYPE en_GB.UTF-8
ENV TOMCAT_VERSION 8.5.28
# Fix sh
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

# Install dependencies
RUN apt-get update && \
apt-get install -y git build-essential curl wget software-properties-common

# Install JDK 8
RUN \
echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
add-apt-repository -y ppa:webupd8team/java && \
apt-get update && \
apt-get install -y oracle-java8-installer wget unzip tar && \
rm -rf /var/lib/apt/lists/* && \
rm -rf /var/cache/oracle-jdk8-installer

# Define commonly used JAVA_HOME variable
ENV JAVA_HOME /usr/lib/jvm/java-8-oracle

ENV TZ=Europe/London
ENV JAVA_OPTS="-d64 -server -Djava.awt.headless=true -Xms2048M -Xmx6096M -XX:PermSize=128m -XX:MaxPermSize=512m"
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

ARG password
RUN mkdir -p /opt/cq && \
wget --quiet --no-cookies http://rshare:$password@rshare.rwcms.com/Install_assets/AEM_6.3_Quickstart.jar -O /opt/cq/cq-author-4502.jar && \
wget --quiet --no-cookies http://rshare:$password@rshare.rwcms.com/Install_assets/license.properties -O /opt/cq/license.properties
WORKDIR /opt/cq
ENV CQ_INTERFACE eth0 
ADD ./aemstartupcheck2.sh /opt/cq/
RUN ls -l ./aemstartupcheck2.sh
RUN sed -i -e 's/\r$//' aemstartupcheck2.sh
RUN ls -l ./aemstartupcheck2.sh
RUN /bin/bash /opt/cq/aemstartupcheck2.sh
WORKDIR /opt/cq/crx-quickstart/bin
RUN cp quickstart quickstart.original2
RUN cat quickstart.original2  | sed "s|1024|4096|g" > quickstart

EXPOSE 4502 8000
ENTRYPOINT ["/opt/cq/crx-quickstart/bin/quickstart"]

