#!/bin/bash

cd /home/admin/src/python/eperp2api
git pull
echo "Restarting gunicorn..."
ps aux | grep gunicorn | grep eperp2api | awk '{print $2}'| xargs kill -HUP
echo "Restart complete"
