# About

This project is to similify the setup for [Docker Swarm][1]

And it will enable the flat network among the cluster nodes to similfy the network access.


# Build the Swarm and get the latest Docker build

The following command will build the swarm binary with the patch for supporting the cross-host container linking from [https://github.com/denverdino/swarm][4]. And it will retrieve the latest Docker binary build. 

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

	./swarm manage  --discovery token://680b0b72274e2e8c48bcedc05ce54afd -H 127.0.0.1:4243 


# Play with it

```
export DOCKER_HOST=127.0.0.1:4243
docker info
docker run -d dockerfile/nginx
```


# Fig template on Docker Swarm

Try the Fig (please get the latest Fig from [https://github.com/denverdino/fig][3]

We leverage the pattern from the [http://www.fig.sh/wordpress.html](http://www.fig.sh/wordpress.html) for the testing. The web container access the db container through link. 
NOTE: So far, we cannot support the Fig template with build command, and we need to build the image in Fig template firstly and push it to DockerHub or private docker registry. 

```
web:
  image: jadetest.cn.ibm.com:5000/fig_test/wordpress
  ports:
    - "8000:8000"
  links:
    - db
db:
  image: jadetest.cn.ibm.com:5000/orchardup/mysql
  environment:
    MYSQL_DATABASE: wordpress
```

Then we can use the commond fig command to deploy it into Docker Swarm cluster

```
yili@jadetest:~/wordpress$ fig up -d
Creating wordpress_db_1...
Creating wordpress_web_1...
yili@jadetest:~/wordpress$ fig ps
     Name                    Command               State             Ports           
------------------------------------------------------------------------------------
wordpress_db_1    /usr/local/bin/run               Up      3306/tcp                  
wordpress_web_1   /bin/sh -c php -S 0.0.0.0: ...   Up      10.246.2.3:8000->8000/tcp 
yili@jadetest:~/wordpress$ docker ps
CONTAINER ID        IMAGE                                                COMMAND                CREATED             STATUS                  PORTS                       NAMES
920087b75a6b        jadetest.cn.ibm.com:5000/fig_test/wordpress:latest   "/bin/sh -c 'php -S    11 seconds ago      Up Less than a second   10.246.2.3:8000->8000/tcp   swarm-minion-2/wordpress_web_1   
8966ac5ee014        jadetest.cn.ibm.com:5000/orchardup/mysql:latest      "/usr/local/bin/run"   34 seconds ago      Up 10 seconds           3306/tcp                    swarm-minion-2/wordpress_db_1    
yili@jadetest:~/wordpress$ fig scale web=2
Starting wordpress_web_2...
yili@jadetest:~/wordpress$ docker ps
CONTAINER ID        IMAGE                                                     COMMAND                CREATED              STATUS              PORTS                       NAMES
85fc2796a48d        jadetest.cn.ibm.com:5000/svendowideit/ambassador:latest   "\"/bin/sh -c 'env |   49 seconds ago       Up 30 seconds       3306/tcp                    swarm-minion-1/wordpress_web_2/db,swarm-minion-1/wordpress_web_2/db_1,swarm-minion-1/wordpress_web_2/wordpress_db_1,swarm-minion-1/wordpress_web_2_ambassador_wordpress_db_1   
f536fb5b2c45        jadetest.cn.ibm.com:5000/fig_test/wordpress:latest        "/bin/sh -c 'php -S    52 seconds ago       Up 30 seconds       10.246.2.2:8000->8000/tcp   swarm-minion-1/wordpress_web_2                                                                                                                                                 
920087b75a6b        jadetest.cn.ibm.com:5000/fig_test/wordpress:latest        "/bin/sh -c 'php -S    About a minute ago   Up About a minute   10.246.2.3:8000->8000/tcp   swarm-minion-2/wordpress_web_1                                                                                                                                                 
8966ac5ee014        jadetest.cn.ibm.com:5000/orchardup/mysql:latest           "/usr/local/bin/run"   About a minute ago   Up About a minute   3306/tcp                    swarm-minion-2/wordpress_db_1,swarm-minion-2/wordpress_web_1/db,swarm-minion-2/wordpress_web_1/db_1,swarm-minion-2/wordpress_web_1/wordpress_db_1
```

And you can access the two different public endpoints for Wordpress deployment, and both of them will link to the same MySQL database container.

```
http://10.246.2.2:8000/wordpress
http://10.246.2.3:8000/wordpress
```

Enjoy!

# References
[https://github.com/docker/swarm][1]

[http://blog.remmelt.com/2014/12/07/docker-swarm-setup/][2]

[1]: https://github.com/docker/swarm
[2]: http://blog.remmelt.com/2014/12/07/docker-swarm-setup/
[3]: https://github.com/denverdino/fig
[4]: https://github.com/denverdino/swarm
