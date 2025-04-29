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

# COMPLEATLY CLEAR ALL ROSRC
function rosrc_clear() {
   if [ "$(type -t rosrc_reset)" = 'function' ]; then
      rosrc_reset
   fi
   unset ROSRC_ROS_BASE_FOLDER
   unset ROSRC_ROOT
   unset ROSRC_OLD_PYTHONPATH
   unset ROSRC_OLD_PATH
   unset ROSRC_OLD_LD_LIBRARY_PATH
   unset ROSRC_AMENT_PREFIX_PATH

   unset -f rosrc_reset
   unset -f rosrc_clear
   unset -f rosrc_update
   
   unalias ros_source_distro 2> /dev/null
   
}

# UPDATE rosrc
function rosrc_update() {
   cd $ROSRC_ROOT
   git pull
   cd - > /dev/null
}

ROSRC_ROS_BASE_FOLDER=$1
ROSRC_ROOT=$(dirname $BASH_SOURCE)

alias ros_source_distro='source ${ROSRC_ROS_BASE_FOLDER}/setup.bash'

# SAVE OLD ENVIRONMENT
if [[ ${PYTHONPATH} != "" ]]; then
   ROSRC_OLD_PYTHONPATH=$PYTHONPATH
fi
if [[ ${PATH} != "" ]]; then
   ROSRC_OLD_PATH=$PATH
fi
if [[ ${LD_LIBRARY_PATH} != "" ]]; then
   ROSRC_OLD_LD_LIBRARY_PATH=$LD_LIBRARY_PATH
fi
if [[ ${AMENT_PREFIX_PATH} != "" ]]; then
   ROSRC_AMENT_PREFIX_PATH=$AMENT_PREFIX_PATH
fi

#start to source ros
ros_source_distro

case $ROS_VERSION in

   1)
      source $ROSRC_ROOT/rosrc_ros1.bash "$@"
      return
      ;;

  2)
      source $ROSRC_ROOT/rosrc_ros2.bash "$@"
      return
      ;;

  *)
      >&2 echo "ROSRC: UNSUPPORTED ROS_VERSION: ${ROS_VERSION}"
      rosrc_clear
      return
      ;;

esac
