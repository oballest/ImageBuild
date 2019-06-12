FROM centos:7.2.1511
MAINTAINER Oscar Ballesteros <oballest@redhat.com>

RUN yum update -y && \
yum install -y --setopt=tsflags=nodocs \
augeas \
bsdtar \
iputils \
java-1.8.0-openjdk-devel \
less \
net-tools \
nmap-ncat \
procps-ng \
saxon \
tar \
traceroute \
unzip \
xmlstarlet && \
yum clean all

RUN groupadd -r jboss -g 1000 && useradd -u 1000 -r -g jboss -m -d /opt/jboss -s /sbin/nologin -c "JBoss user" jboss && \
chmod 755 /opt/jboss

WORKDIR /opt/jboss

USER jboss

### Add the environment variables below this line ###
ENV JAVA_HOME /usr/lib/jvm/java
ENV WILDFLY_VERSION 9.0.1.Final
ENV JBOSS_HOME /opt/jboss/wildfly
ENV WILDFLY_SHA1 abe037d5d1cb97b4d07fbfe59b6a1345a39a9ae5

RUN cd $HOME \
&& echo $HOME\
&& curl -s -O http://download.jboss.org/wildfly/9.0.1.Final/wildfly-9.0.1.Final.tar.gz \
&& tar xf wildfly-9.0.1.Final.tar.gz \
&& mv $HOME/wildfly-9.0.1.Final $JBOSS_HOME \
&& rm wildfly-9.0.1.Final.tar.gz

RUN /opt/jboss/wildfly/bin/add-user.sh admin jboss#1! --silent

EXPOSE 8080 9990

CMD ["/opt/jboss/wildfly/bin/standalone.sh", "-b", "0.0.0.0", "-bmanagement","0.0.0.0"]
