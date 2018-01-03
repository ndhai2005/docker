Docker-based Netbeans
NetBeans v8.2 in a Docker container
Oracle Java 8 (1.8.0_151) JDK + X11 (display GUI)
Requirements
Docker 1.13.1+
An X11 socket
Build
./build.sh
Run
./run.sh
Configuration
The docker container will assume there is a default /workspace folder. Be default, './run.sh', will use/create the local folder, "$HOME/data_docker/netbeans" to map into the docker's internal "/workspace" folder.

The above approach will ensure all your projects created in the container's "/workspace" folder is "persistent" in your local folder, i.e., "$HOME/data_docker/netbeans/workspace"

Making plugins persist between sessions
NetBeans plugins are kept on $HOME/.netbeans inside the container, so if you want to keep them around after you close it, you'll need to share it with your host.

For example:

docker run -ti --rm \
           -e DISPLAY=$DISPLAY \
           -v /tmp/.X11-unix:/tmp/.X11-unix \
           -v `pwd`/.netbeans:/home/developer/.netbeans \
           -v `pwd`:/home/developer/workspace \
           openkbs/netbeans
Not seeing the NetBeans X11 screen
You might have an issue with the X11 socket permissions since the default user used by the base image has an user and group ids set to 1000, two options:

Create your own base image with the appropriate ids or
Or, at the host, run
`xhost +` 
try again.
