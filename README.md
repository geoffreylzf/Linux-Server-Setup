# Linux-Server-Setup

## Install Centos 8
[Refer this link](https://knowledgeofthings.com/installation-guide-centos-linux-oracle-vm-virtualbox-windows-10/).

### After Install Centos 8
When installing Centos 8, makesure to create root user and admin user
1. Setup network to enable internet connection (Makesure to set Network to Bridged Adapter at VirtualBox)
2. Login as root
3. Add admin as sudoers
```bash
usermod -aG wheel admin
```
4. Login as admin (most of command might need to add `sudo` infront
5. Update centos
```bash
yum update
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

### Install Python 3.8.1
1. Install necessary packages for compile python.
```bash
yum install gcc openssl-devel bzip2-devel libffi-devel make xz-devel
```
2. Go to `/opt` folder to download compressed file, extract and compile and install
```bash
cd /opt
wget https://www.python.org/ftp/python/3.8.1/Python-3.8.1.tgz
tar xzf Python-3.8.1.tgz
cd Python-3.8.1
./configure --enable-optimizations
make altinstall
```
Note 1: remove the downloaded file
```bash
rm Python-3.8.1.tgz
```
Note 2: check Python 3.8 version
```bash
python3.8 -V
```

### Install Nodejs 12
1. Install necessary package
```bash
curl -sL https://rpm.nodesource.com/setup_12.x | bash -
yum clean all
yum install gcc-c++ make
yum install nodejs
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
cp .env.example .env
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

### Install Nuxt Application
1. Create Folder for Nuxt app
```bash
cd /home
mkdir /src/nodejs
```
2. Clone Nuxt app from git and open the folder
```bash
git clone {link}
cd {project-name}
```
3. Configure environment settings for Nuxt app
```bash
cp .env.example .env
vi .env
```
4. Install required library
```bash
npm ci
```
5. Build and run the Nuxt app
```bash
npm run build
npm run start
```

### Configure Firewall to open port 80
```bash
firewall-cmd --zone=public --add-port=80/tcp --permanent
firewall-cmd --reload
```
### Configure Nginx
1. Install Nginx
```bash
yum install nginx
```
2. Open nginx folder and edit configuration file (Refer respository nginx.conf)
```bash
cd /etc/nginx
nano nginx.conf
```
3. Start and enable Nginx
```bash
systemctl start nginx
systemctl enable nginx
```
4. Run the following command to open httpd network connect
```bash
setsebool -P httpd_can_network_connect 1
```
### Setup Gunicorn/Uvicorn to serve Django Application
### Setup PM2 to serve Nuxt Application

## Resources
[How To Set Up Django with Postgres, Nginx, and Gunicorn on CentOS 7](https://www.digitalocean.com/community/tutorials/how-to-set-up-django-with-postgres-nginx-and-gunicorn-on-centos-7).
