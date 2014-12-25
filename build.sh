docker build -t pure/swarm .
docker run --rm -v `pwd`:/target pure/swarm cp /go/bin/swarm /target
wget https://get.docker.com/builds/Linux/x86_64/docker-latest -O docker
chmod +x docker

