FROM vigour/redis-base:latest
ENV DEBIAN_FRONTEND=noninteractive
##///*******************************************************/
## set redis default to bind to all nic's.
RUN sed -i 's/^\(bind .*\)$/# \1/' /etc/redis/redis.conf
#change ports as needed from 6379 to ...
#RUN sed -i "s/port 6379/port 6380/" /etc/redis/redis.conf
##///*******************************************************/
EXPOSE 6379
VOLUME ["/data"]
ENTRYPOINT ["redis-server", "--dir", "/data"] 

##//////////////////////////////////////////////////////////////////
# build: docker build -t vigour/redis-master .
# run: docker run -v ~/data/redis0:/data -it --detach --name=redis0 vigour/redis-master
# cli: docker run -v ~/data/redis0:/data -it --rm --name=redis0 vigour/redis-master
