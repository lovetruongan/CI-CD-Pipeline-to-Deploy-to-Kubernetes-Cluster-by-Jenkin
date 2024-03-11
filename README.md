# AWS SImple CICD

## Part 1 : Create Server Jenkin
- Go to AWS and create EC2 instance using Amazon Linux
- ssh and install jenkin using scripts or command
- https://www.jenkins.io/doc/tutorials/tutorial-for-installing-jenkins-on-AWS/
- Change hostname and add security group on port 8080

## Part 2 : Install Maven
- install maven 3.9.6 on https://maven.apache.org/download.cgi
- Change .bash_profile
M2_HOME=/opt/maven
M2=/opt/maven/bin
/usr/lib/jvm/java-11-openjdk-11.0.22.0.7-1.amzn2.0.1.x86_64
- Setup Maven Plugin in Jenkin Web
- Test build maven

## Part 3 : Setup Tomcat server
- Create EC2 instance and add sc 8080
- install java 11 and tomcat
- Edit 2 file /opt/tomcat/webapps/host-manager/META-INF/context.xml and /opt/tomcat/webapps/manager/META-INF/context.xml
- add user in conf/tomcat-users.xml
```
 <role rolename="manager-gui"/>
 <role rolename="manager-script"/>
 <role rolename="manager-jmx"/>
 <role rolename="manager-status"/>
 <user username="admin" password="admin" roles="manager-gui, manager-script, manager-jmx, manager-status"/>
 <user username="deployer" password="deployer" roles="manager-script"/>
 <user username="tomcat" password="s3cret" roles="manager-gui"/>
```
## Part 4 : Build Maven project in Jenkin
- Create new Credentials
- install deploy on containers
- Automate build and deploy using poll SCM and verify CICD

![Done](<Screenshot 2024-03-07 012921-1.png>)