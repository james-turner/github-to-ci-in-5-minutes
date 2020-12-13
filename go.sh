#!/usr/bin/env bash

CREDENTIALS_ARN=$(aws codestar-connections list-connections --provider-type-filter GitHub --max-results 10 --query "Connections[?ConnectionStatus=='AVAILABLE']|[0].ConnectionArn" --output text)
BRANCH=master
PROJECT_NAME=$(basename `pwd`)
REPOSITORY_ID=james-turner/$PROJECT_NAME
aws cloudformation deploy \
    --template-file aws/00-pipeline.yml \
    --stack-name $PROJECT_NAME-pipeline-$BRANCH \
    --parameter-overrides CredentialsArn=$CREDENTIALS_ARN \
        BranchName=$BRANCH \
        ProjectName=$PROJECT_NAME \
        RepositoryId=$REPOSITORY_ID \
    --capabilities CAPABILITY_NAMED_IAM
