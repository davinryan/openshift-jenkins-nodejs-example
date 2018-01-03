## Install/Setup
brew install openshift-cli
or 
https://www.openshift.org/download.html
https://github.com/openshift/origin/releases

## Setup
Change docker memory and cpu limits

## update hosts file
sudo vim /etc/hosts
127.0.0.1       jenkins
127.0.0.1       openshift-jenkins-nodejs-example

## Push s2i to local registry
docker pull drya024/s2i-openshift-alpine-nodejs
docker tag drya024/s2i-openshift-alpine-nodejs 172.30.1.1:5000/drya024/s2i-openshift-alpine-nodejs
oc login -u developer
oc new-project drya024
docker login -p $(oc whoami -t) 172.30.1.1:5000
docker push 172.30.1.1:5000/drya024/s2i-openshift-alpine-nodejs

## Other
oc create configmap openshift-jenkins-nodejs-example-config --from-file openshift/config/dev/openshift-jenkins-nodejs-example-config/application.properties --dry-run -o yaml

https://github.com/debianmaster/Notes/wiki/How-to-push-docker-images-to-openshift-internal-registry-and-create-application-from-it.

https://docs.openshift.com/enterprise/3.1/dev_guide/builds.html

https://github.com/openshift/source-to-image

oc edit oauthclient openshift-web-console

https://docs.openshift.com/enterprise/3.1/admin_guide/sdn_troubleshooting.html