sudo yum -y update

#Java
sudo yum -y install java-1.7.0-openjdk

# Jenkins
sudo wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat/jenkins.repo
sudo rpm --import https://jenkins-ci.org/redhat/jenkins-ci.org.key
sudo yum -y install jenkins



# Docker
if [rpm -qa | grep docker | wc -l > 0]; then
   echo "Docker already installed, skipping..."
else
   curl -sSL https://get.docker.com/ | sh
fi

sudo groupadd docker
sudo gpasswd -a ${USER} docker
sudo gpasswd -a jenkins docker
sudo service docker restart
#newgrp docker

sudo service docker start
sudo chkconfig docker on

sudo service jenkins start
sudo chkconfig jenkins on

#Node
#pushd .
#cd /tmp
#sudo wget https://nodejs.org/dist/v4.1.1/node-v4.1.1-linux-x64.tar.gz
#sudo tar --strip-components 1 -xzvf node-v* -C /usr/local
#popd

#install Node.js and npm
#pushd .
#cd /tmp
#curl -sL https://rpm.nodesource.com/setup_4.x | bash -
#sudo yum install -y nodejs
#sudo yum install -y npm
#popd

pushd .
cd /tmp
sudo wget https://nodejs.org/dist/v4.1.1/node-v4.1.1-linux-x64.tar.gz
sudo tar xzvf node-v4.1.1-linux-x64.tar.gz
sudo mv --force node-v4.1.1-linux-x64/bin/* /usr/bin
sudo mv --force node-v4.1.1-linux-x64/lib/* /usr/lib
sudo rm -rf /tmp/*
popd

sudo npm install -g mocha
sudo npm install -g mocha-junit-reporter

# install Mocha
#sudo npm install -g mocha

#Fix the links so sudo npm works:
#sudo ln -s /usr/local/bin/node /usr/bin/node
#sudo ln -s /usr/local/lib/node /usr/lib/node
#sudo ln -s /usr/local/bin/npm /usr/bin/npm
#sudo ln -s /usr/local/bin/node-waf /usr/bin/node-waf

# install Junit Reporter
# sudo npm install mocha-junit-reporter --save-dev

pushd .
cd /tmp
sudo wget https://dl.bintray.com/mitchellh/terraform/terraform_0.6.3_linux_amd64.zip
sudo unzip terraform_0.6.3_linux_amd64.zip
sudo mv --force terraform* /usr/bin
sudo rm -rf /tmp/*
popd
