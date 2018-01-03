# openshift-jenkins-nodejs-example

Change docker memory and cpu limits

oc create configmap openshift-jenkins-nodejs-example-config --from-file openshift/config/dev/openshift-jenkins-nodejs-example-config/application.properties --dry-run -o yaml

https://github.com/debianmaster/Notes/wiki/How-to-push-docker-images-to-openshift-internal-registry-and-create-application-from-it.

https://docs.openshift.com/enterprise/3.1/dev_guide/builds.html

https://github.com/openshift/source-to-image

oc edit oauthclient openshift-web-console

https://www.openshift.org/download.html
https://github.com/openshift/origin/releases
brew install openshift-cli


## Push s2i to local registry
docker pull drya024/s2i-openshift-alpine-nodejs
docker tag drya024/s2i-openshift-alpine-nodejs 172.30.1.1:5000/drya024/s2i-openshift-alpine-nodejs
oc whoami -t
docker login -p GvBbeHpqsEkC9AsHhbZ6hQ2yzk6wc5WqAAaOt5rlviM 172.30.1.1:5000
oc new-project drya024
docker push 172.30.1.1:5000/drya024/s2i-openshift-alpine-nodejs