ARG BASE=kalilinux/kali-rolling
FROM $BASE as build

RUN apt-get update -y && apt-get install -y autoconf automake txt2man gcc make
RUN mkdir -p /srv/src /srv/app
COPY . /srv/src
WORKDIR /srv/src
RUN autoreconf -vfi \
    && ./configure --disable-dependency-tracking \
    && make DESTDIR=/srv/app all \
    && make DESTDIR=/srv/app install

# FROM ubuntu
# 
# COPY --from=build  /srv/app /