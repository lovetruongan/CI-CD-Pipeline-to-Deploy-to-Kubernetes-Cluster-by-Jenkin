FROM tomcat:latest
//Deploy on tomcat
RUN cp -R  /usr/local/tomcat/webapps.dist/*  /usr/local/tomcat/webapps
//Copy contents to folder Webapps
COPY ./*.war /usr/local/tomcat/webapps
//Copy from artifacts to folder webapps
