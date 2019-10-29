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
if [ -f ~/.rosrc/rosrc ]; then
   source ~/.rosrc/rosrc kinetic enp3s0
fi
```
Change `kinetic` with your rosdistro and `enp3s0` with the name of your network interface (to use with extenal ros-network).
You can use `ifconfig` to check your interfaces.
