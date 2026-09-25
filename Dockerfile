FROM tomcat:9.0-jdk1
COPY target/*.war /usr/local/tomcat/webapps/maven-web-app.war
EXPOSE 8080
CMD ["catalina.sh", "run"]
