#!/bin/bash
#
# Initialize rosrc for ROS1
# Internal usage only
#

############################
### ROSRC INTERNAL UTILS ###
############################

echo "ROSRC: ROS$ROS_VERSION - $ROS_DISTRO"

# Unset all the defined variables
function rosrc_reset() {
    unset ROSRC_SELECTED_WS
    
    unset -f ros_update_ip
    unset -f ros_set_ros_master_uri
    unset -f ros_set_this_as_master
    unset -f ros_select_ws
    unset -f ros_source_ws

    unalias roscdws 2> /dev/null
    unalias catkin_build_release 2> /dev/null
    unalias catkin_build_debug 2> /dev/null
}

# reset
rosrc_reset

############################
### INITIALIZE ROSRCVARS ###
############################

##################
### NETWORKING ###
##################

# Set the ROS_IP env var
# this functions checks the ip addresses with hostname -I
# If more ip addresses found -> ask to user
function ros_update_ip() {
    unset ROS_IP
    ip_addresses=($(hostname -I))

    if [ ${#ip_addresses[@]} = 0 ]; then
        export ROS_IP=127.0.0.1
    elif [ ${#ip_addresses[@]} = 1 ]; then
        export ROS_IP=${ip_addresses[0]}
    else
        echo "Select ROS_IP address:"
        for i in ${!ip_addresses[@]}; do
            echo "$i) ${ip_addresses[i]}"
        done
        read -p ">>> "
        if [[ $REPLY =~ ^[+-]?[0-9]+$ ]]; then
            if [ "$REPLY" -ge 0 ] && [ "$REPLY" -lt ${#ip_addresses[@]} ]; then
                export ROS_IP=${ip_addresses[${REPLY}]}
                return
            fi
        fi
        >&2 echo "INVALID CHOICE"
    fi
    if [ $ROS_IP ]; then
        echo "ROS_IP=${ROS_IP}"
    fi
}

# Set the ROS_MASTER_URI env variable
function ros_set_ros_master_uri() {
   export ROS_MASTER_URI=$1
   echo "ROS_MASTER_URI=${ROS_MASTER_URI}"
}

# Set this pc as rosmaster
# set the env vars ROS_MASTER_URI and ROS_IP
# the default port is 11311, you can change it with $1
# call ros_update_ip
function ros_set_this_as_master() {
    if [ "$1" ]; then
        port=$1
    else
        port=11311
    fi
    ros_update_ip
    if [ $ROS_IP ]; then
        export ROS_MASTER_URI=http://${ROS_IP}:${port}
        echo "ROS_MASTER_URI=${ROS_MASTER_URI}"
    fi
}

# SET THE DEFAULT ROS_MASTER_URI (localhost)
function ros_localhost() {
    unset ROS_IP
    export ROS_MASTER_URI=http://localhost::11311
}

#################
### CATKIN_WS ###
#################

# SELECT A CATKIN WS
function ros_select_ws() {
   export ROSRC_SELECTED_WS=$(realpath $1)
   ros_source_ws
}

# SOURCE THE SELECTED WS
function ros_source_ws() {
    source $ROSRC_SELECTED_WS/devel/setup.bash
    echo "ROS WS: $ROSRC_SELECTED_WS"
}

# CD IN THE ROOT OF THE SELECTED WS
alias roscdws='cd $ROSRC_SELECTED_WS'

# build with tag release
alias catkin_build_release='catkin build -DCMAKE_BUILD_TYPE=Release'

# build with tag debug
alias catkin_build_debug='catkin build -DCMAKE_BUILD_TYPE=Debug'

# You can create rosmasterrc and roswsrc to create function to select a custom rosmaster or a catkin_ws
if [ -f $(dirname $BASH_SOURCE)/rosmasterrc ]; then
    source $(dirname $BASH_SOURCE)/rosmasterrc
fi

if [ -f $(dirname $BASH_SOURCE)/roswsrc ]; then
    source $(dirname $BASH_SOURCE)/roswsrc
fi
