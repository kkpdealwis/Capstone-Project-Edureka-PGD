FROM tomcat:latest

COPY target/XYZtechnologies-1.0.war /usr/local/tomcat/webapps/

EXPOSE 8080