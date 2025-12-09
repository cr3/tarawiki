FROM mediawiki:1.44.2-fpm-alpine

COPY docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["php-fpm"]
