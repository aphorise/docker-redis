**Three** **[docker.io](www.docker.io "Docker")** Dockerfile's (_Ubuntu:14.04_) for any Redis setup involving some or all instances of:
#####— standalone (**master**)
#####— replication / mirroring (**slave**)
#####— health checker and switch (**sentinel**)
*
```
       Redis-Sentinel-1
             _/ \_
           _|     |_
          /         \ 
Redis-Master <--> Redis-Slave
          \_       _/
    	    |_   _|
              \ /
       Redis-Sentinel-2
```
## Building & running: Standalone, Master & Slave
#####Build & execution instructions are noted at the bottom of each Dockerfile.
Begin by building the ``redis-base`` image which will be used by all three instances: 
```sh 
you@some-machine:~/redis-dockers$ \
docker build -t vigour/redis-base .
```
Confirm ``redis-base`` is built & runs from prompt (_--rm_ flag to test & remove): 
```sh 
you@some-machine:~/redis-dockers$ \
sudo docker run -it --rm --name=redis-base vigour/redis-base

root@ffaaccee00ff:/# redis-server 
# SHOULD START WITH LOGO & STATUS ... ctrl+c
root@ffaaccee00ff:/# exit
```

Thereafter all other images may be built by repeating the build process within the directory of required images:
```sh 
cd redis-master && docker build -t vigour/redis-master . && cd ..
cd redis-slave  && docker build -t vigour/redis-slave . && cd ..
cd redis-sentinel  && docker build -t vigour/redis-sentinel . && cd ..
```
Each ``redis-slave`` requires linkage with its ralted ``redis-master`` by way of docker **--link** parameter referencing _container:id_  such as:
```sh 
docker run --link=redis0:redis_master -P --detach --name=redis0_slave vigour/redis-slave
```
A temporary redis-base can also be run linked to a master or a slave instance for the purposes of using the redis prompt utility **redis-cli** 
## Sentinel 
Before building the ``redis-sentinel`` edit / Adjust **Dockerfile** to include the **IP** & **PORT** of at least one ``redis-master``:
```sh 
#change conditions & ports as needed from 6379 to ...
RUN echo "port 6380" > /etc/redis/sentinel.conf
RUN echo "sentinel monitor mymaster 127.0.0.1 6379 2" >> /etc/redis/sentinel.conf
RUN echo "sentinel down-after-milliseconds mymaster 60000" >> /etc/redis/sentinel.conf
RUN echo "sentinel failover-timeout mymaster 180000" >> /etc/redis/sentinel.conf
RUN echo "sentinel parallel-syncs mymaster 1" >> /etc/redis/sentinel.conf

```


Running ``redis-sentinel`` must be provided either **_announcment-ip_** & / or **_announcment-port_**. If the default port is not used:
```sh 
docker run -p 26380:26380 vigour/redis-sentinel --sentinel announce-ip 1.2.3.4 --sentinel announce-port 26380
```


------
Due accrediation, for tutorials & other related material referenced:
###### [1- McKernan, J: Redis Master-Slave on Docker](www.hvflabs.com/posts/redis-master-slave-on-docker "blog")]
###### [2- McKernan, J: Redis sentinel docker image / Dockerfile](www.stackoverflow.com/questions/25914814/redis-sentinel-docker-image-dockerfile/ "stackoverlfow")]
