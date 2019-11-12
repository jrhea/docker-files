# docker-files

## run firefox in a docker container (in OSX)

1. In the XQuartz preferences -> “Security” and make sure you’ve got “Allow connections from network clients” ticked

2.  Run the firefox container:

    ```bash
    docker run -e DISPLAY=host.docker.internal:0 -v /tmp/.X11-unix:/tmp/.X11-unix jrhea/firefox
    ```
