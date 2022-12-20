# Solution for Programming Task
### Here is my high-level approach
- Created a python script to check 1000 of URLs.
- Created Docker Image and injected python script into it.
- Created EKS Cluster from scratch like, `VPC, Subnet, Routes, LaunchTemplate, ASG, NodeGroups, Workers nodes, IAM, ServiceAccount, AWSLoadBalancerController.`
- Created a cronjob with PVC Claim which will run every 10 mins and stores the output file in PVC.
- Created a nginx-deployment which will be reading the output file.   
- Created a service and expose port 8080 and create ingress and type as LoadBalancer which will create external loadbalancer.



### Pre-requisite:
- Install terraform binary >= Terraform v1.3.0. From the website. `https://developer.hashicorp.com/terraform/downloads`
- Install docker, awscli, 
- Export AWS Credentials in the terminal that you are planning to execute terraform.
- We are performing all these exercise in `US-EAST-2` Region
> Note: Not consider the above setup via pipeline as it consumes more time and resource

### Steps to implement the solutions:
1) Solution is uploaded into my github. Please do git clone of `git clone https://github.com/dheepansn/ekscluster.git`
2) Navigate to ekscluster folder and `cd 0.PythonDockerFile`
3) Execute `bash -x initalsetup.sh <Repo_name> <Tag_name>` It will create ecr repo and create a new Docker Image and push it to newly created repo.
    ```
    FROM python:3.6.2-slim
    MAINTAINER Dheepan Swaminathan <dheepanswaminathan@gmail.com>
    LABEL Quickly serve SPH Monitoring and  Files using Python http.server module.
    COPY urlmonitoring.py .
    COPY url.csv .
    RUN pip3 install requests
    RUN pip3 install pandas
    ENTRYPOINT [ "python3", "urlmonitoring.py" ]
    ```
4) Navigate to 1.sph-eks-cluster and execute the below commands.
    ```
    Terraform init
    Terraform plan  (Make sure, it create all the resources for EKS Cluster.)
    Terraform apply -auto-approve 
    ```
5) Navigate to 2.sph-deploy-nginx and execute the below commands.
    ```
    Terraform init
    Terraform plan  (Make sure, it create all the nginx deployment and service for EKS Cluster.)
    Terraform apply -auto-approve 
    ```
6)	Execute the bash script 3.deploy_cronjob_pvc.sh. This script will create a cronjob and PVC.
    `bash -x 3.deploy_cronjob_pvc.sh`


