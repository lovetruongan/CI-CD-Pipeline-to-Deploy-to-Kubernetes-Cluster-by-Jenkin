# AWS CI-CD-Pipeline-to-Deploy-to-Kubernetes-Cluster-by-Jenkin

## Part 1 : Create Server Jenkin
- Go to AWS and create EC2 instance using Amazon Linux
- ssh and install jenkin using scripts or command
- https://www.jenkins.io/doc/tutorials/tutorial-for-installing-jenkins-on-AWS/
- Change hostname and add security group on port 8080
- Use java-11-amazon-correcto

## Part 2 : Install Maven
- install maven 3.9.6 on https://maven.apache.org/download.cgi
- Change .bash_profile
M2_HOME=/opt/maven
M2=/opt/maven/bin
/usr/lib/jvm/java-11-openjdk-11.0.22.0.7-1.amzn2.0.1.x86_64
- Setup Maven Plugin in Jenkin Web
- Test build maven
- add playbook to server

## Part 3 : Setup Ansible server
- Go to AWS and create EC2 name Ansible-Server
- Access ssh and create ansadmin user with password ...
- use Ansible create keygen to connect to Bootstrap server
- sudo -i and install ansible
- Setup ssh server in jenkin server
- create job {copy artifact onto ansible } to test
- install docker and write docker file for app
### Create ansible playbook to Create Docker image and copy image to DockerHub
- change file /etc/ansible/hosts to 
```
[ansible]
local-host-ip
```
```
ssh-copy-id local-host-ip
```
- Create ansible-playbook name reapp.yml
```
- hosts: ansible

  tasks:
  - name: create docker image
    command: docker build -t regapp:latest .
    args:
     chdir: /opt/Docker

  - name: create tag to push image onto dockerhub
    command: docker tag regapp:latest lovetruongan/regapp:latest

  - name: push docker image
    command: docker push lovetruongan/regapp:latest

```
- run playbook
## Part 4 : Create EKS server
- Create EC2 EKS instance in AWS
- [Install AWS CLi](doc:https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
- [Install kubectl](doc:https://docs.aws.amazon.com/eks/latest/userguide/install-kubectl.html)
- [install EKS](doc:https://github.com/eksctl-io/eksctl/blob/main/README.md#installation)
- Create Eksctl role
- add role to Ec2 EKS_Bootstrap-Server
- Setup Kubernetes using eksctl
```
eksctl create cluster --name virtualtechbox-cluster \
--region ap-south-1 \
--node-type t2.small \
```
### Create deployment Manifest File
regapp-deployment.yml
```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: virtualtechbox-regapp
  labels:
     app: regapp

spec:
  replicas: 2
  selector:
    matchLabels:
      app: regapp

  template:
    metadata:
      labels:
        app: regapp
    spec:
      containers:
      - name: regapp
        image: ashfaque9x/regapp
        imagePullPolicy: Always
        ports:
        - containerPort: 8080
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxSurge: 1
      maxUnavailable: 1
```
### Create Service Manifest File
regapp-service.yml
```
apiVersion: v1
kind: Service
metadata:
  name: virtualtechbox-service
  labels:
    app: regapp 
spec:
  selector:
    app: regapp 

  ports:
    - port: 8080
      targetPort: 8080

  type: LoadBalancer
```
## Part 5 : Integrate Bootstrap Server with Ansible
- Set passwd root and add kubernetes server IP to /etc/ansible/hosts
- copy id to EKS_Bootstrap-Server
``` ssh-copy-id root@BootStrap-Server-IP` ``
- Create Ansible playbook to run deployment and service manifest
```
- hosts: kubernetes
  user: root

  tasks:
    - name: deploy regapp on kubernetes
      command: kubectl apply -f regapp-deployment.yml

    - name: create service for regapp
      command: kubectl apply -f regapp-service.yml

    - name: update deployment with new pods if image updated in docker hub
      command: kubectl rollout restart deployment.apps/virtualtechbox-regapp
```
## Part 6 : Setup CICD in jenkins
- add CI job by deploy to Kubernetes
- Add Webhook or Poll SCM to get the Repository change
- Test ...

![Website](<Screenshot 2024-03-11 205940.png>)

![Docker](<Screenshot 2024-03-11 203924.png>)

![Jenkins](<Screenshot 2024-03-11 203630.png>)

![AWS](<Screenshot 2024-03-11 203514.png>)

![ALL](<Screenshot 2024-03-11 203924.png>)