#!/bin/bash
# Entrypoint script for switching and building branches in the docker container on boot

# Define the ROS workspace
ROS_WS="/home/ros2_ws"

# Check if the branch argument is empty
if [ -z "$1" ]; then
    echo "Branch argument empty, keeping default branch: main"
    BRANCH="main"
else
    BRANCH=$1
    echo "Switching to branch: ${BRANCH}"
fi

# Navigate to the src directory and iterate through each package
SRC_DIR="${ROS_WS}/src"
cd ${SRC_DIR}

for PACKAGE in */; do
    if [ -d "${PACKAGE}/.git" ]; then
        echo "Updating package: ${PACKAGE}"
        cd ${PACKAGE}
        git fetch
        git checkout ${BRANCH} || echo "Branch ${BRANCH} does not exist for ${PACKAGE}, skipping..."
        git pull || echo "Failed to pull changes for ${PACKAGE}, skipping..."
        cd ..
    else
        echo "Skipping ${PACKAGE}, not a git repository."
    fi
done

# Rebuild the workspace
cd ${ROS_WS}
colcon build

# Add ROS environment setup to bashrc
echo "source /opt/ros/humble/setup.bash" >> /root/.bashrc
echo "source /opt/ros/humble/share/ros2cli/environment/ros2-argcomplete.bash" >> /root/.bashrc

# Fix missing "ucm_set_global_opts"
apt-get update && apt-get install --reinstall -y \
    libmpich-dev \
    hwloc-nox libmpich12 mpich

# Start an interactive bash shell with ROS and workspace sourced, including bash completion
exec bash --rcfile /root/.bashrc
