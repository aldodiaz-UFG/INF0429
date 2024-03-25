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
	&& apt-get install -y sudo wget nano \
	&& echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
	&& chmod 0440 /etc/sudoers.d/$USERNAME

# Install TurtleBot4 Simulator: Ignition Gazebo
RUN sh -c 'echo "deb http://packages.osrfoundation.org/gazebo/ubuntu-stable `lsb_release -cs` main" > /etc/apt/sources.list.d/gazebo-stable.list'
RUN wget http://packages.osrfoundation.org/gazebo.key -O - | apt-key add -

RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y python3-pip \
    # Install RVIZ
    ros-humble-rviz2 \
    # Install TurtleBot 4 Common
    ros-humble-turtlebot4-description \
    ros-humble-turtlebot4-msgs \
    ros-humble-turtlebot4-navigation \
    ros-humble-turtlebot4-node \
    # Install TurtleBot4 Simulator: Dev Tools
    ros-dev-tools \
    # Install TurtleBot4 Simulator: Ignition Gazebo
    ignition-fortress \
    # Install TurtleBot4 Simulator
    ros-humble-turtlebot4-simulator \
    # Install TurtleBot4 Desktop
    ros-humble-turtlebot4-desktop \
    # Install Keyboard Teleoperation
    ros-humble-teleop-twist-keyboard \
    # Install TurtleBot4 Tutorial Package
    ros-humble-turtlebot4-tutorials \
    # Install turtlesim
    ros-humble-turtlesim \
    # Install rqt
    ~nros-humble-rqt*

# Create ROS2 workspace
RUN mkdir -p /home/$USERNAME/ws
RUN chown -R $USERNAME /home/$USERNAME/ws

# Source ROS packages (RVIZ, teleop)
RUN echo "source /opt/ros/${ROS_DISTRO}/setup.bash" >> /home/$USERNAME/.bashrc

ENV SHELL /bin/bash
# ENV TERM=xterm-256color # Colored terminal

# ********************************************************
# * Anything else you want to do like clean up goes here *
# ********************************************************

# [Optional] Set the default user. Omit if you want to keep the default as root.
USER $USERNAME
WORKDIR /home/$USERNAME

