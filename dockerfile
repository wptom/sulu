FROM php:8.4-fpm

# základní rozšíření + intl + gd + zip + opcache
RUN apt-get update && apt-get install -y \
    libicu-dev \
    libpng-dev \
    libjpeg-dev \
    libzip-dev \
    unzip \
    git \
    && docker-php-ext-configure gd --with-jpeg \
    && docker-php-ext-install intl gd zip pdo_mysql opcache \
    && pecl install redis && docker-php-ext-enable redis

# composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

WORKDIR /var/www/html

# kopírujeme composer soubory nejdřív (cache layer)
COPY composer.json composer.lock ./
RUN composer install --no-scripts --no-autoloader --prefer-dist --no-interaction

# zbytek projektu
COPY . .

# oprávnění (důležité!)
RUN mkdir -p var public/bundles && chown -R www-data:www-data var public/bundles
# finální autoload + assetic (volitelně)
RUN composer dump-autoload --optimize --classmap-authoritative \
    && php -d memory_limit=512M bin/console cache:clear --env=dev

CMD ["php-fpm"]