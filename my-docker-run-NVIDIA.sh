#!/usr/bin/sh

# Check if an image name was provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <image-name>"
    exit 1
fi

IMAGE_NAME="$1"
USERNAME="INF0429"
ROS2_WORKSPACE="ros2_ws"

# Allow local connections to the X server for GUI applications in Docker
xhost +local:

# Setup for X11 forwarding to enable GUI
XAUTH=/tmp/.docker.xauth
touch $XAUTH
xauth nlist $DISPLAY | sed -e 's/^..../ffff/' | xauth -f $XAUTH nmerge -

# Run the Docker container with the selected image and configurations for GUI applications
docker run -it --rm \
    --name="turtlebot4" \
    --privileged \
    --network=host \
    --gpus=all \
    --env="DISPLAY=$DISPLAY" \
    --env="QT_X11_NO_MITSHM=1" \
    --env="ROS_LOCALHOST_ONLY=1" \
    --env="ROS_DOMAIN_ID=91" \
    --env="NVIDIA_VISIBLE_DEVICES=all" \
    --env="NVIDIA_DRIVER_CAPABILITIES=all" \
    --env="TERM=xterm-256color" \
    --env="IGN_IP=127.0.0.1" \
    --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
    --volume="/home/kuntur/Documents/$USERNAME/$ROS2_WORKSPACE/src:/home/$USERNAME/$ROS2_WORKSPACE/src:rw" \
    --env="XAUTHORITY=$XAUTH" \
    --volume="$XAUTH:$XAUTH" \
    --runtime=nvidia \
    "$IMAGE_NAME"
