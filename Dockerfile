FROM debian:stretch-slim

MAINTAINER Alexey Vakulich <alexey.vakulich@gmail.com>

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        mercurial \
        adduser \
        ca-certificates \
        wget \
        gnupg \
        build-essential \
        lua5.1 \
        liblua5.1-dev \
        libidn11-dev \
        libssl-dev \
        lua-filesystem \
        lua-expat \
        lua-socket \
        lua-sec \
        lua-bitop \
        lua-dbi-sqlite3

RUN echo deb http://packages.prosody.im/debian stretch main | tee -a /etc/apt/sources.list
RUN wget --no-check-certificate \ 
    https://prosody.im/files/prosody-debian-packages.key -O- | apt-key add -

ARG prosody_version=0.11.2
ENV PROSODY_VERSION $prosody_version

RUN wget https://prosody.im/downloads/source/prosody-${PROSODY_VERSION}.tar.gz
RUN tar -xzf prosody-${PROSODY_VERSION}.tar.gz -C /usr/src/
RUN rm prosody-${PROSODY_VERSION}.tar.gz

WORKDIR /usr/src/prosody-$PROSODY_VERSION

RUN ${PWD}/configure --prefix=/usr --sysconfdir=/etc/prosody --datadir=/var/lib/prosody
RUN make && make install

RUN hg clone https://hg.prosody.im/prosody-modules/ /opt/prosody-modules-available/ \
    && mkdir /opt/prosody-modules-enabled

ADD config/prosody.cfg.lua /etc/prosody/prosody.cfg.lua
ADD config/conf.d/ /etc/prosody/conf.d/
ADD config/vhost.d/ /etc/prosody/vhost.d/

RUN useradd -rs /bin/false prosody \
    && mkdir /var/run/prosody/ \
    && chown -R prosody:prosody /etc/prosody/ /var/lib/prosody/ /opt/prosody-modules-* \
    && chmod -R 760 /etc/prosody/ /var/lib/prosody/ /opt/prosody-modules-*

COPY ./entrypoint.sh /entrypoint.sh
RUN chmod 755 /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 80 443 5222 5269 5347 5280 5281
USER prosody:prosody
CMD ["prosody"]