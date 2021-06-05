# Linux-Server-Setup

#### Changes to do if resetup
1. Upgrade python to `3.8.8` (if got newer `3.8` ver, then use it)

2. Change `gunicorn-eperp2api.service` to `eperp2api-gunicorn.service`

3. Increase drive space

## Install CentOS 8
[Refer this link](https://knowledgeofthings.com/installation-guide-centos-linux-oracle-vm-virtualbox-windows-10/).

### After Install CentOS 8
When installing Centos 8, make sure to create root user and admin user
1. VirtualBox Setting
* Set `Network Adapter` to `Bridged Adapter`
* Set `General > Advanced > Shared Clipboard` to `Bidirectional`
2. Setup network to enable internet connection
3. Login as root
4. Add admin as sudoers
```bash
usermod -aG wheel admin
```
5. Login as admin (most of command might need to add `sudo` in front of it)
6. Update CentOS
```bash
yum update
```

### Install VirtualBox Guest Addition
This installation is to have easy interaction with CentOS when in virtualbox

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
### Enable Web Console Cockpit
1.Enable by running following command
```bash
systemctl enable --now cockpit.socket
```
2. Open firewall for for cockpit
```bash
firewall-cmd --add-service=cockpit --permanent
firewall-cmd --reload
```
3. Now you can open the web through web browser by port 9090

### Install Python 3.8.1
1. Install necessary packages for compile python.
```bash
yum install gcc openssl-devel bzip2-devel libffi-devel make xz-devel ncurses-devel
```
2. Go to `/opt` folder to download compressed file, extract, compile and install
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
1. Add link to installer (You might need login as root)
```bash
curl -sL https://rpm.nodesource.com/setup_14.x | bash -
```
2. Install necessary package
```bash
yum clean all
yum install gcc-c++ make
yum install nodejs
```

### Install Git
```bash
yum install git
git config --global credential.helper cache
```
### Install Django Application
1. Run the following command if the Django app required to access mysql
```bash
yum install mysql-devel
```
2. Create Folder for Django app
```bash
cd ~
mkdir /src/python
```
3. Clone Django app from git and open the folder
```bash
git clone {link}
cd eperp2api
```
4. Configure environment settings for Django app
```bash
cd /eperp2api/settings
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
export DJANGO_SETTINGS_MODULE=eperp2api.settings.production
python manage.py runserver 0.0.0.0:80
```
You can try to access from localhost

You will need to open firewall port 80 in order for outside to access the Django app

### Install Nuxt Application
1. Create Folder for Nuxt app
```bash
cd ~
mkdir /src/nodejs
```
2. Clone Nuxt app from git and open the folder
```bash
git clone {link}
cd eperp2app
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
1. Activate the venv first, then install gunicorn
```bash
pip install gunicorn
```
2. Create service file at correct folder (Refer respository gunicorn-eperp2api.service), start it afterward
```bash
cd /etc/systemd/system
nano gunicorn-eperp2api.service
systemctl start gunicorn-eperp2api.service
```
3. You might face error due to selinux, run the following command to get rid of it
```bash
ausearch -c 'gunicorn' --raw | audit2allow -M my-gunicorn
semodule -i my-gunicorn.pp
```
4. Restart gunicorn and enable it for auto startup
```bash
systemctl restart gunicorn-eperp2api.service
systemctl enable gunicorn-eperp2api.service
```

Run the following command when selinux prevent access tcp port (Happen during Django app access database)
```bash
setsebool -P nis_enabled 1
```

### Setup Django-Q daemon to serve Django Scheduler
1. Create service file at correct folder (Refer respository eperp2api-django-q-scheduler.service), start it afterward
```bash
cd /etc/systemd/system
nano eperp2api-django-q-scheduler.service
systemctl start eperp2api-django-q-scheduler.service
```
2. Enable Django-Q daemon for auto startup
```bash
systemctl enable eperp2api-django-q-scheduler.service
```


#### Update bash script
Copy `python-django-eperp2api-update.sh` to `/home/admin/src/`, run the following command to perform git pull and update to live with zero down time
```bash
bash python-django-eperp2api-update.sh
```

### Setup PM2 to serve Nuxt Application
1. Install pm2 at global scope
```bash
npm install pm2 -g
```
2. Go to nodejs folder and create necessary folder
```bash
cd /home/admin/src/nodejs
mkdir pm2
mkdir pm2/releases/
mkdir pm2/releases/v1
mkdir pm2/releases/v2
```
3. Copy the ecosystem.config.js (make any amendment if required)
```bash
cp eperp2app/ecosystem.config.js pm2/ecosystem.config.js
```
4. Move the previous app to v1 folder
```bash
mv eperp2app pm2/releases/v1/
```
5. Create symlink (shortcut) for the app to `current` folder
```bash
cd pm2
ln -sfn releases/v1/eperp2app current
```

Your folder structure should look like this
```bash
├── releases
│   ├── v1 
│   │   └── eperp2app
│   ├── v2
├── current -> releases/v1/eperp2app
└── ecosystem.config.js
```

6. Perform pm2 auto startup 
```bash
pm2 startup
```
Note: after perform the above step and its instruction, you might unable to start pm2 service due started pm2 daemon. Restart centos or kill pm2 process

7. Start and register the nuxt application for auto startup
```bash
pm2 start
pm2 save
```
#### Update bash script
Copy `nodejs-nuxt-eperp2app-update.sh` to `/home/admin/src/`, run the following command to perform git pull and update to live with zero down time
```bash
bash nodejs-nuxt-eperp2app-update.sh
```

### Allow gunicorn to upload file to mounted nfs folder (nas)
```bash
ausearch -c 'gunicorn' --raw | audit2allow -M my-gunicorn
semodule -i my-gunicorn.pp
```

### Allow nginx to redirect file from mounted nfs folder (nas)
```bash
setsebool -P httpd_use_nfs 1 
 
ausearch -c 'nginx' --raw | audit2allow -M my-nginx
semodule -i my-nginx.pp
```

## Useful command to check error
```bash
journalctl
```

## Resources
[PM2 Startup Script Generator](https://pm2.keymetrics.io/docs/usage/startup/)

[How To Set Up Django with Postgres, Nginx, and Gunicorn on CentOS 7](https://www.digitalocean.com/community/tutorials/how-to-set-up-django-with-postgres-nginx-and-gunicorn-on-centos-7).

[Tweaking GNOME Desktop Environment on CentOS 8](https://linuxhint.com/tweaking_gnome_desktop_centos8/)
