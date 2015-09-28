sudo yum update

#Java
sudo yum -y install java-1.7.0-openjdk

# Jenkins
sudo wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat/jenkins.repo
sudo rpm --import https://jenkins-ci.org/redhat/jenkins-ci.org.key
sudo yum -y install jenkins

# Docker
curl -sSL https://get.docker.com/ | sh
sudo service docker start
sudo chkconfig docker on

pushd .
cd /tmp
sudo wget https://nodejs.org/dist/v4.1.1/node-v4.1.1-linux-x64.tar.gz
sudo tar --strip-components 1 -xzvf node-v* -C /usr/local

#Fix the links so sudo npm works:
sudo ln -s /usr/local/bin/node /usr/bin/node
sudo ln -s /usr/local/lib/node /usr/lib/node
sudo ln -s /usr/local/bin/npm /usr/bin/npm
sudo ln -s /usr/local/bin/node-waf /usr/bin/node-waf

# install Mocha
sudo npm install -g mocha

# install Junit Reporter
sudo npm install -g mocha-junit-reporter
