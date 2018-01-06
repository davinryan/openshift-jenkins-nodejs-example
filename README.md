## Install/Setup
install docker
brew install openshift-cli
or 
https://www.openshift.org/download.html
https://github.com/openshift/origin/releases
https://docs.openshift.org/latest/cli_reference/get_started_cli.html

## Setup
Change docker memory and cpu limits
cpus: 2
memory: 4GB

## update hosts file
sudo vim /etc/hosts
127.0.0.1       jenkins
127.0.0.1       openshift-jenkins-nodejs-example

## Start openshift
oc cluster up
 
## Push s2i to local registry
docker pull drya024/s2i-openshift-alpine-nodejs
docker tag drya024/s2i-openshift-alpine-nodejs 172.30.1.1:5000/drya024/s2i-openshift-alpine-nodejs
oc login -u developer
oc new-project drya024
docker login -u developer -p $(oc whoami -t) 172.30.1.1:5000
docker push 172.30.1.1:5000/drya024/s2i-openshift-alpine-nodejs

## Install configurations
cd openshift
chmod +x install.sh
./install.sh

ignore "Error from server (AlreadyExists): project.project.openshift.io "myproject" already exists"
as myproject is always created by default. I'm just too lazy to make my script hide acceptable errors

check configurations by navigating to https://127.0.0.1:8443
login as developer and any password

## Other
oc edit oauthclient openshift-web-console

## References
oc create configmap openshift-jenkins-nodejs-example-config --from-file openshift/config/dev/openshift-jenkins-nodejs-example-config/application.properties --dry-run -o yaml

https://github.com/debianmaster/Notes/wiki/How-to-push-docker-images-to-openshift-internal-registry-and-create-application-from-it.

https://docs.openshift.com/enterprise/3.1/dev_guide/builds.html

https://github.com/openshift/source-to-image

https://docs.openshift.com/enterprise/3.1/admin_guide/sdn_troubleshooting.html