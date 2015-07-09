#! /bin/sh
#
# Setup.sh
# Copyright (C) 2015 cameron <cameron@Megatron-Virtual>
#
# Distributed under terms of the MIT license.
#


#This shell script is for installing the full ROS Desktop

#Run System Updates and Upgrades

echo "Updating System and installing system upgrades"
sudo apt-get update && sudo apt-get upgrade -y

##Install Additional Dependencies that cause issues with 14.04.2

clear

#Setup your Sources
echo "ROS Hydro is not officially supported on Ubuntu Trusty. That said, it runs very well and CoroWare Robotics is supporting running Hydro on Trusty"

echo "Installing the dependencies"
sudo apt-get install python-pip

##Need to update to have user feedback and confirmation dialogs

sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'

sudo apt-key adv --keyserver hkp://pool.sks-keyservers.net --recv-key 0xB01FA116

sudo add-apt-repository ppa:openrave/release

sudo apt-get update
sudo apt-get install -y git svn mercurial python-pip build-essential
sudo pip install -U rosdep rosinstall_generator wstool rosinstall catkin_tools
sudo rosdep init
rosdep update

mkdir -p ~/ros_hydro
cd ~/ros_hydro

rosinstall_generator desktop_full --rosdistro hydro --deps --wet-only --tar > hydro-desktop-full-wet.rosinstall

wstool init -j8 src hydro-desktop-full-wet.rosinstall

sudo apt-get install -y $(rosdep install --from-paths src --ignore-src --rosdistro hydro -y -s | sed '/^#/d' | sed ':a;N;$!ba;s/\n/ /g' | sed 's/sudo apt-get install -y/ /g')

rosdep install --from-paths src --ignore-src --rosdistro hydro -y

catkin config --install --cmake-args -DCMAKE_BUILD_TYPE=Release

catkin build

source ~/ros_hydro/install/setup.bash

mv -i hydro-desktop-full-wet.rosinstall hydro-desktop-full-wet.rosinstall.old

rosinstall_generator desktop_full --rosdistro hydro --deps --wet-only --tar > hydro-desktop-full-wet.rosinstall

diff -u hydro-desktop-full-wet.rosinstall hydro-desktop-full-wet.rosinstall.old
wstool merge -t src hydro-desktop-full-wet.rosinstall
wstool update -t src

catkinbuild

soure ~/ros_hydro/install_isolated/setup.bash




