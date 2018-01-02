
# Install ConfigMaps
oc create configmap openshift-jenkins-nodejs-example-config --from-file config/dev/openshift-jenkins-nodejs-example-config/application.properties

# Install Image Streams
oc create -f config/image-stream.yaml

# Install Build Configs
oc create -f config/build-config.yaml

# Install Deployment, Route and Service
oc create -f config/dev/config.yaml

# Install Pipeline
