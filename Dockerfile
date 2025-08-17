FROM ubuntu:22.04

# Avoid interactive prompts during package install
ENV DEBIAN_FRONTEND=noninteractive

# Set up environment variables for ROS
ENV LANG=C.UTF-8
ENV LC_ALL=C.UTF-8

# Create non-root user
ARG USERNAME=poh
ARG UID=1000
ARG GID=1000

# Update system and install basic tools
RUN apt update && apt upgrade -y && \
    apt install -y sudo curl wget nano gnupg2 lsb-release openssh-server python3 python3-pip locales \
    && locale-gen en_US en_US.UTF-8 && update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8

# Create user and grant sudo
RUN groupadd --gid $GID $USERNAME && \
    useradd --uid $UID --gid $GID -m $USERNAME && \
    echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Install ROS 2 Humble
RUN apt update && \
    apt install -y software-properties-common && \
    add-apt-repository universe && \
    curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | apt-key add - && \
    sh -c 'echo "deb http://packages.ros.org/ros2/ubuntu $(lsb_release -cs) main" > /etc/apt/sources.list.d/ros2-latest.list' && \
    apt update && \
    apt install -y ros-humble-desktop && \
    echo "source /opt/ros/humble/setup.bash" >> /etc/bash.bashrc

# SSH config
RUN mkdir /var/run/sshd
RUN echo 'PasswordAuthentication yes' >> /etc/ssh/sshd_config
RUN echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config

# Set password for user
RUN echo "$USERNAME:password" | chpasswd

# Switch to the user
USER $USERNAME

# Source ROS 2 setup in user bashrc
RUN echo "source /opt/ros/humble/setup.bash" >> /home/$USERNAME/.bashrc

# Set workdir
WORKDIR /home/$USERNAME

# Switch back to root to run SSH
USER root

# Expose SSH port
EXPOSE 22

# Default command: start SSH
CMD ["/usr/sbin/sshd", "-D"]
