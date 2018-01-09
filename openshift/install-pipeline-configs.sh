#!/bin/bash

echo "Alrighty now I'm going to install all those openshift configs"
echo "...Before we continue please make sure your openshift cluster is up and running."
echo "If you're not sure how to do this, just type 'oc cluster up' and wait for it to start properly before continuing."
echo "You're about to asked a bunch of questions about your deployemnt, just accept the defaults if you're not sure."
echo "Are you read to continue? y/n"

read continue;

if [ "$continue" == "y" ]; then

    echo 'Project Name: (default: myproject)'
    read PROJECT_NAME

    if [ -z "$PROJECT_NAME" ]; then
        PROJECT_NAME='myproject'
    fi

    echo 'Service Name: (default: openshift-jenkins-nodejs-example)'
    read SERVICE_NAME

    if [ -z "$SERVICE_NAME" ]; then
        SERVICE_NAME='openshift-jenkins-nodejs-example'
    fi

    echo 'Service Git Url: (default: https://github.com/davinryan/openshift-jenkins-nodejs-example.git)'
    read SERVICE_GIT_URL

    if [ -z "$SERVICE_GIT_URL" ]; then
        SERVICE_GIT_URL='https://github.com/davinryan/openshift-jenkins-nodejs-example.git'
    fi

    echo 'Environment: (default: dev)'
    read ENVIRONMENT

    if [ -z "$ENVIRONMENT" ]; then
        ENVIRONMENT='dev'
    fi

    echo 'User Name: (default: developer)'
    read USER_NAME

    if [ -z "$USER_NAME" ]; then
        USER_NAME='developer'
    fi

    echo 'Password: (default: password)'
    read -s PASSWORD

    if [ -z "$PASSWORD" ]; then
        PASSWORD='password'
    fi

    echo "Looking good, I'm about to configure openshift for your service $SERVICE_NAME as user '$USER_NAME' under project '$PROJECT_NAME' for environment '$ENVIRONMENT'"
    echo "Does this look good to you y/n?"
    read continue;

    if [ "$continue" == "y" ]; then
        # Login and select project
        oc login -u $USER_NAME -p $PASSWORD https://127.0.0.1:8443
        oc new-project $PROJECT_NAME

        # Install Pipeline
        oc process -f config/pipelines.yaml -n $PROJECT_NAME -p SERVICE_NAME=$SERVICE_NAME | oc create -f - -n $PROJECT_NAME
    fi
fi