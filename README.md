# Linux-Server-Setup

## Install Centos 8
[Refer this link](https://knowledgeofthings.com/installation-guide-centos-linux-oracle-vm-virtualbox-windows-10/).

### After Install Centos 8
1. Login as root
2. Update centos
```bash
yum update
```

### Install Python 3.8.1
1. Install necessary packages for compile python
```bash
yum install gcc openssl-devel bzip2-devel libffi-devel make xz-devel
```
1. Go to `/opt` folder to download compressed file, extract and compile and install
```bash
cd /opt
wget https://www.python.org/ftp/python/3.8.1/Python-3.8.1.tgz
tar xzf Python-3.8.1.tgz
cd Python-3.8.1
./configure --enable-optimizations
make altinstall
```
