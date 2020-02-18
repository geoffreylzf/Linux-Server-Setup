#!/bash/bash

cd /home/admin/src/nodejs/pm2

_v1='releases/v1/eperp2app'
_v2='releases/v2/eperp2app'
_symlink_path=$(readlink current)

if [ "$_symlink_path" == "$_v1" ]
then
	echo "Current folder is v1"
	git -C releases/v2/eperp2app/ pull
	#npm ci --prefix releases/v2/eperp2app/
	npm run build --prefix releases/v2/eperp2app/

	ln -sfn releases/v2/eperp2app current
elif [ "$_symlink_path" == "$_v2" ]
then
	echo "Current folder is v2"
	git -C releases/v1/eperp2app/ pull
	#npm ci --prefix releases/v1/eperp2app/
	npm run build --prefix releases/v1/eperp2app/

	ln -sfn releases/v1/eperp2app current
else
	echo "Error !!!"
	exit 1
fi

pm2 reload eperp2app
