 #/bin/sh

# Set TZ to Melbourne
timedatectl set-timezone Europe/London

# Upgrade distribution
apt-get dist-upgrade -y

# Google Chrome
echo "Installing Chrome"
# Add google repo to sources
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -
echo "deb http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google.list
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -

dpkg --configure -a
apt-get -y update
apt-get -y install -f
apt-get -y install google-chrome-stable
apt-get -y -q install ubuntu-desktop


# JDK 1.8
apt-get install -y openjdk-8-jdk-headless

# Postman
echo "Installing Postman"
cd /opt
wget --content-disposition -q https://dl.pstmn.io/download/latest/linux64
gunzip Postman*
tar -xf Postman*
cp /vagrant_data/Postman.desktop /usr/share/applications/
cp /vagrant_data/Postman.desktop /home/ubuntu/Desktop/

# SoapUI
echo "Installing SoapUI"
wget -q http://cdn01.downloads.smartbear.com/soapui/5.3.0/SoapUI-x64-5.3.0.sh
chmod +x SoapUI-x64-5.3.0.sh
./SoapUI-x64-5.3.0.sh -q


# Terminator
apt-get install -y terminator

# Mule anypoint
echo "Installing Mule Anypoint - approx 800Mb"
wget -q https://mule-studio.s3.amazonaws.com/6.2.2-U2/AnypointStudio-for-linux-64bit-6.2.2-201701271427.tar.gz
#cp /vagrant_data/Any* .
gunzip AnypointStudio-for-linux-64bit-6.2.2-201701271427.tar.gz
tar -xvf AnypointStudio-for-linux-64bit-6.2.2-201701271427.tar
cp /vagrant_data/Anypoint.desktop /usr/share/applications/
cp /vagrant_data/Anypoint.desktop /home/ubuntu/Desktop/

echo "PATH=\"$PATH:/opt/Postman:/opt/SmartBear/SoapUI-5.3.0/bin:/opt/AnypointStudio\"" >> /home/ubuntu/.profile
source /home/ubuntu/profile

# Docker
echo "Installing Docker"
# Set up Docker Repo
apt-get install -y --no-install-recommends \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common
# Add Docker key
curl -fsSL https://apt.dockerproject.org/gpg | apt-key add -

# Add docker repo
add-apt-repository \
       "deb https://apt.dockerproject.org/repo/ \
       ubuntu-$(lsb_release -cs) \
       main"
apt-get -y update
apt-get -y install docker-engine

echo "Installing Maven"
# Maven
apt-get install -y maven

# Openshift
wget https://github.com/openshift/origin/releases/download/v1.4.1/openshift-origin-client-tools-v1.4.1-3f9807a-linux-64bit.tar.gz
gunzip openshift-origin-client-tools-v1.4.1-3f9807a-linux-64bit.tar.gz
tar -xvf openshift-origin-client-tools-v1.4.1-3f9807a-linux-64bit.tar


# Set up Maven
mkdir -p /home/ubuntu/.m2
## Master password
mvn --encrypt-master-password 8umble8ee > pass.txt
printf "<settingsSecurity>\n  <master>$(less pass.txt)</master>\n</settingsSecurity>" > /home/ubuntu/.m2/settings-security-test.xml
rm pass.txt

## settings.xml
cp /settings.xml /home/ubuntu/.m2/settings.xml
