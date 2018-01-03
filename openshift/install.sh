# Login and select project
oc login -u developer
oc project myproject

# Install ConfigMaps
oc create configmap openshift-jenkins-nodejs-example-config --from-file config/dev/openshift-jenkins-nodejs-example-config/application.properties

# Install Image Streams
oc create -f config/image-streams.yaml

# Install Build Configs
oc create -f config/builds.yaml

# Install Routes
oc create -f config/dev/routes.yaml

# Install Services
oc create -f config/dev/services.yaml

# Install Deploy configs
oc create -f config/dev/deployments.yaml

# Install Pipeline
oc create -f config/pipelines.yaml

# Start build
oc start-build openshift-jenkins-nodejs-example

# Start build and deploy via pipeline
#oc start-build openshift-jenkins-nodejs-example-build-pipeline