# Openshift Jenkins Nodejs example

A simple project that configures openshift to build and deploy a nodejs application and manage via a Jenkins pipeline.
This project creates a docker image for a basic nodejs app (found in ./src) using the source to image builder dry024/s2i-openshift-alpine-nodejs

## 1. Install Dependencies
 * install docker (refer: https://docs.docker.com/engine/installation/)
 * install openshift origin (refer: https://docs.openshift.org/latest/cli_reference/get_started_cli.html)
   * mac - brew install openshift-cli
   
Releases for openshift origin can be found [here](https://github.com/openshift/origin/releases).

## 2. Setup
Change docker memory and cpu limits via docker preferences to allow at least 2 openshift pods to run locally

 * cpus: 2
 * memory: 4GB

## 3. Update hosts file 
*Needed as we don't have a separate DNS for openshift and openshift won't do this for us*

```bash
sudo vim /etc/hosts

Add the following two lines and save the the file
127.0.0.1       jenkins
127.0.0.1       openshift-jenkins-nodejs-example
```

## 4. Start openshift
oc cluster up
 
## 5. Push s2i builder to local openshift registry
docker pull drya024/s2i-openshift-alpine-nodejs
docker tag drya024/s2i-openshift-alpine-nodejs 172.30.1.1:5000/drya024/s2i-openshift-alpine-nodejs

oc login -u developer
oc new-project drya024
oc project drya024
docker login -u developer -p $(oc whoami -t) 172.30.1.1:5000
docker push 172.30.1.1:5000/drya024/s2i-openshift-alpine-nodejs

## 6. Install build configurations
Talk about GIT_SSL_NO_VERIFY and proxy config

cd openshift
./install-build-configs.sh

ignore "Error from server (AlreadyExists): project.project.openshift.io "myproject" already exists"
as myproject is always created by default. I'm just too lazy to make my script hide acceptable errors

check configurations by navigating to https://127.0.0.1:8443, login as developer and any password

## 7. Install deploy configurations
cd openshift
./install-deploy-configs.sh

ignore "Error from server (AlreadyExists): project.project.openshift.io "myproject" already exists"
as myproject is always created by default. I'm just too lazy to make my script hide acceptable errors

check configurations by navigating to https://127.0.0.1:8443, login as developer and any password

## 8. Install pipeline configurations
cd openshift
./install-pipeline-configs.sh

ignore "Error from server (AlreadyExists): project.project.openshift.io "myproject" already exists"
as myproject is always created by default. I'm just too lazy to make my script hide acceptable errors

check configurations by navigating to https://127.0.0.1:8443, login as developer and any password

## References
oc create configmap openshift-jenkins-nodejs-example-config --from-file openshift/config/dev/openshift-jenkins-nodejs-example-config/application.properties --dry-run -o yaml

https://github.com/debianmaster/Notes/wiki/How-to-push-docker-images-to-openshift-internal-registry-and-create-application-from-it.

https://docs.openshift.com/enterprise/3.1/dev_guide/builds.html

https://github.com/openshift/source-to-image

https://docs.openshift.com/enterprise/3.1/admin_guide/sdn_troubleshooting.html