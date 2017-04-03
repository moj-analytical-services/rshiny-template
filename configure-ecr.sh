#!/bin/bash
aws configure set default.region ${AWS_REGION}

if ! aws ecr describe-repositories --repository-names ${CI_REPO_NAME} > /dev/null 2>&1;
    then aws ecr create-repository --repository-name ${CI_REPO_NAME};
fi
