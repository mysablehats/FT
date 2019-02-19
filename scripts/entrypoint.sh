#!/bin/sh
set -e
echo "10.0.0.8  scitos" >> /etc/hosts
echo "10.0.0.239  SATELLITE-S50-B" >> /etc/hosts
echo "172.28.5.2 tsn_denseflow" >> /etc/hosts
echo "history -s /tmp/start.sh " >> /root/.bashrc

bash  /temporal-segment-networks/catkin_ws.sh
#cd /temporal-segment-networks/catkin_ws/
#. /root/ros_catkin_ws/install_isolated/setup.sh
#export PYTHONPATH=/temporal-segment-networks/caffe-action/python/caffe:/temporal-segment-networks/:$PYTHONPATH
#bash -c /root/ros_catkin_ws/install_isolated/bin/catkin_make
#ls /temporal-segment-networks
service ssh restart
cat /temporal-segment-networks/banner.txt
exec "$@"
