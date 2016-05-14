FROM php:5.6-apache

RUN { \
    echo 'opcache.memory_consumption=128'; \
    echo 'opcache.interned_strings_buffer=8'; \
    echo 'opcache.max_accelerated_files=4000'; \
    echo 'opcache.revalidate_freq=60'; \
    echo 'opcache.fast_shutdown=1'; \
    echo 'opcache.enable_cli=1'; \
  } > /usr/local/etc/php/conf.d/opcache-recommended.ini

ENV VERSION 2015-08-10a
ENV MD5_CHECKSUM a4b8ae00ce94e42d4ef52dd8f4ad30fe

WORKDIR /var/www/html

RUN curl -fsSL -o dokuwiki.tar.gz "http://download.dokuwiki.org/src/dokuwiki/dokuwiki-$VERSION.tgz" \
  && echo "$MD5_CHECKSUM  dokuwiki.tar.gz" | md5sum -c - \
  && tar xzf "dokuwiki.tar.gz" --strip 1 \
  && rm dokuwiki.tar.gz

VOLUME ["/var/www/html/data", "/var/www/html/conf", "/var/www/html/lib/plugins", "/var/www/html/lib/tpl"]

COPY .htaccess /var/www/html/.htaccess
RUN a2enmod rewrite

COPY docker-entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["apache2-foreground"]