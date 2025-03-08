# Base PHP image
FROM php:8.2-fpm-alpine AS base

# Set working directory
WORKDIR /www/wwwroot/laravel-docker-setup/projects/voting

# Install dependencies and PHP extensions required for Laravel
RUN apk add --no-cache \
    # Dependencies for PHP extensions
    postgresql-dev \
    libpng-dev \
    libzip-dev \
    zip \
    unzip \
    git \
    curl \
    libxml2-dev \
    oniguruma-dev \
    # For better security
    shadow \
    # Additional dependencies for Imagick (optional)
    autoconf \
    g++ \
    make \
    libjpeg-turbo-dev \
    freetype-dev \
    # For PDF processing
    libpq \
    icu-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) \
    pdo \
    pdo_pgsql \
    pgsql \
    gd \
    zip \
    bcmath \
    opcache \
    intl \
    pcntl \
    exif \
    xml \
    mbstring \
    # Install Redis extension
    && pecl install redis \
    && docker-php-ext-enable redis \
    # Clean up
    && rm -rf /tmp/pear

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Add user for application (better security)
RUN addgroup -g 1000 laravel && adduser -G laravel -g laravel -s /bin/sh -D -u 1000 laravel

# Copy base configurations for both dev and prod
COPY php.ini-production /usr/local/etc/php/php.ini-production
COPY php.ini-development /usr/local/etc/php/php.ini-development

# Development stage
FROM base AS development

# Use development configuration
RUN cp /usr/local/etc/php/php.ini-development /usr/local/etc/php/php.ini

# Install xdebug for development
RUN apk add --no-cache $PHPIZE_DEPS linux-headers \
    && pecl install xdebug \
    && docker-php-ext-enable xdebug \
    && echo "xdebug.mode=debug,develop,coverage" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.start_with_request=yes" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.client_host=host.docker.internal" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.log=/tmp/xdebug.log" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini

# Production stage
FROM base AS production

# Use production configuration
RUN cp /usr/local/etc/php/php.ini-production /usr/local/etc/php/php.ini

# Configure opcache for production
RUN { \
    echo 'opcache.memory_consumption=128'; \
    echo 'opcache.interned_strings_buffer=8'; \
    echo 'opcache.max_accelerated_files=4000'; \
    echo 'opcache.revalidate_freq=2'; \
    echo 'opcache.fast_shutdown=1'; \
    echo 'opcache.enable_cli=1'; \
    echo 'opcache.jit=1255'; \
    echo 'opcache.jit_buffer_size=256M'; \
    } > /usr/local/etc/php/conf.d/opcache-recommended.ini

# Note: We don't copy or modify files as they'll be mounted at runtime

# Set up entrypoint script
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint
RUN chmod +x /usr/local/bin/docker-entrypoint

# Default environment is production, override with --target in docker-compose
ENV APP_ENV=production

ENTRYPOINT ["docker-entrypoint"]
CMD ["php-fpm"]
