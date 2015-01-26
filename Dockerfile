FROM golang:1.3.3

MAINTAINER Yi Li <denverdino@gmail.com>

RUN git config --global user.email "denverdino@gmail.com" && git config --global user.name "Li Yi"
RUN go get github.com/samalba/dockerclient && cd /go/src/github.com/samalba/dockerclient  && git remote add fork https://github.com/denverdino/dockerclient.git && git pull fork master -q
RUN go get github.com/docker/swarm && cd /go/src/github.com/docker/swarm && git remote add fork https://github.com/denverdino/swarm.git && git pull fork master -q && go build && go install
