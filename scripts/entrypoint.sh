#!/bin/sh
set -e
echo "10.0.0.8  scitos" >> /etc/hosts
echo "10.0.0.239  SATELLITE-S50-B" >> /etc/hosts
echo "172.28.5.2 tsn_denseflow" >> /etc/hosts
echo "history -s /tmp/start.sh " >> /root/.bashrc

#bash  /root/face_recognition/catkin_ws.sh
service ssh restart
cat /root/face_recognition/banner.txt
exec "$@"
