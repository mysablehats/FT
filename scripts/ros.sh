#!/usr/bin/env bash
#from http://wiki.ros.org/kinetic/Installation/Source with minor adaptations to make it compile

OLDDIR=$PWD
set -e
rosdep init
rosdep update

#add-apt-repository ppa:ondrej/apache2

echo "deb http://ppa.launchpad.net/ondrej/apache2/ubuntu xenial main " >>  /etc/apt/sources.list

echo "deb-src http://ppa.launchpad.net/ondrej/apache2/ubuntu xenial main " >>  /etc/apt/sources.list

apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 14AA40EC0831756756D7F66C4F4EA0AAE5267A6C

apt-get update

mkdir ~/ros_catkin_ws
cd ~/ros_catkin_ws
cp /root/face_recognition/fix.py ./

rosinstall_generator ros_comm sensor_msgs image_transport common_msgs --rosdistro kinetic --deps --wet-only --tar > kinetic-ros_comm-wet.rosinstall

### this needs to be python2.7
python fix.py

wstool init -j`nproc` src kinetic-ros_comm-wet-fixed.rosinstall

rosdep install --from-paths src --ignore-src --rosdistro kinetic -y

./src/catkin/bin/catkin_make_isolated --install -DCMAKE_BUILD_TYPE=Release --cmake-args -DPYTHON_VERSION=3.5

cd  /usr/lib/x86_64-linux-gnu/
ln -s /usr/lib/x86_64-linux-gnu/libboost_python-py35.so libboost_python3.so

cd $OLDDIR
