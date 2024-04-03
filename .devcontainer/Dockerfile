FROM ros:humble
ARG USERNAME=INF0429
ARG USER_UID=1000
ARG USER_GID=$USER_UID

# Create the user
RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m -s /bin/bash $USERNAME \
    #
    # [Optional] Add sudo support. Omit if you don't need to install software after connecting.
    && apt-get update \
    && apt-get install -y sudo \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME

RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y python3-pip

# Install some packages for ROS2
RUN apt-get update && apt-get install -y \
    ros-humble-ament-cmake \
    ros-humble-rviz2 \
    ros-dev-tools

# Install TurtleBot4 Simulator: Ignition Gazebo
RUN apt-get update && apt-get install -y wget
RUN sh -c 'echo "deb http://packages.osrfoundation.org/gazebo/ubuntu-stable `lsb_release -cs` main" > /etc/apt/sources.list.d/gazebo-stable.list'
RUN wget http://packages.osrfoundation.org/gazebo.key -O - | apt-key add -
RUN apt-get update && apt-get install -y ignition-fortress

# Install TurtleBot4 packages
RUN apt-get update && apt-get install -y \
    ros-humble-turtlebot4-description \
    ros-humble-turtlebot4-msgs \
    ros-humble-turtlebot4-navigation \
    ros-humble-turtlebot4-node \
    ros-humble-turtlebot4-simulator \
    ros-humble-turtlebot4-desktop \
    ros-humble-teleop-twist-keyboard \
    ros-humble-turtlebot4-tutorials \
    ros-humble-turtlesim \
    ~nros-humble-rqt* && \ 
    rm -rf /var/lib/apt/lists/*

# Create ROS2 workspace
RUN mkdir -p /home/$USERNAME/ws/src
RUN chown -R $USERNAME /home/$USERNAME/ws

# Fixing some ignition packages that were giving errors
RUN /bin/bash -c "source /opt/ros/$ROS_DISTRO/setup.bash && \
    cd /home/$USERNAME/ws/src && \
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

# Source ROS packages (RVIZ, teleop)
RUN echo "source /opt/ros/$ROS_DISTRO/setup.bash" >> /home/$USERNAME/.bashrc
RUN echo "source /home/$USERNAME/ws/install/setup.bash" >> /home/$USERNAME/.bashrc

ENV SHELL /bin/bash
# ENV TERM=xterm-256color # Colored terminal

# ********************************************************
# * Anything else you want to do like clean up goes here *
# ********************************************************

# [Optional] Set the default user. Omit if you want to keep the default as root.
USER $USERNAME
WORKDIR /home/$USERNAME

