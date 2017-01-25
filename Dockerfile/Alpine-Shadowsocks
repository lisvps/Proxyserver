FROM alpine

#version:1.1

MAINTAINER Shuanglong Li "lis8920@gmail.com"

#Change time Zone
ENV TZ 'Asia/Shanghai'

#Install Shadowsocks Server
RUN apk update \
&& apk add --no-cache bash tzdata \
&& ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
&& echo "Asia/Shanghai" > /etc/timezone \
&& apk add py2-pip \
&& pip install shadowsocks \
&& ln -sf /dev/stdout /var/log/shadowsocks.log

#Configure container to run as an executable
ENTRYPOINT ["/usr/bin/ssserver"]
