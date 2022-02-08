ARG BASE_VERSION
FROM strapi/base:14

ARG STRAPI_VERSION
RUN yarn global add @strapi/strapi@${STRAPI_VERSION}

RUN mkdir /srv/app && chown 1000:1000 -R /srv/app
RUN node -v
WORKDIR /srv/app

VOLUME /srv/app

COPY server.js /tmp
COPY plugins.js /tmp

COPY docker-entrypoint.sh /usr/local/bin/

RUN ["chmod", "+x", "/usr/local/bin/docker-entrypoint.sh"]

ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["strapi", "develop"]
