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
1. Install necessary packages for compile python.
```bash
yum install gcc openssl-devel bzip2-devel libffi-devel make xz-devel
```
2. Go to `/opt` folder to download compressed file, extract and compile and install.
```bash
cd /opt
wget https://www.python.org/ftp/python/3.8.1/Python-3.8.1.tgz
tar xzf Python-3.8.1.tgz
cd Python-3.8.1
./configure --enable-optimizations
make altinstall
```
Note 1: remove the downloaded file.
```bash
rm Python-3.8.1.tgz
```
Note 2: check Python 3.8 version
```bash
python3.8 -V
```

### Install VirtualBox Guest Addition
This installation is to easy interaction with centos when in virtualbox

1. Install necessary packages
```bash
dnf install epel-release
dnf install dkms kernel-devel kernel-headers gcc make bzip2 perl
```
2. Check kernel version
```bash
rpm -q kernel-devel
uname -r
```
3. If both is not same, update the kernel by 
```bash
dnf update kernel-{version}
```
4. At the virtualBox console, click `Devices > Install Guest Additions CD Image...`, run the following command to complete install
```bash
cd /run/media/{current-user}/VBox{version}/
./VBoxLinuxAdditions.run
```

### Install Git
```bash
yum install git
```


