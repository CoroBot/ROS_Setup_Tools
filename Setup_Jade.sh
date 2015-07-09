#! /bin/sh
#
# Setup.sh
# Copyright (C) 2015 cameron <cameron@Megatron-Virtual>
#
# Distributed under terms of the MIT license.
#


#This shell script is for installing the full ROS Desktop

#Run System Updates and Upgrades
sudo apt-get update && sudo apt-get upgrade -y

##Install Additional Dependencies that cause issues with 14.04.2



#Setup your Sources

sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'

sudo apt-key adv --sudo apt-key adv --keyserver hkp://pool.sks-keyservers.net --recv-key 0xB01FA116

echo "Updating Repo information"
sudo apt-get update

echo "Getting ROS Jade Dekstop-Full"
sudo apt-get install ros-jade-desktop-full

echo "inititializing rosdep"
sudo rosdep init
echo "Updating rosdep"
rosdep update

echo "Adding ROS Jade to Source"
echo "source /opt/ros/jade/setup.bash" 
>> ~/.bashrc
source ~/.bashrc

source /opt/ros/jade/setup.bash

echo "Installing rosinstall for python"
sudo apt-get install python-rosinstall

