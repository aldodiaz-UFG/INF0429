FROM ros:humble
ARG ROS2_WORKSPACE=ros2_ws
ARG USERNAME=INF0429
ARG USER_UID=1000
ARG USER_GID=$USER_UID

# Create the local user
RUN groupadd --gid $USER_GID $USERNAME \
	&& useradd --uid $USER_UID --gid $USER_GID -m -s /bin/bash $USERNAME 

# Install basic packages
RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y \
    python3-pip \
    wget \
    # [Optional] Add sudo support
    # Omit if you don't need to install software after connecting
    sudo \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME

# Install ROS2, TurtleBot4, Gazebo packages
RUN sh -c 'echo "deb http://packages.osrfoundation.org/gazebo/ubuntu-stable `lsb_release -cs` main" > /etc/apt/sources.list.d/gazebo-stable.list'
RUN wget http://packages.osrfoundation.org/gazebo.key -O - | apt-key add -
RUN apt-get update && apt-get install -y \
    # ROS2 utilities
    ros-dev-tools \
    ros-humble-ament-cmake \
    # ROS demo packages
    ros-humble-demo-nodes-cpp \
    # rqt
    ~nros-humble-rqt* \
    # teleoperation
    ros-humble-teleop-twist-keyboard \
    # turtlesim
    ros-humble-turtlesim \
    # rviz2
    ros-humble-rviz2 \
    # turtlebot4
    ros-humble-turtlebot4-description \
    ros-humble-turtlebot4-msgs \
    ros-humble-turtlebot4-navigation \
    ros-humble-turtlebot4-node \
    ros-humble-turtlebot4-simulator \
    ros-humble-turtlebot4-desktop \
    ros-humble-turtlebot4-tutorials \
    # Gazebo Ignition Fortress
    ignition-fortress \
    # LaTeX fonts
    fonts-cmu \
    # OpenGL required to run OpenCV
    libgl1-mesa-glx

# Python packages
RUN pip3 install \
    # Plots
    matplotlib \
    # Notebooks
    jupyter \
    # Machine Learning
    scipy pandas scikit-learn \
    # Signal Processing
    PyWavelets wave librosa music21 \
    # Image Processing & Computer Vision
    opencv-python opencv-contrib-python scikit-image \
    # Read ROS2 bags into a dataframe
    rosbags-dataframe \
    # Plots with interactive visualization of coordinates
    plotly \
    # Download datasets from shared Google Drive files
    gdown \
    # Network Science
    networkx
    
# Create ROS2 workspace
RUN sudo -u $USERNAME \
    mkdir -p /home/$USERNAME/$ROS2_WORKSPACE/src

# Fixing some ignition packages that were giving errors
RUN /bin/bash -c "source /opt/ros/$ROS_DISTRO/setup.bash && \
    cd /home/$USERNAME/$ROS2_WORKSPACE/src && \
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

# Install ROS dependencies
RUN rosdep fix-permissions && \
    rosdep update && \
    rosdep install --from-paths /home/$USERNAME/$ROS2_WORKSPACE/src --ignore-src -y && \
    chown -R $(whoami) /home/$USERNAME/$ROS2_WORKSPACE

# Source ROS packages on startup (RVIZ, teleop)
RUN echo "source /opt/ros/$ROS_DISTRO/setup.bash" >> /home/$USERNAME/.bashrc
RUN echo "source /home/$USERNAME/$ROS2_WORKSPACE/install/setup.bash" >> /home/$USERNAME/.bashrc

ENV SHELL /bin/bash

# ********************************************************
# * Anything else you want to do like clean up goes here *
# ********************************************************

# [Optional] Set the default user. Omit if you want to keep the default as root.
USER $USERNAME
WORKDIR /home/$USERNAME/$ROS2_WORKSPACE
