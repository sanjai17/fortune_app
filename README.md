# fortune_app

This repo contains the IAC code and steps used to bring up an ECS cluster with docker image from ECR

High-level Steps:

pre-requistes: I used an EC2 instance and installed Docker and terraform. From there, I have performed the below steps:


 1. Firstly, the docker image was generated from the repo --> https://github.com/wego/devops-fortune-api

 2. Then I have created ECR repository in my AWS account and pushed the docker image into the AWS ECR repository 

 3. Now, I broke down the bring up of an ECS cluster into three parts and used three terraform scripts to deploy the application to troubleshoot any issues if in-case.
    Below are the three parts/steps:
    1. network.tf --> I have deployed the Networking components required for the ECS cluster(VPC, Subnets, route-table, IGW)
    2. iam.tf --> I created an execution role and task role which is required to instantiate the ECS cluster.
    3. ecs.tf --> This is the actual terraform scripts used to create ecs cluster, task definition and ecs service.
   
  4. The service is up and running in the public IP address --> http://3.88.183.204:8080/healthcheck

Further, I mapped this public IP address to one of my sub-domains in R53 DNS--> http://fortune.sanjai.cloud:8080/


Curl results:

curl -v "http://fortune.sanjai.cloud:8080/"

*   Trying 3.88.183.204...
* TCP_NODELAY set
* Connected to fortune.sanjai.cloud (3.88.183.204) port 8080 (#0)
> GET / HTTP/1.1
> Host: fortune.sanjai.cloud:8080
> User-Agent: curl/7.55.1
> Accept: */*


Response headers:
================

< HTTP/1.1 200 OK
< date: Tue, 05 Mar 2024 10:58:39 GMT
< server: uvicorn
< content-length: 33
< content-type: application/json
<
{"Message":"API Running Success"}* Connection #0 to host fortune.sanjai.cloud left intact
