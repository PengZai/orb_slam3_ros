#!/bin/bash


IMAGE_NAME="orb_slam3:noetic-ros"
DATA_PATH="/media/zhipeng/zhipeng_usb/datasets"
# Pick up config image key if specified
if [[ ! -z "${CONFIG_DATA_PATH}" ]]; then
    DATA_PATH=$CONFIG_DATA_PATH
fi


PROJECT_DIR=$(pwd)
PROJECT_NAME=$(basename "$PWD")


docker build -t $IMAGE_NAME -f "${HOME}/vscode_projects/orb_slam3_ros/catkin_ws/src/orb_slam3_ros/Dockerfile_for_dev.txt" .


xhost +local:docker

docker run \
    -e DISPLAY \
    -v ~/.Xauthority:/root/.Xauthority:rw \
    --network host \
    -v /tmp/.X11-unix:/tmp/.X11-unix:rw \
    -v ${HOME}/vscode_projects/orb_slam3_ros/catkin_ws:/root/catkin_ws \
    -v ${DATA_PATH}:/root/datasets \
    --privileged \
    --cap-add sys_ptrace \
    --runtime=nvidia \
    --gpus all \
    -it --name $PROJECT_NAME $IMAGE_NAME /bin/bash

xhost -local:docker