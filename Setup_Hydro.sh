#! /bin/sh
#
# Setup.sh
# Copyright (C) 2015 CoroWare Robotics Solutions  <www.corobot.net>
# Author: Cameron Owens <cowens@coroware.com>
#
# Distributed under terms of the MIT license.
#
# Name: Setup_Hydro.sh
# Description: ROS Hydro Setup for Ubuntu 14.04
# Ver: 0.1
# Plat: Ubuntu 14.04

Ver="0.1"

echo -n "

Welcome to the CoroBot ROS Hydro Setup Utility Ver (Insert Version Var) by CoroWare Robotics Solutions. 

In order to continue the installation process, please review the permissions, warnings, tea leaves, magic eight balls, and license agreement. 

Please, press ENTER to continue

>>>"
    read dummy
    more <<EOF

==============================
CoroBot ROS Hydro Setup Information
==============================
Becasue ROS Hydro is not fully supported by the OSRF to run on Ubuntu 14.04, to install it one must install it from source. This script aims to do just that along with installing the other tools and packages that are important/valuable for ROS as well as the CoroBot ROS Stack. 

This shell script follows the general directions for installing ROS Hydro on Ubuntu 14.04 as outlined @ http://wiki.ros.org/hydro/Installation/Trusty

Before installing ROS Hydro, this script also installs some of the following dependencies and tools that are required for installing ROS Hydro

-System updates (sudo apt-get update && sudo apt-get upgrade)
-Pip: Python package manager.



EOF
    echo -n"
Are you ready to install? [yes|no]
[Proceeed at your own risk...] >>>"
    read ans
    if [[ ($ans != "yes") && ($ans != "Yes") && ($ans != "YES") &&
	    ($ans != "y") && ($ans != "Y") ]]
    then
        echo "Aborting the installation process..."
	exit 2
    fi

    echo -n "
The CoroBot Hydro Installation Setup tool will begin the installation process
"


#Run System Updates and Upgrades

echo "Updating System and installing system upgrades"
sudo apt-get update && sudo apt-get upgrade -y

##Install Additional Dependencies that cause issues with 14.04.2

clear

#Setup your Sources

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

catkin build

source ~/ros_hydro/install_isolated/setup.bash




