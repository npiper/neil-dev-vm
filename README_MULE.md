# Mule Developer VM

```
As an API/Integration Developer
I need an SOE that has all required software pre-installed
so that I can quickly be productive 
And there is a consistent toolset for our Devs
```
- [x] Java Oracle JDK 1.8
- [x] Chrome
- [x] Postman
- [x] Mulesoft IDE
- [x] SoapUI
- [x] Docker
- [ ] ActiveMQ
- [x] HermesJMS
- [ ] MiniKube (Kubernetes)
- [ ] MiniShift
- [ ] Ansible
- [ ] Puppet


## Building vagrant

```
cd vagrant
vagrant up
```

## Building Packer AMI to AWS

```
packer build -var 'aws_access_key=AAAAAAAAAAAAAA' -var 'aws_secret_key=secret_key' packer.json
```

## Starting an AMI

Launch the EC2 instance using the AMI	ami-08a330036254e99e4

```
ssh -i ~/key.pem ubuntu@public-ip-address
```


## Base instances / Refs

https://atlas.hashicorp.com/boxcutter/boxes/ubuntu1610-desktop

Packer - vagrant https://www.packer.io/intro/getting-started/vagrant.html


