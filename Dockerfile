FROM python:3.5-alpine
MAINTAINER Jan Guth <https://github.com/fentas>

##
## GENERAL SETTINGS
##

ENV CROXY_PORT 5566

ENV ROTATOR_ENABLED 1
ENV ROTATOR_CHECK_URL "https://www.google.com"
ENV ROTATOR_CHECK_FOR initHistory
ENV ROTATOR_PROXY_TIMEOUT 10.0
ENV ROTATOR_PROXY_FILE "/data/rotator/proxies"
ENV ROTATOR_GET_PROXY_ENABLED 1
ENV ROTATOR_GET_PROXY_SERVICE "http://gimmeproxy.com/api/getProxy?get=true&protocol=http&supportsHttps=true"

ENV THROTTLE_ENABLED 1
ENV THROTTLE_MIN 1
ENV THROTTLE_MAX 2000
ENV THROTTLE_INCREASE_PER_CONNECTION 10

##
## HA PROXY - see https://github.com/docker-library/haproxy/blob/24fd0637e58d931e99ae6717b3e13bb389985fa1/1.6/alpine/Dockerfile
##

# enable|disable
ENV HAPROXY_STATS "enable"
ENV HAPROXY_STATS_PORT 1936
ENV HAPROXY_STATS_AUTH "someuser:password"
ENV HAPROXY_STATS_URI "/"
ENV HAPROXY_MAJOR 1.6
ENV HAPROXY_VERSION 1.6.9
ENV HAPROXY_MD5 c52eee40eb66f290d6f089c339b9d2b3

##
## CONFIGURATION
##

#TODO: add our user and group first to make sure their IDs get assigned consistently, regardless of whatever dependencies get added
#RUN groupadd --system croxy && useradd --system --create-home --gid croxy croxy
#ENV HOME "/home/croxy"
#..https://github.com/tianon/gosu

COPY scripts /scripts
COPY data /data
VOLUME /data

# see http://sources.debian.net/src/haproxy/1.5.8-1/debian/rules/ for some helpful navigation of the possible "make" arguments
RUN set -x \
	&& apk add --no-cache --virtual .build-deps \
		curl \
		gcc \
		libc-dev \
		linux-headers \
		make \
		openssl-dev \
		pcre-dev \
		zlib-dev \
		iptables \
    zlib \
	&& curl -SL "http://www.haproxy.org/download/${HAPROXY_MAJOR}/src/haproxy-${HAPROXY_VERSION}.tar.gz" -o haproxy.tar.gz \
	&& echo "${HAPROXY_MD5}  haproxy.tar.gz" | md5sum -c \
	&& mkdir -p /usr/src \
	&& tar -xzf haproxy.tar.gz -C /usr/src \
	&& mv "/usr/src/haproxy-$HAPROXY_VERSION" /usr/src/haproxy \
	&& rm haproxy.tar.gz \
	&& make -C /usr/src/haproxy \
		TARGET=linux2628 \
		USE_PCRE=1 PCREDIR= \
		USE_OPENSSL=1 \
		USE_ZLIB=1 \
		all \
		install-bin \
	&& mkdir -p /usr/local/etc/haproxy \
  && mkdir -p /run/haproxy \
	&& cp -R /usr/src/haproxy/examples/errorfiles /usr/local/etc/haproxy/errors \
	&& rm -rf /usr/src/haproxy \
	&& runDeps="$( \
		scanelf --needed --nobanner --recursive /usr/local \
			| awk '{ gsub(/,/, "\nso:", $2); print "so:" $2 }' \
			| sort -u \
			| xargs -r apk info --installed \
			| sort -u \
	)" \
	&& apk add --virtual .haproxy-rundeps $runDeps \
	&& apk del .build-deps
  && rm -rf ~/.cache

RUN (( $ROTATOR_ENABLED )) && \
  pip install -r /scripts/rotator/requirements

COPY docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]

EXPOSE $HAPROXY_PORT
