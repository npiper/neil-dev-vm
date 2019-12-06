# Provisioning an Ubuntu Desktop for API Development

## Problem statement

As an API Developer I would like an automated way to setup and test a Development environment configuration and share the image across different formats like an AWS AMI or Virtual box image.

An example problem was when needing to upgrade Development environments between Mule 3 & Mule 4 - I wanted a separate development box to be able to switch between them without needing to install both versions on a single machine.

## What this uses

Packer - Virtualbox
AWS AMI - Packer
VNC Viewer ( to connect to the desktop)

## Pre-Requisites

 * Packer
 * AWS Account - User Access key, Secret in region eu-west-1

## Base AMI
 Ubuntu 16.04 Xenial AMD64 Server
 `ubuntu/images/*ubuntu-xenial-16.04-amd64-server-*`
 Owner: 099720109477

## How to build the AMI Image onto Amazon

```
> cd vagrant
> packer build -var 'aws_access_key={ACCESS_KEY}' -var 'aws_secret_key={SECRET_KEY_' packer.json
```

A private AMI image will be created in your AMI account called `mule-devvm {{timestamp}}`

## Creating the image

Loginto AWS console, create a new instance based on the AMI
Select the appropriate option for your private key to create a new one, or re-use one you created earlier

### AWS CLI option

```
# Create Security group in vpc vpc-1a2b3c4d
aws ec2 create-security-group --group-name mule-dev-sg --description "Mule Dev SG" --vpc-id vpc-1a2b3c4d

# Add rules to Security Group
aws ec2 authorize-security-group-ingress --group-id sg-903004f8 --protocol tcp --port 5411   --cidr 0.0.0.0/0

# Run a Large EC2 based on the AMI, using key 'mule-devkp' in Subnet subnet-6e7f829e using SG ID sg-903004f8
aws ec2 run-instances --image-id ami-06c883e1450bb04bc --count 1 --instance-type t2.large --key-name mule-devkp  --security-group-ids sg-903004f8 --subnet-id subnet-6e7f829e

```

## Modify the security group to allow Port 5901

Port 5901 needs to be allowed from either CIDR Block 0.0.0.0/0 (Whole internet) or your private IP address
TCP traffic

## SSH Into the box

You will need to have the .pem file created by AWS locally

Get the Public IP address of the image

The user to login is `ubuntu`

```
chmod 400 ~/Downloads/private_key.pem
ssh -i ~/Download/private_key.pem ubuntu@{public_ip_address}

> vncserver
```

## VNC To the GUI

Start up your local VNC client to connect on the public IP address at port 5901

# Software / Images installed

## Open JDK 1.8
## Google Chrome
## Anypoint Studio 4.1.1
## Postman
## Docker (machine)
## Openshift CLI
## SoapUI 5.5
## Terminator
## Maven
## tightvncserver
## curl
## wget
## Ubuntu Gnome desktop

# Future Options

## NodeJS
## Groovy
## Git
## Gradle
## Ruby
## Docker
 *  Docker compose
### Docker aliases - setup command line
 * Remove all images
## Hermes JMS
## Eclipse STS

### Plugins?
## ATOM
## Sublime Text

http://askubuntu.com/questions/172698/how-do-i-install-sublime-text-2-3

```
sudo add-apt-repository ppa:webupd8team/sublime-text-3
sudo apt-get update
sudo apt-get install sublime-text-installer
```

 * Put on path
```
ln -s /opt/sublime_text/sublime_text /usr/bin/sublime_text
```

### Plugins?
PackageControl
Git
GitGutter
Markdown Preview
View in Browser
Terminal

# References

Links I used to get this going

https://linux.die.net/man/1/vncserver

https://misc.flogisoft.com/bash/tip_colors_and_formatting

https://poweruphosting.com/blog/setup-vnc-server-on-ubuntu/

https://stackoverflow.com/questions/42296329/how-to-properly-configure-xstartup-file-for-tightvnc-with-ubuntu-vps-gnome-envir

https://linux.die.net/man/1/vncpasswd

https://linux.die.net/man/1/vncconfig

https://stackoverflow.com/questions/25657596/how-to-set-up-gui-on-amazon-ec2-ubuntu-server

https://www.packer.io/docs/provisioners/file.html

https://www.packer.io/intro/getting-started/build-image.html

https://circleci.com/blog/how-to-build-immutable-infrastructure-with-packer-and-circleci-workflows/

https://poweruphosting.com/blog/setup-vnc-server-on-ubuntu/

https://www.packer.io/intro/getting-started/build-image.html		
