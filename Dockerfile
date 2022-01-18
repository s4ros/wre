FROM php:7.4-fpm

ARG UID=1000
ARG GID=1000
ARG USER=wre
ARG GROUP=wre
# Create non-root User and Group
RUN groupadd --gid ${GID} ${GROUP}
RUN useradd -m \
    --home-dir /home/${USER} \
    --shell /bin/bash \
    --uid ${UID} \
    --gid ${GID} \
    ${USER}

# Install additional packages
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y \
    apt-utils \
    less \
    libjpeg-dev \
    libpng-dev \
    libzip-dev \
    net-tools \
    netcat-openbsd \
    procps \
    sendmail \
    sudo \
    vim \
    zlib1g-dev \
    libmagickwand-dev --no-install-recommends \
    && rm -rf /var/lib/apt/lists/*

RUN printf "\n" | pecl install imagick
RUN docker-php-ext-install -j$(nproc) mysqli pdo_mysql exif gd zip
RUN docker-php-ext-enable imagick

# Use the default production configuration
# RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"
COPY php.conf/php.ini /usr/local/etc/php/php.ini
COPY php.conf/php-fpm.conf /usr/local/etc/php-fpm.conf
COPY php.conf/php-fpm.d/ /usr/local/etc/php/php-fpm.d/

# Add `wp-cli`
RUN curl -o /usr/local/bin/wp-cli https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
COPY wp-cli/wp /usr/local/bin/wp
RUN chmod +x /usr/local/bin/wp-cli /usr/local/bin/wp
WORKDIR /home/${USER}
USER 1000
