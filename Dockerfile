FROM golang:1.4

MAINTAINER Li Yi<denverdino@gmail.com>

RUN git config --global user.email "denverdino@gmail.com" && git config --global user.name "Li Yi"
RUN go get github.com/samalba/dockerclient && cd /go/src/github.com/samalba/dockerclient  && git remote add fork https://github.com/denverdino/dockerclient.git && git pull fork master -q
RUN go get github.com/docker/swarm && cd /go/src/github.com/docker && rm -fr swarm && git clone https://github.com/denverdino/swarm.git && cd /go/src/github.com/docker/docker && sh project/make/.go-autogen && cd swarm && go build && go install
