ARG FROM_TAG

FROM anaxexp/base-php:${FROM_TAG}

ARG PHP_DEV
ARG PHP_DEBUG

ARG ANAXEXP_USER_ID=1000
ARG ANAXEXP_GROUP_ID=1000

ENV PHP_DEV="${PHP_DEV}" \
    PHP_DEBUG="${PHP_DEBUG}" \
    SSHD_PERMIT_USER_ENV="yes" \
    PHP_PRESTISSIMO_VER="0.3" \
    WALTER_VER="1.3.0" \
    \
    EXT_AMQP_VER="1.9.3" \
    EXT_APCU_VER="4.0.11" \
    EXT_GEOIP_VER="1.1.1" \
    EXT_GRPC_VER="1.8.5" \
    EXT_IGBINARY_VER="2.0.5" \
    EXT_IMAGICK_VER="3.4.3" \
    EXT_MEMCACHED_VER="2.2.0" \
    EXT_MONGODB_VER="1.4.0" \
    EXT_OAUTH_VER="1.2.3" \
    EXT_RDKAFKA_VER="3.0.5" \
    EXT_REDIS_VER="3.1.6" \
    EXT_UPLOADPROGRESS_VER="1.0.3.1" \
    EXT_XDEBUG_VER="2.5.5" \
    EXT_YAML_VER="1.3.1" \
    \
    C_CLIENT_VER="2007f-r7" \
    FREETYPE_VER="2.8.1-r3" \
    GEOIP_VER="1.6.11-r0" \
    ICU_LIBS_VER="59.1-r1" \
    IMAGEMAGICK_VER="7.0.7.11-r1" \
    JPEGOPTIM_VER="1.4.4-r0" \
    LIBBZ2_VER="1.0.6-r6" \
    LIBJPEG_TURBO_VER="1.5.2-r0" \
    LIBLDAP_VER="2.4.45-r3" \
    LIBLTDL_VER="2.4.6-r4" \
    LIBMCRYPT_VER="2.5.8-r7" \
    LIBMEMCACHED_LIBS_VER="1.0.18-r2" \
    LIBPNG_VER="1.6.34-r1" \
    LIBRDKAFKA_VER="0.11.1-r1" \
    LIBXSLT_VER="1.1.31-r0" \
    MARIADB_CLIENT_VER="10.1.32-r0" \
    POSTGRESQL_CLIENT_VER="10.5-r0" \
    RABBITMQ_C_VER="0.8.0-r3" \
    TIDYHTML_VER="5.4.0-r0" \
    YAML_VER="0.1.7-r0" \
    \
    LD_PRELOAD="/usr/lib/preloadable_libiconv.so php"

ENV APP_ROOT="/var/www/html" \
    CONF_DIR="/var/www/conf" \
    FILES_DIR="/mnt/files"

ENV PATH="${PATH}:/home/anaxexp/.composer/vendor/bin:${APP_ROOT}/vendor/bin" \
    SSHD_HOST_KEYS_DIR="/etc/ssh" \
    ENV="/home/anaxexp/.shrc" \
    \
    GIT_USER_EMAIL="anaxexp@example.com" \
    GIT_USER_NAME="anaxexp"

RUN set -xe; \
    \
    # Delete existing user/group if uid/gid occupied.
    existing_group=$(getent group "${ANAXEXP_GROUP_ID}" | cut -d: -f1); \
    if [[ -n "${existing_group}" ]]; then delgroup "${existing_group}"; fi; \
    existing_user=$(getent passwd "${ANAXEXP_USER_ID}" | cut -d: -f1); \
    if [[ -n "${existing_user}" ]]; then deluser "${existing_user}"; fi; \
    \
	addgroup -g "${ANAXEXP_GROUP_ID}" -S anaxexp; \
	adduser -u "${ANAXEXP_USER_ID}" -D -S -s /bin/bash -G anaxexp anaxexp; \
    adduser anaxexp www-data; \
	sed -i '/^anaxexp/s/!/*/' /etc/shadow; \
    \
    apk add --update --no-cache -t .php-rundeps \
        "c-client=${C_CLIENT_VER}" \
        fcgi \
        findutils \
        "freetype=${FREETYPE_VER}" \
        "geoip=${GEOIP_VER}" \
        git \
        "icu-libs=${ICU_LIBS_VER}" \
        "imagemagick=${IMAGEMAGICK_VER}" \
        "jpegoptim=${JPEGOPTIM_VER}" \
        less \
        "libbz2=${LIBBZ2_VER}" \
        "libjpeg-turbo=${LIBJPEG_TURBO_VER}" \
        "libjpeg-turbo-utils=${LIBJPEG_TURBO_VER}" \
        "libldap=${LIBLDAP_VER}" \
        "libltdl=${LIBLTDL_VER}" \
        "libmemcached-libs=${LIBMEMCACHED_LIBS_VER}" \
        "libmcrypt=${LIBMCRYPT_VER}" \
        "libpng=${LIBPNG_VER}" \
        "librdkafka=${LIBRDKAFKA_VER}" \
        "libxslt=${LIBXSLT_VER}" \
        make \
        "mariadb-client=${MARIADB_CLIENT_VER}" \
        nano \
        openssh \
        openssh-client \
        patch \
        "postgresql-client=${POSTGRESQL_CLIENT_VER}" \
        "rabbitmq-c=${RABBITMQ_C_VER}" \
        rsync \
        su-exec \
        sudo \
        "tidyhtml-libs=${TIDYHTML_VER}" \
        tig \
        tmux \
        "yaml=${YAML_VER}"; \
    \
    apk add --update --no-cache -t .build-deps \
        autoconf \
        cmake \
        build-base \
        bzip2-dev \
        freetype-dev \
        geoip-dev \
        gmp-dev \
        icu-dev \
        imagemagick-dev \
        imap-dev \
        jpeg-dev \
        libjpeg-turbo-dev \
        libmemcached-dev \
        libmcrypt-dev \
        libpng-dev \
        librdkafka-dev \
        libtool \
        libxslt-dev \
        openldap-dev \
        pcre-dev \
        postgresql-dev \
        rabbitmq-c-dev \
        tidyhtml-dev \
        yaml-dev; \
    \
    apk add -U -X http://dl-cdn.alpinelinux.org/alpine/edge/testing/ --allow-untrusted gnu-libiconv; \
    \
    # Install redis-cli.
    apk add --update --no-cache redis; \
    mkdir -p /tmp/pkgs-bins; \
    mv /usr/bin/redis-cli /tmp/; \
    apk del --purge redis; \
    deluser redis; \
    mv /tmp/redis-cli /usr/bin; \
    \
    docker-php-source extract; \
    \
    # Fix for tidy extension.
    cd /usr/src/php; \
    sed -i 's/buffio.h/tidybuffio.h/' ext/tidy/*.c; \
    \
    docker-php-ext-install \
        bcmath \
        bz2 \
        calendar \
        exif \
        gmp \
        imap \
        intl \
        ldap \
        mcrypt \
        mysql \
        mysqli \
        opcache \
        pcntl \
        pdo_mysql \
        pdo_pgsql \
        pgsql \
        soap \
        sockets \
        tidy \
        xmlrpc \
        xsl \
        zip; \
    \
    # GD
    docker-php-ext-configure gd \
        --with-gd \
        --with-freetype-dir=/usr/include/ \
        --with-png-dir=/usr/include/ \
        --with-jpeg-dir=/usr/include/; \
      NPROC=$(getconf _NPROCESSORS_ONLN); \
      docker-php-ext-install -j${NPROC} gd; \
    \
    # PECL extensions
    pecl config-set php_ini "${PHP_INI_DIR}/php.ini"; \
    \
    # NewRelic extension and agent.
    newrelic_url="http://download.newrelic.com/php_agent/release/"; \
    wget -r -nd --no-parent -P /tmp/newrelic -Alinux-musl.tar.gz "${newrelic_url}" >/dev/null 2>&1; \
    tar -xzf /tmp/newrelic/newrelic-php*.tar.gz --strip=1 -C /tmp/newrelic; \
    export NR_INSTALL_SILENT=true; \
    export NR_INSTALL_USE_CP_NOT_LN=true; \
    bash /tmp/newrelic/newrelic-install install; \
    rm /usr/local/etc/php/conf.d/newrelic.ini; \
    mkdir -p /var/log/newrelic/; \
    chown -R www-data:www-data /var/log/newrelic/; \
    chmod -R 775 /var/log/newrelic/; \
    \
    pecl install \
        "amqp-${EXT_AMQP_VER}" \
        "apcu-${EXT_APCU_VER}" \
        "geoip-${EXT_GEOIP_VER}" \
        "grpc-${EXT_GRPC_VER}" \
        "igbinary-${EXT_IGBINARY_VER}" \
        "imagick-${EXT_IMAGICK_VER}" \
        "memcached-${EXT_MEMCACHED_VER}" \
        "mongodb-${EXT_MONGODB_VER}" \
        "oauth-${EXT_OAUTH_VER}" \
        "redis-${EXT_REDIS_VER}" \
        "rdkafka-${EXT_RDKAFKA_VER}" \
        "uploadprogress-${EXT_UPLOADPROGRESS_VER}" \
        "xdebug-${EXT_XDEBUG_VER}" \
        "yaml-${EXT_YAML_VER}"; \
    \
    docker-php-ext-enable \
        amqp \
        apcu \
        igbinary \
        imagick \
        geoip \
        grpc \
        memcached \
        mongodb \
        oauth \
        redis \
        rdkafka \
        uploadprogress \
        xdebug \
        yaml; \
    \
    # Blackfire extension
    mkdir -p /tmp/blackfire; \
    version=$(php -r "echo PHP_MAJOR_VERSION.PHP_MINOR_VERSION;"); \
    blackfire_url="https://blackfire.io/api/v1/releases/probe/php/alpine/amd64/${version}"; \
    wget -qO- "${blackfire_url}" | tar xz --no-same-owner -C /tmp/blackfire; \
    mv /tmp/blackfire/blackfire-*.so $(php -r "echo ini_get('extension_dir');")/blackfire.so; \
    \
    # Install composer
    wget -qO- https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer; \
    \
    # Install composer parallel install plugin
    su-exec anaxexp composer global require "hirak/prestissimo:^${PHP_PRESTISSIMO_VER}"; \
    \
    # Install Walter
    walter_url="https://github.com/walter-cd/walter/releases/download/v${WALTER_VER}/walter_${WALTER_VER}_linux_amd64.tar.gz"; \
    wget -qO- "${walter_url}" | tar xz -C /tmp/; \
    mv /tmp/walter_linux_amd64/walter /usr/local/bin; \
    \
    { \
        echo 'export PS1="\u@${ANAXEXP_APP_NAME:-php}.${ANAXEXP_ENVIRONMENT_NAME:-container}:\w $ "'; \
        # Make sure PATH is the same for ssh sessions.
        echo "export PATH=${PATH}"; \
    } | tee /home/anaxexp/.shrc; \
    \
    # Make sure bash uses the same settings as ash.
    cp /home/anaxexp/.shrc /home/anaxexp/.bashrc; \
    cp /home/anaxexp/.shrc /home/anaxexp/.bash_profile; \
    \
    # Configure sudoers
    { \
        echo 'Defaults env_keep += "APP_ROOT FILES_DIR"' ; \
        \
        if [[ -n "${PHP_DEV}" ]]; then \
            echo 'anaxexp ALL=(root) NOPASSWD:SETENV:ALL'; \
        else \
            echo -n 'anaxexp ALL=(root) NOPASSWD:SETENV: ' ; \
            echo -n '/usr/local/bin/files_chmod, ' ; \
            echo -n '/usr/local/bin/files_chown, ' ; \
            echo -n '/usr/local/bin/files_sync, ' ; \
            echo -n '/usr/local/bin/gen_ssh_keys, ' ; \
            echo -n '/usr/local/bin/init_container, ' ; \
            echo -n '/usr/local/bin/migrate, ' ; \
            echo -n '/usr/local/sbin/php-fpm, ' ; \
            echo -n '/usr/sbin/sshd, ' ; \
            echo '/usr/sbin/crond' ; \
        fi; \
    } | tee /etc/sudoers.d/anaxexp; \
    \
    # Configure ldap
    echo "TLS_CACERTDIR /etc/ssl/certs/" >> /etc/openldap/ldap.conf; \
    \
    # Create required directories and fix permissions
    mkdir -p \
        "${APP_ROOT}" \
        "${CONF_DIR}" \
        "${FILES_DIR}/public" \
        "${FILES_DIR}/private" \
        "${FILES_DIR}/xdebug/traces" \
        "${FILES_DIR}/xdebug/profiler" \
        /home/anaxexp/.ssh \
        /home/www-data/.ssh; \
    \
    chmod -R 775 "${FILES_DIR}"; \
    chown -R www-data:www-data "${FILES_DIR}" /home/www-data/.ssh; \
    chown -R anaxexp:anaxexp \
        "${APP_ROOT}" \
        "${CONF_DIR}" \
        "${PHP_INI_DIR}/conf.d" \
        /usr/local/etc/php-fpm.d/ \
        /home/anaxexp/; \
    \
    # SSHD
    touch /etc/ssh/sshd_config; \
    chown anaxexp: /etc/ssh/sshd_config; \
    \
    # Crontab
    rm /etc/crontabs/root; \
    # deprecated: remove in favor of bind mounts.
    touch /etc/crontabs/www-data; \
    chown root:www-data /etc/crontabs/www-data; \
    chmod 660 /etc/crontabs/www-data; \
    \
    # Cleanup
    su-exec anaxexp composer clear-cache; \
    docker-php-source delete; \
    apk del --purge .build-deps; \
    pecl clear-cache; \
    \
    rm -rf \
        /usr/include/php \
        /usr/lib/php/build \
        /tmp/* \
        /root/.composer \
        /var/cache/apk/*; \
    \
    if [[ -z "${PHP_DEV}" ]]; then \
        rm -rf /usr/src/php.tar.xz; \
    fi

USER anaxexp

WORKDIR ${APP_ROOT}
EXPOSE 9000

COPY templates /etc/gotpl/
COPY docker-entrypoint.sh /
COPY bin /usr/local/bin/

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["sudo", "-E", "LD_PRELOAD=/usr/lib/preloadable_libiconv.so", "php-fpm"]