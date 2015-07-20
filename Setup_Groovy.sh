#! /bin/sh
#
# Setup_Groovy.sh
# Copyright (C) 2015 cameron <cameron@cameron-ROS>
#
# Distributed under terms of the MIT license.
#


sudo apt-get update && sudo apt-get upgrade -y

sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu precise main" > /etc/apt/sources.list.d/ros-latest.list'

wget http://packages.ros.org/ros.key -O - | sudo apt-key add -
sudo apt-get udpate
sudo apt-get install ros-groovy-desktop-full -y
sudo rosdep init
rosdep update
echo "source /opt/ros/groovy/setup.bash" >> ~/.bashrc
source ~/.bashrc
source /opt/ros/groovy/setup.bash
sudo apt-get install python-rosinstall

sudo apt-get install build-essential cmake python-dev swig libopencv-dev libstatgrab-dev libgdk-pixbuf2.0-dev libgnomecanvas2-dev libusb-dev libqt4-dev qt4-dev-tools subversion libgps-dev gpsd libsdl1.2-dev gpsd-clients libtheora0 libtheora-dev libogg-dev git libboost-all-dev v4l-conf uvcdynctrl git ros-groovy-desktop-full ros-groovy-openni-camera ros-groovy-laser-drivers ros-groovy-joystick-drivers ros-groovy-qt-gui

cd ~
wget http://www.phidgets.com/downloads/libraries/libphidget.tar.gz
tar -xvzf libphidget.tar.gz

cd ~
mkdir corobot_packages
cd corobot_packages
mkdir src
cd src
catkin_init_workspace

git clone https://github.com/morgancormier/corobot.git corobot
cd ..
catkin_make

source ~/corobot_packages/devel/setup.bash
