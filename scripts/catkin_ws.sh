#!/usr/bin/env bash
#VAR=`ls /temporal-segment-networks/catkin_ws/src/ | grep vision_opencv`
OLDDIR=$PWD
CATKIN_WS_DIR=/catkin_ws
DIRECTORY=${CATKIN_WS_DIR}/src/vision_opencv-1.11.16
#if vision_opencv is not there, create it
if [ ! -d "$DIRECTORY" ]; then
  source /root/ros_catkin_ws/install_isolated/setup.bash
  mkdir -p ${CATKIN_WS_DIR}/src
  cd ${CATKIN_WS_DIR}/src

  #latest version is too new. it requires opencv3. probably could do though...
  wget https://github.com/ros-perception/vision_opencv/archive/1.11.16.zip
  unzip 1.11.16.zip
  rm 1.11.16.zip
fi
cd ${CATKIN_WS_DIR}
rosdep install --from-paths src --ignore-src -r -y
pip3 install opencv-python
### we need python3 so...
catkin_make --cmake-args -DPYTHON_VERSION=3.5
cd ${OLDDIR}
#-DPYTHON_EXECUTABLE=/usr/bin/python3 -DPYTHON_INCLUDE_DIR=/usr/include/python3.5m -DPYTHON_LIBRARY=/usr/lib/x86_64-linux-gnu/libpython3.5m.so
