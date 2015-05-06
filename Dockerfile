FROM ubuntu:12.04

MAINTAINER Fasih<faskiri@gmail.com>

RUN apt-get update --fix-missing
RUN apt-get install -y supervisor openssh-server
RUN mkdir -p /var/run/sshd /etc/supervisor/conf.d/
ADD data/docker.pub /root/.ssh/authorized_keys
RUN chmod 700 /root/.ssh/authorized_keys

RUN apt-get install -y g++ python python-gflags \
  libapr1 libaprutil1 libgeoip1 liblcms2-2
ADD data/Geo*.dat /opt/geoip/

ADD control/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
ADD control/fix-config fix-config
ADD deb/*.deb deb/
RUN dpkg -i deb/*
RUN rm -rf deb
RUN ./fix-config

EXPOSE 22 80 443
CMD ["/usr/bin/supervisord"]
