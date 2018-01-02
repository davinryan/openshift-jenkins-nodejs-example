# openshift-jenkins-nodejs-example


oc create configmap openshift-jenkins-nodejs-example-config --from-file openshift/config/dev/openshift-jenkins-nodejs-example-config/application.properties --dry-run -o yaml

oc whoami -t

https://github.com/debianmaster/Notes/wiki/How-to-push-docker-images-to-openshift-internal-registry-and-create-application-from-it.

https://docs.openshift.com/enterprise/3.1/dev_guide/builds.html

https://github.com/openshift/source-to-image