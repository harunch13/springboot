FROM tomcat:9-jdk8

RUN mkdir -p /usr/local/tomcat/target \
    /usr/local/tomcat/conf/Catalina/localhost \
    && chown -R 1000:1000 /usr/local/tomcat/target \
    /usr/local/tomcat/conf/Catalina

COPY target/great-big-example-application-0.0.1.war \
     /usr/local/tomcat/webapps/great-big-example-application.war

USER 1000:1000

EXPOSE 8080

CMD ["catalina.sh", "run"]
