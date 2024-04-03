#!/bin/bash

# Check if an image name was provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <image-name>"
    exit 1
fi

IMAGE_NAME="$1"
USERNAME=INF0429

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
    --env="DISPLAY=$DISPLAY" \
    --env="QT_X11_NO_MITSHM=1" \
    --env="ROS_LOCALHOST_ONLY=1" \
    --env="ROS_DOMAIN_ID=91" \
    --env="TERM=xterm-256color" \
    --env="LIBGL_ALWAYS_SOFTWARE=0" \
    --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
    --env="XAUTHORITY=$XAUTH" \
    --volume="$XAUTH:$XAUTH" \
    "$IMAGE_NAME"
