FROM ruby:2.5.1-alpine3.7

# Minimal requirements to run a Rails app
RUN apk add --no-cache --update build-base \
                                linux-headers \
                                tzdata \
                                bash \
                                mysql-dev \
                                git

# Added dockerize for circleci 2.0 command to wait for DB to be up
ENV DOCKERIZE_VERSION v0.6.0
RUN wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && tar -C /usr/local/bin -xzvf dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && rm dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz

RUN mkdir /rpg_master_api
WORKDIR /rpg_master_api

EXPOSE 3000

COPY docker-entrypoint.sh /rpg_master_api/docker-entrypoint.sh
RUN chmod a+x /rpg_master_api/docker-entrypoint.sh
ENTRYPOINT ["/rpg_master_api/docker-entrypoint.sh"]
