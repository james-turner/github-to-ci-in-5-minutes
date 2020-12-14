#!/usr/bin/env bash

CREDENTIALS_ARN=$(aws codestar-connections list-connections --provider-type-filter GitHub --max-results 10 --query "Connections[?ConnectionStatus=='AVAILABLE']|[0].ConnectionArn" --output text)
BRANCH=$(git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/')
PROJECT_NAME=$(basename `pwd`)
REPOSITORY_OWNER=$(git remote -v | grep push | cut -d ':' -f2 | cut -d '/' -f1)
REPOSITORY_ID=$REPOSITORY_OWNER/$PROJECT_NAME
aws cloudformation deploy \
    --template-file aws/00-pipeline.yml \
    --stack-name $PROJECT_NAME-pipeline-$BRANCH \
    --parameter-overrides CredentialsArn=$CREDENTIALS_ARN \
        BranchName=$BRANCH \
        ProjectName=$PROJECT_NAME \
        RepositoryId=$REPOSITORY_ID \
    --capabilities CAPABILITY_NAMED_IAM
