FROM tomcat:8-jre8

ENV TZ=Europe/Oslo
ENV CATALINA_OPTS="-Xmx2048m"
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN mkdir /usr/local/tomcat/fusekiDownloadTemp
RUN mkdir /etc/fuseki/
RUN mkdir /etc/fuseki/databases/
RUN mkdir /etc/fuseki/databases/dataservice/
RUN mkdir /etc/fuseki/databases/dataservice-catalog/

ADD apache-jena-fuseki-3.9.0.zip /usr/local/tomcat/fusekiDownloadTemp

ADD tomcat-users.xml /usr/local/tomcat/conf/
ADD server.xml /usr/local/tomcat/conf/

RUN chmod 755 -R /usr/local/tomcat/conf
RUN chmod 775 -R /usr/local/tomcat/logs
RUN chmod 775 -R /usr/local/tomcat/temp
RUN chmod 775 -R /usr/local/tomcat/webapps
RUN mkdir /usr/local/tomcat/conf/Catalina
RUN chmod 775 -R /usr/local/tomcat/conf/Catalina
RUN chmod 775 -R /usr/local/tomcat/work
RUN chmod 775 -R /etc/fuseki/databases

WORKDIR /usr/local/tomcat/fusekiDownloadTemp/

RUN unzip -o /usr/local/tomcat/fusekiDownloadTemp/apache-jena-fuseki-3.9.0.zip

RUN mv /usr/local/tomcat/fusekiDownloadTemp/apache-jena-fuseki-3.9.0/fuseki.war /usr/local/tomcat/webapps/fuseki.war

RUN chmod 777 -R /usr/local/tomcat/webapps

ADD dataservice-config.ttl /etc/fuseki/configuration/
ADD dataservice-catalog-config.ttl /etc/fuseki/configuration/
ADD shiro.ini /etc/fuseki/
RUN chmod 775 -R /etc/fuseki

WORKDIR /usr/local/tomcat/
