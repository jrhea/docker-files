# docker-files

## run firefox in a docker container (in OSX)

1. In the XQuartz preferences -> “Security” and make sure you’ve got “Allow connections from network clients” ticked

2. Determine the Docker subnet from Docker preferences -> "Advanced" to see the ip range defined for Docker subnet.  

    *Note: It is set to 192.168.65.0/24 by default.*

3.  Run the firefox container:

    ```bash
    docker run -e DISPLAY=192.168.65.1:0 -v /tmp/.X11-unix:/tmp/.X11-unix jrhea/firefox
    ```
