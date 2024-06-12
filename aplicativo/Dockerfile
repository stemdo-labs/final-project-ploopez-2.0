FROM php:7.4-apache
RUN docker-php-ext-install pdo_mysql
RUN a2enmod rewrite
COPY . /var/www/html/
WORKDIR /var/www/html
EXPOSE 80
# RUN chmod -R www-data:www-data /var/www/html
HEALTHCHECK --interval=30s --timeout=5s CMD curl -f http://localhost:80/ || exit 1