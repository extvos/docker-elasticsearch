FROM extvos/java:7
MAINTAINER "Mingcai SHEN <archsh@gmail.com>"
ENV ELASTICSEARCH_VERSION 1.7.0

# download and extract 
RUN cd /opt \
	&& wget https://download.elastic.co/elasticsearch/elasticsearch/elasticsearch-${ELASTICSEARCH_VERSION}.tar.gz \
	&& tar zxvf elasticsearch-${ELASTICSEARCH_VERSION}.tar.gz \
	&& ln -s /opt/elasticsearch-${ELASTICSEARCH_VERSION} /opt/elasticsearch \
	&& groupadd -r elasticsearch && useradd -r -g elasticsearch elasticsearch


COPY docker-entrypoint.sh /

RUN yum install -y ca-certificates \
	&& wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/1.2/gosu-amd64" \
	&& chmod +x /usr/local/bin/gosu \
	&& chmod +x /docker-entrypoint.sh
	

COPY config /opt/elasticsearch/config

ENV PATH /opt/elasticsearch/bin:$PATH

VOLUME /opt/elasticsearch/data

VOLUME /opt/elasticsearch/config

ENTRYPOINT ["/docker-entrypoint.sh"]

EXPOSE 9200 9300

CMD ["elasticsearch"]