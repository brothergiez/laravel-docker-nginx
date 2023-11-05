# Use a PHP image with your desired version
FROM php:8.2.0-fpm

WORKDIR /var/www/html
RUN mkdir -p /var/run/php-fpm

# Set the owner and permissions
RUN chown -R www-data:www-data /var/run/php-fpm

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    zip \
    unzip \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libzip-dev \
    libmcrypt-dev \
    libmagickwand-dev \
    && pecl install imagick 


# Install PHP extensions
RUN docker-php-ext-enable imagick 
RUN docker-php-ext-configure gd --with-freetype --with-jpeg
RUN docker-php-ext-install gd pdo pdo_mysql zip

# Install Node.js and npm
RUN curl -sL https://deb.nodesource.com/setup_16.x | bash -
RUN apt-get install -y nodejs

# Install Composer globally
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Set the working directory in the container
COPY . .
COPY ./docker-config/pool.conf /usr/local/etc/php-fpm.d/
COPY ./docker-config/custom-php.ini /usr/local/etc/php/conf.d/custom-php.ini

RUN chown -R www-data:www-data /var/www/html
RUN mkdir -p /var/www/.composer/cache
RUN mkdir -p /var/www/.npm
RUN chown -R 33:33 /var/www/.npm
RUN chown -R www-data:www-data /var/www/.composer/cache

USER www-data

RUN chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache
RUN chmod -R 775 /var/www/.composer/cache
COPY .env.example .env

# Copy Laravel application files

# Install PHP dependencies
RUN composer install --working-dir="/var/www/html"

# Install Node.js dependencies
RUN npm install

# Build Vite assets
RUN npm run build

RUN [ "sh", "./docker-config/setup.sh" ]
USER root
# Expose port if necessary
EXPOSE 9000

# Start the PHP-FPM server
CMD ["php-fpm"]
