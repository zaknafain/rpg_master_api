FROM ruby:2.6.0-alpine3.7

# Minimal requirements to run a Rails app
RUN apk add --no-cache --update build-base \
                                linux-headers \
                                tzdata \
                                mysql-dev

# Added some more for CCI 2.0
RUN apk add --no-cache --update git openssh-client
ENV DOCKERIZE_VERSION v0.6.0
RUN wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && tar -C /usr/local/bin -xzvf dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && rm dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz

WORKDIR /rpg-master-api

ENV BUNDLE_PATH=/bundle/ruby-${RUBY_VERSION} \
    BUNDLE_BIN=/bundle/ruby-${RUBY_VERSION}/bin \
    GEM_HOME=/bundle/ruby-${RUBY_VERSION} \
    BUNDLE_CACHE_PATH=/bundle/ruby-${RUBY_VERSION}/cache
ENV PATH="${BUNDLE_BIN}:${PATH}"

EXPOSE 3000

COPY docker-entrypoint.sh /rpg-master-api/docker-entrypoint.sh
RUN chmod a+x /rpg-master-api/docker-entrypoint.sh
ENTRYPOINT ["/rpg-master-api/docker-entrypoint.sh"]
