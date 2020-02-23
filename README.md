# .rosrc
ROS1 Help macros for `.bashrc`

Startup scripts for ros1 enviroment

Copy the folder `.rosrc` in your home directory

You can use git:
```bash
cd ~
git clone https://github.com/marcocostanzo/.rosrc.git
```

Add this in your `~/.bashrc`
```bash
if [ -f ~/.rosrc/rosrc.bash ]; then
   source ~/.rosrc/rosrc.bash /opt/ros/kinetic
fi
```
Change `/opt/ros/kinetic` with your rosdistro install folder.
