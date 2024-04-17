FROM ros:humble
ARG ROS2_WORKSPACE=/ros2_ws

RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y \
    python3-pip \
    wget

# Install Gazebo, ROS2 and TurtleBot4 packages
RUN sh -c 'echo "deb http://packages.osrfoundation.org/gazebo/ubuntu-stable `lsb_release -cs` main" > /etc/apt/sources.list.d/gazebo-stable.list'
RUN wget http://packages.osrfoundation.org/gazebo.key -O - | apt-key add -
RUN apt-get update && apt-get install -y \
    ros-dev-tools \
    ros-humble-ament-cmake \
    ros-humble-rviz2 \
    ros-humble-turtlebot4-description \
    ros-humble-turtlebot4-msgs \
    ros-humble-turtlebot4-navigation \
    ros-humble-turtlebot4-node \
    ros-humble-turtlebot4-simulator \
    ros-humble-turtlebot4-desktop \
    ros-humble-teleop-twist-keyboard \
    ros-humble-turtlebot4-tutorials \
    ros-humble-turtlesim \
    ros-humble-demo-nodes-cpp \
    ~nros-humble-rqt* \
    ignition-fortress \
    rm -rf /var/lib/apt/lists/*

# Create ROS2 workspace
RUN mkdir -p $ROS2_WORKSPACE/src

# Fixing some ignition packages that were giving errors
RUN /bin/bash -c "source /opt/ros/$ROS_DISTRO/setup.bash && \
    cd $ROS2_WORKSPACE/src && \
    git clone https://github.com/ros-controls/gz_ros2_control.git && \
    cd gz_ros2_control && \
    git checkout humble && \
    cd ../.. && \
    colcon build --packages-select ign_ros2_control"

# Changing the URL for generating some worlds
RUN sed -i 's/fuel.ignitionrobotics.org/fuel.gazebosim.org/g' /opt/ros/$ROS_DISTRO/share/turtlebot4_ignition_bringup/worlds/warehouse.sdf
RUN sed -i 's/fuel.ignitionrobotics.org/fuel.gazebosim.org/g' /opt/ros/$ROS_DISTRO/share/turtlebot4_ignition_bringup/worlds/depot.sdf
RUN sed -i 's/fuel.ignitionrobotics.org/fuel.gazebosim.org/g' /opt/ros/$ROS_DISTRO/share/irobot_create_ignition_bringup/worlds/depot.sdf
RUN sed -i 's/ign_args/gz_args/g' /opt/ros/$ROS_DISTRO/share/turtlebot4_ignition_bringup/launch/ignition.launch.py

# PostCreate commands
RUN rosdep update && \
    rosdep install --from-paths src --ignore-src -y && \
    chown -R $(whoami) $ROS2_WORKSPACE

# Source ROS packages (RVIZ, teleop)
RUN echo "source /opt/ros/$ROS_DISTRO/setup.bash" >> /.bashrc
RUN echo "source $ROS2_WORKSPACE/install/setup.bash" >> /.bashrc

ENV SHELL /bin/bash

# ********************************************************
# * Anything else you want to do like clean up goes here *
# ********************************************************

# [Optional] Set the default user. Omit if you want to keep the default as root.
WORKDIR $ROS2_WORKSPACE
