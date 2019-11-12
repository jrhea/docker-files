build: 
	docker build -t jrhea/firefox .
run:
	docker run -e DISPLAY=host.docker.internal:0  -v /tmp/.X11-unix:/tmp/.X11-unix jrhea/firefox
