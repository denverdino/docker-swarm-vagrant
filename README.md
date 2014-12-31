# About

This project is to similify the setup for [Docker Swarm][1]

And it will enable the flat network among the cluster nodes to similfy the network access.


# Build the Swarm and get the latest build

    ./build.sh

# Generate the token
	
	./swarm create

	680b0b72274e2e8c48bcedc05ce54afd

# Config

Modify the Vagrantfile to change the minion numbers, token

Modify the provision-network.sh to change the --insecure-registry setting if need


# Usage

This application is available in the form of a Docker image that you can run as a container by executing this command:
    
    vagrant up
	vagrant provision    

Run the Swarm manager (please change the token)

	swarm manage  --discovery token://680b0b72274e2e8c48bcedc05ce54afd -H 127.0.0.1:4243 


# Fig template on Docker Swarm

Try the Fig (please get the latest Fig from [https://github.com/denverdino/fig][3])


```
export DOCKER_HOST=127.0.0.1:4243
docker info
fig up -d
fig ps
fig scale web=2
fig ps
docker ps
```



# References
[https://github.com/docker/swarm][1]

[http://blog.remmelt.com/2014/12/07/docker-swarm-setup/][2]

[1]: https://github.com/docker/swarm
[2]: http://blog.remmelt.com/2014/12/07/docker-swarm-setup/
[3]: https://github.com/denverdino/fig
