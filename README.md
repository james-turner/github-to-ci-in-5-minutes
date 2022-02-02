# Github to CI in 5 minutes

## Bootstrapping

### Do you have valid Github credentials?
Run the following command, results then you already have a valid github connection, and you can skip to the "Initial deploy once credentials are provisioned" section.

    aws codestar-connections list-connections \
        --provider-type-filter GitHub --max-results 10 \
        --query "Connections[?ConnectionStatus=='AVAILABLE']"

### If you don't have a valid Github Auth (skip this if you have valid credentials)

In order to boostrap this whole process you require credentials access to the repository that will be used for the source code. https://docs.aws.amazon.com/cli/latest/reference/codestar-connections/create-connection.html

Unfortunately the only way to generate a valid codestar connection for Github (as of 2020-02-18) is to do it through the AWS UI (console). - Start at https://eu-west-1.console.aws.amazon.com/codesuite/codepipeline/pipeline/new?region=eu-west-1 - Fill in a dummy pipeline name and role name, choose Next - Choose "GitHub (Version 2)" as your source provider
- Click on the "Connect to Github Cloud" - In the pop-up window give it a connection name (something like "Github") and choose to "Install a new app" - This should generate an "AWS Codestar" app inside Github (which will allow an app to be placed). - Once you've completed this step choose the "Connect" button in the popup and it'll generate a valid connection for which it will give you an ARN. - You can then "Cancel" this pipeline.

Now verify you have a valid AVAILABLE Github connection:

    aws codestar-connections list-connections \
        --provider-type-filter GitHub --max-results 10 \
        --query "Connections[?ConnectionStatus=='AVAILABLE']"

### Initial deploy once credentials are provisioned

After these credentials have been obtained you can create the first stack which will then do the rest.

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
