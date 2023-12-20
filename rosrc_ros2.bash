#!/bin/bash
#
# Initialize rosrc for ROS1
# Internal usage only
#

############################
### ROSRC INTERNAL UTILS ###
############################

# this is needed for Moveit! to work
export LC_NUMERIC=en_US.UTF-8

# Unset all the defined variables
function rosrc_reset() {
    unset ROSRC_SELECTED_WS_FILE
    unset ROS_LOCALHOST_ONLY
    
    unset -f ros_localhost
    unset -f ros_source_ws
    unset -f ros2_localhost_only
    unset -f rosrc_get_ws
    unset -f ros_deselect_ws
    unset -f roscdws
    unset -f ros2_unsource

    unalias catkin_build_symlink 2> /dev/null
    
}

# reset
rosrc_reset

############
### MISC ###
############

function ros2_unsource() {
    unset COLCON_PREFIX_PATH AMENT_CURRENT_PREFIX AMENT_PREFIX_PATH AMENT_SHELL CMAKE_PREFIX_PATH ROS_DISTRO ROS_LOCALHOST_ONLY ROS_PYTHON_VERSION ROS_VERSION
    
    if [[ ${ROSRC_OLD_PYTHONPATH} != "" ]]; then
        PYTHONPATH=$ROSRC_OLD_PYTHONPATH
    else
        unset PYTHONPATH
    fi

    if [[ ${ROSRC_OLD_PATH} != "" ]]; then
        PATH=$ROSRC_OLD_PATH
    else
        unset PATH
    fi

    if [[ ${ROSRC_OLD_LD_LIBRARY_PATH} != "" ]]; then
        LD_LIBRARY_PATH=$ROSRC_OLD_LD_LIBRARY_PATH
    else
        unset LD_LIBRARY_PATH
    fi
    
}

##################
### NETWORKING ###
##################

# SET THE DEFAULT ROS_MASTER_URI (localhost)
function ros2_localhost_only() {
    unset ROS_LOCALHOST_ONLY
    export ROS_LOCALHOST_ONLY=1
}

#################
### COLCON WS ###
#################

# READ THE ROSWS FOLDER FROM FILE (internal usage)
function rosrc_get_ws() {
    if [ -f ${ROSRC_SELECTED_WS_FILE} ]; then
        head -n 1 ${ROSRC_SELECTED_WS_FILE}
    else
        echo ''
    fi
}

# SELECT A CATKIN WS
function ros_select_ws() {
   echo "$(realpath $1)" > ${ROSRC_SELECTED_WS_FILE}
   ros_source_ws
}

function ros_deselect_ws() {
   rm ${ROSRC_SELECTED_WS_FILE} 2> /dev/null
   ros_source_distro
}

# SOURCE THE SELECTED WS
function ros_source_ws() {
    local ROSWS=$(rosrc_get_ws)
    if [[ ${ROSWS} != "" ]]; then
        if [ -f ${ROSWS}/install/setup.bash ]; then
            source ${ROSWS}/install/setup.bash
            echo "ROS2 WS: ${ROSWS}"
        else
            >&2 echo "ROS2 WS ERROR: ${ROSWS} is an invalid colcon workspace"
        fi
    else
        echo "ROSRC: no ws selected!"
    fi
}

# CD IN THE ROOT OF THE SELECTED WS
function roscdws() {
    local ROSWS=$(rosrc_get_ws)
    if [[ ${ROSWS} != "" ]]; then
        cd $ROSWS
    else
        echo "ROSRC: no ws selected!"
    fi
}

# build with --symlink-install
alias colcon_build_symlink='colcon build --symlink-install'

# You can create rosmasterrc and roswsrc to create function to select a custom rosmaster or a catkin_ws
if [ -f $(dirname $BASH_SOURCE)/rosmasterrc ]; then
    source $(dirname $BASH_SOURCE)/rosmasterrc
fi

if [ -f $(dirname $BASH_SOURCE)/roswsrc ]; then
    source $(dirname $BASH_SOURCE)/roswsrc
fi

#################
###  STARTUP  ###
#################

echo "ROSRC: ROS$ROS_VERSION - $ROS_DISTRO"

############################
### INITIALIZE ROSRCVARS ###
############################

ROSRC_SELECTED_WS_FILE=${ROSRC_ROOT}/.ros2_selectedws

ros_source_ws
