FROM ruby:2.5.1-alpine3.7

# Minimal requirements to run a Rails app
RUN apk add --no-cache --update build-base \
                                linux-headers \
                                tzdata \
                                bash \
                                mysql-dev

# Different layer for gems installation
RUN mkdir /rpg_master_api
WORKDIR /rpg_master_api

EXPOSE 3000

COPY docker-entrypoint.sh /rpg_master_api/docker-entrypoint.sh
RUN chmod a+x /rpg_master_api/docker-entrypoint.sh
ENTRYPOINT ["/rpg_master_api/docker-entrypoint.sh"]
