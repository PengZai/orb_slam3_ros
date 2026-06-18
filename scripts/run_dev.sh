#!/bin/bash

PROJECT_NAME="orb-slam3"

IMAGE_NAME="orb_slam3:noetic-ros"
DATA_PATH="/media/${USER}/zhipeng_usb1/datasets"
DATA_PATH2="/media/${USER}/zhipeng_8t1/datasets"
DATA_PATH3="/mnt/lboro_nas/personal/Zhipeng"

# Pick up config image key if specified
if [[ ! -z "${CONFIG_DATA_PATH}" ]]; then
    DATA_PATH=$CONFIG_DATA_PATH
fi


docker build -t $IMAGE_NAME -f "${HOME}/vscode_projects/orb_slam3_ros/catkin_ws/src/orb_slam3_ros/Dockerfile_for_dev.txt" .


xhost +local:docker

docker run \
    -e DISPLAY \
    -v ~/.Xauthority:/root/.Xauthority:rw \
    --network host \
    -v /tmp/.X11-unix:/tmp/.X11-unix:rw \
    -v ${HOME}/vscode_projects/orb_slam3_ros/catkin_ws:/root/catkin_ws \
    -v ${DATA_PATH}:/root/datasets \
    -v ${DATA_PATH2}:/root/datasets2 \
    -v ${DATA_PATH3}:/root/lboro_nas \
    --privileged \
    --cap-add sys_ptrace \
    --runtime=nvidia \
    --gpus all \
    -it --name $PROJECT_NAME $IMAGE_NAME /bin/bash

xhost -local:docker