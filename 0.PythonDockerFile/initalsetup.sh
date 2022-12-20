#!/bin/bash

if [ $# -eq 0 ]; then
   echo "No arguments supplied"
   echo "Usage:<script name>  repo, tag"
   exit 1
fi

declare -r Region=$1
declare -r Repo=$2
declare -r Tag="${3:-latest}"
declare -r BuildPath="./build-images/${Repo}"
 
# aws ecr create-repository --repository-name $Repo --region us-east-2
out=$(aws ecr describe-repositories --repository-names ${Repo} 2>/dev/null)
Status=$?
if [ $Status -gt 0 ]; then
   out=$(aws ecr create-repository --repository-name ${Repo} --region us-east-2) 
   RepoURI=$(echo $out | jq -r '.repository.repositoryUri')
   aws ecr put-lifecycle-policy --repository-name ${Repo} \
       --lifecycle-policy-text file://./ecr-lifecycle-policy.json --region us-east-2
else
   RepoURI=$(echo $out | jq -r '.repositories[0].repositoryUri')
fi

echo $RepoURI

if [ -z $RepoURI ]; then
   echo "Error for ${Repo}"
   exit 1
fi

Registry=$(echo $RepoURI | sed "s/\/$Repo//")
echo $Registry

aws ecr get-login-password --region us-east-2 | docker login --username AWS --password-stdin $Registry
Status=$?
if [ $Status -gt 0 ]; then
   echo "ecr login failed"
   exit 1;
fi

cd $BuildPath

docker build -t ${Repo}:${Tag} . 
Status=$?
if [ $Status -gt 0 ]; then
   echo "Build failed for ${Repo}"
   exit 1;
fi

docker tag $Repo:$Tag ${RepoURI}:${Tag}
docker push ${RepoURI}:${Tag}
Status=$?
if [ $Status -gt 0 ]; then
   echo "image push failed for ${Repo}"
   exit 1;
fi

exit 0;
