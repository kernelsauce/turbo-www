FROM ubuntu
MAINTAINER John Abrahamsen
RUN apt-get update
RUN apt-get install -y luajit luarocks git build-essential libssl-dev git
RUN luarocks install turbo
RUN mkdir -p /var/www
RUN git clone https://github.com/kernelsauce/turbo-www.git /var/www/turbo-www
WORKDIR /var/www/turbo-www/
ENV turbo-www-port 8833
CMD ["/usr/bin/luajit", "official-turbo-site.lua"]
EXPOSE 8833