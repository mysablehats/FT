#!/usr/bin/env bash
#VAR=`ls /temporal-segment-networks/catkin_ws/src/ | grep vision_opencv`
DIRECTORY=/temporal-segment-networks/catkin_ws/src/vision_opencv-1.11.16
#if vision_opencv is not there, create it
if [ ! -d "$DIRECTORY" ]; then
#if [ -z "$VAR" ]; then
  source /root/ros_catkin_ws/install_isolated/setup.bash
  mkdir -p /temporal-segment-networks/catkin_ws/src
  cd /temporal-segment-networks/catkin_ws/src
  #git clone https://github.com/mysablehats/caffe_tsn_ros.git
  #git clone https://github.com/frederico-klein/create_video.git
  #git clone https://github.com/ros-perception/vision_opencv.git

  #latest version is too new. it requires opencv3 and since i don't want to install
  #2 versions or change the tsn code to use opencv3 we will use an older version of
  # cv_bridge
  wget https://github.com/ros-perception/vision_opencv/archive/1.11.16.zip
  unzip 1.11.16.zip
  rm 1.11.16.zip

  cd ..
  ## we need to make sure it uses our own version of opencv, so we don't have 2 copies and have to compile it twice...
  catkin_make -DOpenCV_DIR=/temporal-segment-networks/3rd-party/opencv-2.4.13  #|| catkin_make -DOpenCV_DIR=/temporal-segment-networks/3rd-party/opencv-2.4.13/cmake
  # rebuild 1

fi
