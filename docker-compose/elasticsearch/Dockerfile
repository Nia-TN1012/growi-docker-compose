FROM openjdk:8-jdk-slim-stretch

RUN groupadd -r elasticsearch && useradd -r -g elasticsearch elasticsearch

WORKDIR /usr/share/elasticsearch
ENV PATH /usr/share/elasticsearch/bin:$PATH
ENV ELASTICSEARCH_VERSION 6.6.2

RUN apt-get update -y \
    && apt-get install --no-install-recommends -y wget \
    && wget -q https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-${ELASTICSEARCH_VERSION}.deb \
    && dpkg -i elasticsearch-${ELASTICSEARCH_VERSION}.deb \
    && rm elasticsearch-${ELASTICSEARCH_VERSION}.deb
    
WORKDIR /usr/share/elasticsearch

RUN mkdir -p ./plugins \
    && for path in \
		./data \
		./logs \
		./config \
		./config/scripts \
	; do \
		mkdir -p "$path"; \
		chown -R elasticsearch:elasticsearch "$path"; \
	done \
    && export ES_JAVA_OPTS='-Xms32m -Xmx32m' && elasticsearch --version \
    && elasticsearch-plugin install analysis-kuromoji \
    && elasticsearch-plugin install analysis-icu

COPY config ./config

VOLUME /usr/share/elasticsearch/data

COPY docker-entrypoint.sh /opt/docker-entrypoint.sh
RUN chown elasticsearch:elasticsearch /opt/docker-entrypoint.sh \
    && chmod +x /opt/docker-entrypoint.sh

ENTRYPOINT ["/opt/docker-entrypoint.sh"]
CMD ["elasticsearch"]

USER elasticsearch

EXPOSE 9200 9300