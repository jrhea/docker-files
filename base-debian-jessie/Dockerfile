# My base image.
FROM debian:jessie

RUN apt-get update && \
    apt-get install -y curl git vim joe && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

CMD ["bash"]