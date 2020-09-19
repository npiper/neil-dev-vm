 #/bin/sh

# Set TZ to Melbourne
timedatectl set-timezone Europe/London

# Make data dir if not present
mkdir -p /vagrant_data
chown -R ubuntu /vagrant_data


# Upgrade distribution
apt-get dist-upgrade -y
apt-get update

# Install GUI

apt-get install -y -q gnome-panel gnome-settings-daemon metacity nautilus gnome-terminal
# vnc4server
apt-get install -y -q xfce4 xfce4-goodies tightvncserver
apt-get install -y -q --no-install-recommends ubuntu-gnome-desktop -y

mkdir -p /home/ubuntu/Desktop
chown -R ubuntu:ubuntu /home/ubuntu/Desktop

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


# JDK 1.8
echo "Installing JDK"
apt-get install -y openjdk-8-jdk-headless

# Postman
echo "Installing Postman"
cd /opt
wget --content-disposition -q https://dl.pstmn.io/download/latest/linux64
gunzip Postman*
tar -xf Postman*

cp /vagrant_data/Postman.desktop /usr/share/applications/Postman.desktop
cp /vagrant_data/Postman.desktop /home/ubuntu/Desktop/Postman.desktop

# SoapUI
echo "Installing SoapUI"
wget -q https://s3.amazonaws.com/downloads.eviware/soapuios/5.5.0/SoapUI-x64-5.5.0.sh
chmod +x SoapUI-x64-5.5.0.sh
./SoapUI-x64-5.5.0.sh -q


# Terminator
echo "Installing Terminator"
apt-get install -y -q terminator



# Mule anypoint
echo "Installing Mule Anypoint - approx 800Mb"
wget -q https://mule-studio.s3.amazonaws.com/4.1.1-OCT14-U1/AnypointStudio-for-linux-64bit-4.1.1-201411041003.tar.gz
gunzip AnypointStudio-for-linux-64bit-4.1.1-201411041003.tar.gz
tar -xvf AnypointStudio-for-linux-64bit-4.1.1-201411041003.tar
cp /vagrant_data/Anypoint.desktop /usr/share/applications/Anypoint.desktop
cp /vagrant_data/Anypoint.desktop /home/ubuntu/Desktop/Anypoint.desktop

echo "PATH=\"$PATH:/opt/Postman:/opt/SmartBear/SoapUI-5.3.0/bin:/opt/AnypointStudio\"" >> /home/ubuntu/.profile
source /home/ubuntu/profile

# Docker
echo "Installing Docker"
# Set up Docker Repo
apt-get install -y -q --no-install-recommends \
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
apt-get -y -q update
apt-get -y -q install docker-engine

echo "Installing Maven"
# Maven
apt-get install -y -q maven

# Openshift
wget https://github.com/openshift/origin/releases/download/v1.4.1/openshift-origin-client-tools-v1.4.1-3f9807a-linux-64bit.tar.gz
gunzip openshift-origin-client-tools-v1.4.1-3f9807a-linux-64bit.tar.gz
tar -xvf openshift-origin-client-tools-v1.4.1-3f9807a-linux-64bit.tar

echo "Set up maven"
# Set up Maven
mkdir -p /home/ubuntu/.m2

## Master password
mvn --encrypt-master-password 8umble8ee > pass.txt
printf "<settingsSecurity>\n  <master>$(less pass.txt)</master>\n</settingsSecurity>" > /home/ubuntu/.m2/settings-security-test.xml
rm pass.txt


ls /vagrant_data

## settings.xml
cp /vagrant_data/settings.xml /home/ubuntu/.m2/settings.xml
chown -R ubuntu:ubuntu /home/ubuntu/.m2

## vnc
sudo -u ubuntu mkdir -p /home/ubuntu/.vnc
sudo -u ubuntu cp /vagrant_data/xstartup /home/ubuntu/.vnc/xstartup
chmod +x /home/ubuntu/.vnc/xstartup
chown -R ubuntu:ubuntu /home/ubuntu/.vnc

Xtightvnc :1 -desktop X -auth /home/ubuntu/.Xauthority -geometry 1600x1200 -depth 24 -rfbwait 120000 -rfbauth /home/ubuntu/.vnc/passwd -rfbport 5901 -fp /usr/share/fonts/X11/misc/,/usr/share/fonts/X11/Type1/,/usr/share/fonts/X11/75dpi/,/usr/share/fonts/X11/100dpi/ -co /etc/X11/rgb -rfbauth /home/ubuntu/.vnc/passwd &

# VNC Password 'vncvnc' - make configurable
#sudo -u ubuntu echo "vncvnc" | vncpasswd -f > /home/ubuntu/.vnc/passwd
#chmod 600 /home/ubuntu/.vnc/passwd

sudo -u ubuntu echo "vncvnc\nvncvnc\nn\n" | vncserver
sudo -u ubuntu vncserver -kill :1

# VNC Server
cp /vagrant_data/vncserver.service  /etc/systemd/system/vncserver@.service
chmod +x
/vncserver@.service
#systemctl daemon-reload
#systemctl enable vncserver@1.service
#systemctl status vncserver@1
