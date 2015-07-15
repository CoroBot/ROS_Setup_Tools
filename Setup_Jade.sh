#! /bin/sh
#
# Setup.sh
# Copyright (C) 2015 cameron <cameron@Megatron-Virtual>
#
# Distributed under terms of the MIT license.
#
# Name: Setup_Jade.sh
# Description: ROS Jade Setup Tool for the CoroBot Platform Running Ubuntu 14.04
# Ver: 0.1
# Target Platform: Ubuntu 14.04

# Text Colors

ESC_SEQ='\x1b['
COL_RESET=$ESC_SEQ"39;49;00m"
COL_RED=$ESC_SEQ"31;01m"
COL_CYAN=$ESC_SEQ"36;01m"
COL_GREEN=$ESC_SEQ"32;01m"
COL_WHITE=$ESC_SEQ"37;01m"

VER="0.1"


echo -n -e "
$COL_RED
Welcome to the CoroBot ROS Jade Setup Utility Ver $VER by CoroWare Robotics Solutions.

In order to continue with the installation process, please review the following license agreement and consult your nearby magic eight ball, tea leaves, and local palm readers if you should continue. 

$COL_WHITE
Please, press "ENTER" to continue

>>>"
    read dummy
    more <<EOF

==============================================
CoroBot ROS Jade Setup Information
==============================================

Something, something something, something

The following packages that will be installed along with ROS are:


-System Updates (sudo apt-get update && sudo apt-get upgrade)
-Pip: Python Package Manager
-OpenCV
-Subversion

EOF

echo -e $COL_RED"
Are you ready to insstall? [yes|no]
[Proceed at your own risk. It is recommended that you have a back up.] >>>"
read ans
    if [[ ($ans != "yes") && ($ans != "YES") && ($ans != "Yes") && 
	 ($ans != "y") && ($ans != "Y") ]]

    then
	    echo "Aborting the installation process...."
	    exit 2
    fi
    
    echo -n -e "
    $COL_GREEN

The CoroBot Jade Installation Setup Tool will begin the installation process...
$COL_WHITE"

#Running Operating System updates and upgrades
echo -e -n "$COL_GREEN Updating Operating System and Updates $COL_WHITE"
sudo apt-get update && sudo apt-get upgrade -y
echo -e -n "$COL_GREEN Getting Additional build tools $COL_WHITE"
sudo apt-get install build-essential vim emacs screen checkinstall subversion python-pip
clear

echo -e -n "$COL_RED Now Installing OpenCV $COL_WHITE"

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


#Instalation of additional Python related OpenCV Tools
clear
echo -e -n "$COL_CYAN Getting Python packages for OpenCV $COL_WHITE"
sudo apt-get install python-numpy python-scipy python-matplotlib ipython ipython-notebook python-pandas python-sympy python-nose

echo -e -n "$COL_RED Now installing ROS Jade $COL_WHITE"

echo -e -n "$COL_CYAN Settinng up Sources $COL_WHITE"
sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'

sudo apt-key adv --keyserver hkp://pool.sks-keyservers.net --recv-key 0xB01FA116

sudo apt-get update

OS_NUMBER="($lsb_release -r)"

sudo apt-get install ros-jade-desktop-full

sudo rosdep init
rosdep update
echo "source /opt/ros/jade/setup.bash" >> ~/.bashrc
source ~/.bashrc
echo "Double checkling that ROS is added to the source"
source /opt/ros/jade/setup.bash
sudo apt-get install python-rosinstall


