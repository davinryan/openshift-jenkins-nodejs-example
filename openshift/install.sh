#!/bin/bash

echo "Hi! I'll configure your new app to run nicely in openshift. To do this, I'll need to install a few things but "
echo "I'll totally tell you what I'm doing."
echo "If any of this freaks you out, crtl-c to cancel at any time. Can I proceed though?"

read continue;

echo "Now... lets make sure you have brew and oc installed. This check only works for a mac."
echo "Type 'y' to install or 'n' to skip this step."
echo "-> If you choose to skip this step just make sure you have oc installed. If you're unsure how to install it, don't worry"
echo "just go here https://github.com/openshift/origin/releases !"

read continue;

if [ "$continue" == "y" ]; then
    brew -v  >/dev/null 2>&1 || { echo >&2 "I require brew but it's not installed. I'm  installing it.";  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)";}
    oc help  >/dev/null 2>&1 || { echo >&2 "I require oc but it's not installed. I'll install it... (if you're on a mac.  And have brew installed..) "; brew install openshift-cli; }

    echo "Ok, let's continue. brew & oc are both working"
fi

echo "Alrighty now I'm going to install all those openshift configuration files that allow openshift to build and"
echo "deploy your microservice. Before we continue just make sure your openshift cluster is up and running. If you're"
echo "not sure how to do this, just type 'oc cluster up' and wait for it to start properly. "
echo "just accept the defaults if you're not sure what to specify. Is it started, are you ready :-) ? y/n"

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
    echo "Does this look good to you?"
    read continue;

    if [ "$continue" == "y" ]; then
        # Login and select project
        oc login -u $USER_NAME -p $PASSWORD https://127.0.0.1:8443
        oc new-project $PROJECT_NAME

        # Install ConfigMaps
        oc create configmap $SERVICE_NAME-$ENVIRONMENT-config -n $PROJECT_NAME --from-file config/$ENVIRONMENT/runtime-config/application.properties

        # Install Image Streams
        oc process -f config/image-streams.yaml -n $PROJECT_NAME -p SERVICE_NAME=$SERVICE_NAME | oc create -f - -n $PROJECT_NAME

        # Install Build Configs
        oc process -f config/builds.yaml -n $PROJECT_NAME -p SERVICE_NAME=$SERVICE_NAME | oc create -f - -n $PROJECT_NAME

        # Install Routes
        oc process -f config/$ENVIRONMENT/routes.yaml -n $PROJECT_NAME -p SERVICE_NAME=$SERVICE_NAME | oc create -f - -n $PROJECT_NAME

        # Install Services
        oc process -f config/$ENVIRONMENT/services.yaml -n $PROJECT_NAME -p SERVICE_NAME=$SERVICE_NAME | oc create -f - -n $PROJECT_NAME

        # Install Deploy configs
        oc process -f config/$ENVIRONMENT/deployments.yaml -n $PROJECT_NAME -p SERVICE_NAME=$SERVICE_NAME | oc create -f - -n $PROJECT_NAME

        # Install Pipeline
        oc process -f config/pipelines.yaml -n $PROJECT_NAME -p SERVICE_NAME=$SERVICE_NAME | oc create -f - -n $PROJECT_NAME

        # Start first build
        oc start-build $SERVICE_NAME -n $PROJECT_NAME
    fi
fi