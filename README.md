# .rosrc
ROS1 Help macros for `.bashrc`

Startup scripts for ROS1 and ROS2 enviroment

Copy the folder `.rosrc` in your home directory

You can use git:
```bash
git clone https://github.com/marcocostanzo/.rosrc.git ~/.rosrc --depth=1
```

Add this in your `~/.bashrc`
```bash
if [ -f ~/.rosrc/rosrc.bash ]; then
   source ~/.rosrc/rosrc.bash /opt/ros/humble
fi
```
Change `/opt/ros/humble` with your rosdistro install folder.
