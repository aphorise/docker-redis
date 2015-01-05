FROM ubuntu:14.04
ENV DEBIAN_FRONTEND noninteractive
##///*******************************************************/
##//------------------------
## append apt mirror for ubuntu, update & install
##//------------------------
RUN sed -i 's/# \(.*multiverse$\)/\1/g' /etc/apt/sources.list
## do update, upgrade (which may not be needed) & install:
RUN apt-get update -y && apt-get -y upgrade
RUN apt-get install -y debconf build-essential \
software-properties-common python-software-properties \
nano vim git htop wget curl nload unzip
RUN rm -rf /var/lib/apt/lists/*
##//------------------------
## add repo for latest redis & install
##//------------------------
RUN add-apt-repository ppa:chris-lea/redis-server && apt-get update
RUN apt-get install redis-server -y
## set redis default to bind to all nic's.
RUN sed -i 's/^\(bind .*\)$/# \1/' /etc/redis/redis.conf
#change ports as needed from 6379 to ...
#RUN sed -i "s/port 6379/port 6380/" /etc/redis/redis.conf
##///*******************************************************/

##//////////////////////////////////////////////////////////////////
# build: docker build -t vigour/redis-base .
# run: docker run -it --detach --name=redis-base vigour/redis-base
# cli: docker run -it --rm --name=redis-base vigour/redis-base
##// ATTACH to running master / slave instaces
# cli: docker run -it --rm --link=redis0:redis --name=redis-base vigour/redis-base
