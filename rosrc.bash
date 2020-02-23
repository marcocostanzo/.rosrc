#!/bin/bash
#
# Usage
# source rosrc.bash path/to/rosdistro
# path/to/rosdistro is the path to the ros installation
# e.g. /opt/ros/kinetic [MANDATORY]
#
# Put the following in your bashrc and change the path and distro
#
#  if [ -f ~/.rosrc/rosrc.bash ]; then
#    source ~/.rosrc/rosrc.bash /opt/ros/kinetic
#  fi
#  
#
# You can create ~/.rosrc/rosmasterrc and ~/.rosrc/roswsrc and write functions to select a custom rosmaster or a catkin_ws
#
#
#

if [ "$(type -t rosrc_clear)" = 'function' ]; then
   rosrc_clear
fi

#COMPLEATLY CLEAR ALL ROSRC
function rosrc_clear() {
   if [ "$(type -t rosrc_reset)" = 'function' ]; then
      rosrc_reset
   fi
   unset -f rosrc_reset
   unset -f rosrc_clear
   unalias ros_source_distro 2> /dev/null
   unset ROSRC_ROS_BASE_FOLDER
   unset ROSRC_ROOT
}

ROSRC_ROS_BASE_FOLDER=$1
ROSRC_ROOT=$(dirname $BASH_SOURCE)

alias ros_source_distro='source ${ROSRC_ROS_BASE_FOLDER}/setup.bash'

#start to source ros
ros_source_distro

case $ROS_VERSION in

   1)
      source $ROSRC_ROOT/rosrc_ros1.bash "$@"
      ;;

  2)
    >&2 echo "ROSRC: ROS2 SUPPORT WILL BE AVAILABLE SOON..."
    rosrc_clear
    return
    ;;

  *)
    >&2 echo "ROSRC: UNSUPPORTED ROS_VERSION: ${ROS_VERSION}"
    rosrc_clear
    return
    ;;

esac
