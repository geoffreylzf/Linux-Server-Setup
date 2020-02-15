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
### Install Django Application
1. Run the following command if the Django app required to access mysql
```bash
yum install mysql-devel
```
2. Create Folder for Django app
```bash
cd /home
mkdir /src/python
```
3. Clone Django app from git and open the folder
```bash
git clone {link}
cd {project-name}
```
4. Configure environment settings for Django app
```bash
cd /{project-name}/settings
copy .env.example .env
vi .env
cd ..
cd ..
```
5. Install virtualenv package and create venv for Django app
```bash
pip3.8 install virtualenv
virtualenv venv
```
6. Activate virtualenv and install required python library
```bash
source venv/bin/activate
pip install -r requirements.txt
```
The following command is to test the Django app
```bash
export DJANGO_SETTINGS_MODULE={project-name}.settings.production
python manage.py runserver 0.0.0.0:80
```
You can try to access from localhost
You will need to open port 80 in order for outside to access the Django app

### Configure Firewall to open port 80
```bash
firewall-cmd --zone=public --add-port=80/tcp --permanent
firewall-cmd --reload
```

