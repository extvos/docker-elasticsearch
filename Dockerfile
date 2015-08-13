FROM extvos/java:7
MAINTAINER "Mingcai SHEN <archsh@gmail.com>"

ENV ELASTICSEARCH_VERSION 1.7.0

# download and extract 
ADD https://download.elastic.co/elasticsearch/elasticsearch/elasticsearch-${ELASTICSEARCH_VERSION}.tar.gz /opt/

COPY docker-entrypoint.sh /

RUN yum install -y ca-certificates \
	&& wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/1.2/gosu-amd64" \
	&& chmod +x /usr/local/bin/gosu 

RUN ln -s /opt/elasticsearch-${ELASTICSEARCH_VERSION} /opt/elasticsearch \
	&& chmod +x /docker-entrypoint.sh \
	&& groupadd -r elasticsearch && useradd -r -g elasticsearch elasticsearch

COPY config /opt/elasticsearch/config

ENV PATH /opt/elasticsearch/bin:$PATH

VOLUME /opt/elasticsearch/data

ENTRYPOINT ["/docker-entrypoint.sh"]

EXPOSE 9200 9300

CMD ["elasticsearch"]