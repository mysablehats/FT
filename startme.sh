#!/usr/bin/env bash
PASSWD=$1
if [ -z "$PASSWD" ]
then
  echo "you need to input your own password to mount the internal ssh volume that is shared between docker and the docker host!"
  echo "usage is: $0 <your-password-here>"
else
  nvidia-docker build -t ft .
  #nvidia-docker build --no-cache -t ft .
  echo "STARTING ROS FACE RECOGNITION DOCKER..."

  MACHINENAME=facerecognition
  ISTHERENET=`docker network ls | grep br0`
  if [ -z "$ISTHERENET" ]
  then
    echo "docker network br0 not up. creating one..."
    docker network create \
      --driver=bridge \
      --subnet=172.28.0.0/16 \
      --ip-range=172.28.5.0/24 \
      --gateway=172.28.5.254 \
      br0
  else
    echo "found br0 docker network."
  fi

  scripts/enable_forwarding_docker_host.sh
  #nvidia-docker run --rm -it -p 8888:8888 -h $MACHINENAME --network=br0 --ip=172.28.5.3 ct #bash
  docker volume create --driver vieux/sshfs   -o sshcmd=frederico@poop:$PWD/catkin_ws -o password=$PASSWD sshvolume2
#  nvidia-docker run --rm -it -u root -p 8888:8888 -p 222:22 -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix -v sshvolume2:/catkin_ws -h $MACHINENAME --network=br0 --ip=172.28.5.4 ft bash # -c "jupyter notebook --port=8888 --no-browser --ip=172.28.5.4 --allow-root &" && bash -i
  nvidia-docker run --rm -it -u root -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix -v sshvolume2:/catkin_ws -h $MACHINENAME --network=br0 --ip=172.28.5.4 ft bash # -c "jupyter notebook --port=8888 --no-browser --ip=172.28.5.4 --allow-root &" && bash -i


  ## if I add this with -v I can't catkin_make it with entrypoint...
  #-v /temporal-segment-networks/catkin_ws:$PWD/catkin_ws/src
  #
  docker volume rm sshvolume2
fi
