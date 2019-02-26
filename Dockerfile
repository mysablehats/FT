# This is a sample Dockerfile you can modify to deploy your own app based on face_recognition

FROM nvidia/cuda:8.0-cudnn5-devel
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get -y update
RUN apt-get install -y --fix-missing \
    build-essential \
    cmake \
    gfortran \
    git \
    wget \
    curl \
    graphicsmagick \
    libgraphicsmagick1-dev \
    libatlas-dev \
    libavcodec-dev \
    libavformat-dev \
    libgtk2.0-dev \
    libjpeg-dev \
    liblapack-dev \
    libswscale-dev \
    pkg-config \
    python3-dev \
    python3-numpy \
    python3-pip \
    python-dev\
    python-numpy\
    python-pip\
    python-scipy\
    python-setuptools\
    software-properties-common \
    zip \
### mystuff
    openssh-server\
    libssl-dev \
    #python-sh is needed for the fix.py. once that is solved, remove it.
    python-sh \
    tar\
    && apt-get clean && rm -rf /tmp/* /var/tmp/*

COPY requirements.txt /root/face_recognition/requirements.txt
RUN mkdir -p /root/face_recognition && cd /root/face_recognition && \
    # currently there is an issue with pip3 and upgrading it breaks it see issue 5240 after pip 10 upgrade on pyenv (github)
    #pip3 install -U pip && \
    pip3 install -r requirements.txt

RUN cd ~ && \
    mkdir -p dlib && \
    git clone -b 'v19.9' --single-branch https://github.com/davisking/dlib.git dlib/ && \
    cd  dlib/ && \
    python3 setup.py install --yes USE_AVX_INSTRUCTIONS

# to get ssh working for the ros machine to be functional: (adapted from docker docs running_ssh_service)
RUN mkdir /var/run/sshd \
    && echo 'root:ros_ros' | chpasswd \
    && sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config \
    && sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile" \
    && echo "export VISIBLE=now" >> /etc/profile

EXPOSE 22

#### ROS stuff

ADD requirements_ros.txt /root/face_recognition/
#maybe i can use pip3 for this? NOpe. Wstool then does not work. Im kinda getting the idea that ros will not run with  python3...
RUN pip3 install --trusted-host pypi.python.org -r /root/face_recognition/requirements_ros.txt && \
    pip install --trusted-host pypi.python.org -r /root/face_recognition/requirements_ros.txt
ADD scripts/ros.sh /root/face_recognition/
### microsoft broke github, so I need this to run wstool. probably need to remove this when it gets fixed!
ADD scripts/fix.py /root/face_recognition/
RUN /root/face_recognition/ros.sh \
    && echo "source /root/ros_catkin_ws/install_isolated/setup.bash" >> /etc/bash.bashrc

ENV ROS_MASTER_URI=http://SATELLITE-S50-B:11311

#add my snazzy banner
ADD banner.txt /root/face_recognition/

### installs face_recognition.
#TODO: organize this directory structure, this is messy and will rerun this every time anyfile changes.
COPY face_recognition /root/face_recognition/face_recognition
COPY setup.* *.rst /root/face_recognition/
RUN cd /root/face_recognition && python3 setup.py install

ADD scripts/catkin_ws.sh /root/face_recognition/
RUN /root/face_recognition/catkin_ws.sh
ADD scripts/start.sh /tmp

#RUN apt install tmux nano -y --no-install-recommends \
#  && rm -rf /var/lib/apt/lists/*

ADD scripts/entrypoint.sh /root/face_recognition/
WORKDIR /catkin_ws
ENTRYPOINT ["/root/face_recognition/entrypoint.sh"]
