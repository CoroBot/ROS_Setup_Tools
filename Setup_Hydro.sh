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

ESC_SEQ='\x1b['
COL_RESET=$ESC_SEQ"39;49;00m"
COL_RED=$ESC_SEQ"31;01m"
COL_CYAN=$ESC_SEQ"36;01m"
COL_GREEN=$ESC_SEQ"32;01m"
COL_WHITE=$ESC_SEQ"37;01m"

Ver="0.1"

echo -n -e "
$COL_RED
Welcome to the CoroBot ROS Hydro Setup Utility $Ver by CoroWare Robotics Solutions. 

In order to continue the installation process, please review the permissions, warnings, tea leaves, magic eight balls, and license agreement.
$COL_RESET
Please, press ENTER to continue
$COL_CYAN
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

echo -e $COL_RED"
Are you ready to install? [yes|no]
[Proceeed at your own risk...] >>>"
read ans
    if [[ ($ans != "yes") && ($ans != "Yes") && ($ans != "YES") &&
	    ($ans != "y") && ($ans != "Y") ]]
    then
        echo "Aborting the installation process..."
	exit 2
    fi

    echo -n -e "
    $COL_GREEN
The CoroBot Hydro Installation Setup tool will begin the installation process
$COL_RESET
"


#Run System Updates and Upgrades

echo -e $COL_GREEN"Updating System and installing system upgrades"$COL_RESTE

sudo apt-get update && sudo apt-get upgrade -y

##Install Additional Dependencies that cause issues with 14.04.2

clear


echo -e $COL_GREEN "Installing the dependencies" $COL_RESET

sudo apt-get install -y python-pip
clear 
sudo apt-get install subversion build-essential mercurial vim emacs screen checkinstall 
clear
echo -e $COL_RED "Getting OpenCV and Installing... Because it's AWESOME"
echo -e $COL_WHITE
version="$(wget -q -O - http://sourceforge.net/projects/opencvlibrary/files/opencv-unix | egrep -m1 -o '\"[0-9](\.[0-9]+)+' | cut -c2-)"
echo "Installing OpenCV" $version
mkdir OpenCV
cd OpenCV
echo "Removing any pre-installed ffmpeg and x264"
sudo apt-get -qq remove ffmpeg x264 libx264-dev
echo "Installing Dependenices"
sudo apt-get -qq install libopencv-dev build-essential checkinstall cmake pkg-config yasm libjpeg-dev libjasper-dev libavcodec-dev libavformat-dev libswscale-dev libdc1394-22-dev libxine-dev libgstreamer0.10-dev libgstreamer-plugins-base0.10-dev libv4l-dev python-dev python-numpy libtbb-dev libqt4-dev libgtk2.0-dev libfaac-dev libmp3lame-dev libopencore-amrnb-dev libopencore-amrwb-dev libtheora-dev libvorbis-dev libxvidcore-dev x264 v4l-utils ffmpeg cmake qt5-default checkinstall
echo "Downloading OpenCV" $version
wget -O OpenCV-$version.zip http://sourceforge.net/projects/opencvlibrary/files/opencv-unix/$version/opencv-"$version".zip/download
echo "Installing OpenCV" $version
unzip OpenCV-$version.zip
cd opencv-$version
mkdir build
cd build
cmake -D CMAKE_BUILD_TYPE=RELEASE -D CMAKE_INSTALL_PREFIX=/usr/local -D WITH_TBB=ON -D BUILD_NEW_PYTHON_SUPPORT=ON -D WITH_V4L=ON -D INSTALL_C_EXAMPLES=ON -D INSTALL_PYTHON_EXAMPLES=ON -D BUILD_EXAMPLES=ON -D WITH_QT=ON -D WITH_OPENGL=ON ..
make -j2
sudo checkinstall
sudo sh -c 'echo "/usr/local/lib" > /etc/ld.so.conf.d/opencv.conf'
sudo ldconfig
echo "OpenCV" $version "ready to be used"

##Need to update to have user feedback and confirmation dialogs

sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu trusty main" > /etc/apt/sources.list.d/ros-latest.list'
$COL_WHITE
echo -e "$COL_RED Getting Verification Key"
wget https://raw.githubusercontent.com/ros/rodistro/master/ros.key -O - | sudo apt-key add -
echo -e "$COL_GREEN Updating Repo Information and Upgrading for good Measure"
sudo apt-get update && sudo apt-get upgrade -y
clear
echo -e "$COL_RED Updating again for good measure.."
sudo apt-get udpate && sudo apt-get upgrade -y
sudo apt-get install python-rosdep python-rosinstall-generator python-wstool python-rosinstall build-essential
sudo apt-get update
sudo rosdep init
rosdep update

mkdir ~/ros_catkin_ws && cd ~/ros_catkin_ws

rosinstall_generator desktop_full --rosdistro hydro --deps --wet-only --tar > hydro-desktop-full-wet.rosinstall

wstool init -j8 src hydro-desktop-full-wet.rosinstall

rosdep install --from-paths src --ignore-src --rosdistro hydro -y

./src/catkin/bin/catkin_make_isolated --install -DCMAKE_BUILD_TYPE=Release

source ~/ros_catkin_ws/install_isolated/setup.bash

mv -i hydro-desktop-full-wet.rosinstall hydro-desktop-full-wet.rosinstall.old

rosinstall_generator desktop_full --rosdistro hydro --deps --wet-only --tar > hydro-desktop-full-wet.rosinstall

diff -u hydro-desktop-full-wet.rosinstall hydro-desktop-full-wet.rosinstall.old

wstool merge -t src hydro-desktop-full-wet.rosinstall

tool update -t src

./src/catkin/bin/catkin_make_isolated --install

source ~/ros_catkin_ws/install_isolated/setup.bash
