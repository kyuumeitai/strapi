# Strapi on docker setup

This is my solution on the following issue: https://github.com/strapi/strapi-docker/issues/329

The interesting part is on the `docker-entrypoint.sh` file. There you can see that I remove the nodejs and install it again with my version.

Hope this helps someone. It's far from being an optimal solution, but works for me.

![it ain't much](https://i.kym-cdn.com/entries/icons/original/000/028/021/work.jpg)
