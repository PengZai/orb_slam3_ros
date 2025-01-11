#!/bin/bash


IMAGE_NAME="orb_slam3:noetic-ros"
DATA_PATH="/home/zhipeng/datasets"
# Pick up config image key if specified
if [[ ! -z "${CONFIG_DATA_PATH}" ]]; then
    DATA_PATH=$CONFIG_DATA_PATH
fi


PROJECT_DIR=$(pwd)
PROJECT_NAME=$(basename "$PWD")


docker build -t $IMAGE_NAME -f "$PROJECT_DIR/catkin_ws/src/$PROJECT_NAME/Dockerfile_for_dev" .


xhost +local:docker

docker run --rm \
    -e DISPLAY \
    -v ~/.Xauthority:/root/.Xauthority:rw \
    --network host \
    -v /tmp/.X11-unix:/tmp/.X11-unix:rw \
    -v /home/zhongzhipeng/vscode_projects/orb_slam3_ros/catkin_ws:/root/catkin_ws \
    -v /mnt/usb/datasets:/root/datasets \
    --privileged \
    --cap-add sys_ptrace \
    --runtime=nvidia \
    --gpus all \
    -it --name orb_slam3_ros orb_slam3:noetic-ros /bin/bash

xhost -local:docker