FROM jenkins/jenkins:lts 
 
# Running as root to have an easy support for Docker 
USER root 
 
# A default admin user 
ENV ADMIN_USER=admin \ 
    ADMIN_PASSWORD=password 
 
# Jenkins init scripts 
COPY security.groovy /usr/share/jenkins/ref/init.groovy.d/ 
 
# Install plugins at Docker image build time 
COPY plugins.txt /usr/share/jenkins/plugins.txt 
RUN /usr/local/bin/install-plugins.sh $(cat /usr/share/jenkins/plugins.txt) && \ 
    mkdir -p /usr/share/jenkins/ref/ && \ 
    echo lts > /usr/share/jenkins/ref/jenkins.install.UpgradeWizard.state && \ 
    echo lts > /usr/share/jenkins/ref/jenkins.install.InstallUtil.lastExecVersion 
 
# Install Docker 
RUN apt-get -qq update && \ 
    apt-get -qq -y install curl && \ 
    curl -sSL https://get.docker.com/ | sh 
 
# Install kubectl and helm 
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd 
64/kubectl && \ 
    chmod +x ./kubectl && \ 
    mv ./kubectl /usr/local/bin/kubectl && \ 
    curl https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get | bash 
 
# Install & config awscli to push to ECR 
RUN apt-get -qq update && \ 
    apt-get -qq -y install python 
RUN curl -O https://bootstrap.pypa.io/get-pip.py 
RUN python get-pip.py 
RUN pip install awscli 
     
RUN mkdir ~/.aws 
RUN echo "[default]" >>  ~/.aws/config 
RUN echo "aws_access_key_id = AKIAJT4OPXXXXXXXXX" >>  ~/.aws/config 
RUN echo "aws_secret_access_key = kCqOs6TwGM7a8f3eWtNxMxxxxxxxxxxxxxx" >>  ~/.aws/config
 
