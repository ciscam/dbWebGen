FROM php:8.2-apache

# Install system dependencies and PHP extensions
RUN apt-get update && apt-get install -y \
        libpq-dev \
        nodejs \
        npm \
    && docker-php-ext-install pdo pdo_pgsql pdo_mysql mbstring \
    && rm -rf /var/lib/apt/lists/*

# Copy engine source
COPY . /var/www/html/engine/

# Move the app directory out of the engine tree to its own location
RUN mv /var/www/html/engine/app /var/www/html/app

# Install JavaScript dependencies
RUN cd /var/www/html/engine && npm install --omit=dev

# Configure Apache virtual host
COPY docker/apache.conf /etc/apache2/sites-available/000-default.conf
RUN a2enmod rewrite

# Fix ownership
RUN chown -R www-data:www-data /var/www/html

EXPOSE 80
