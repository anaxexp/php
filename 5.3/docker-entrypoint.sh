#!/usr/bin/env bash

set -e

if [[ -n "${DEBUG}" ]]; then
    set -x
fi

ssh_dir=/home/anaxexp/.ssh

_gotpl() {
    if [[ -f "/etc/gotpl/$1" ]]; then
        gotpl "/etc/gotpl/$1" > "$2"
    fi
}

# @deprecated will be removed in favor of bind mounts (config maps).
init_ssh_client() {
    if [[ -n "${SSH_PRIVATE_KEY}" ]]; then
        _gotpl "id_rsa.tmpl" "${ssh_dir}/id_rsa"
        chmod -f 600 "${ssh_dir}/id_rsa"
        unset SSH_PRIVATE_KEY
    fi
}

init_sshd() {
    _gotpl "sshd_config.tmpl" "/etc/ssh/sshd_config"

    # @deprecated will be removed in favor of bind mounts (config maps).
    if [[ -n "${SSH_PUBLIC_KEYS}" ]]; then
        _gotpl "authorized_keys.tmpl" "${ssh_dir}/authorized_keys"
        unset SSH_PUBLIC_KEYS
    fi

    printenv | xargs -I{} echo {} | awk ' \
        BEGIN { FS = "=" }; { \
            if ($1 != "HOME" \
                && $1 != "PWD" \
                && $1 != "PATH" \
                && $1 != "SHLVL") { \
                \
                print ""$1"="$2"" \
            } \
        }' > "${ssh_dir}/environment"

    sudo gen_ssh_keys "rsa" "${SSHD_HOST_KEYS_DIR}"
}

# @deprecated will be removed in favor of bind mounts (config maps).
init_crond() {
    if [[ -n "${CRONTAB}" ]]; then
        _gotpl "crontab.tmpl" "/etc/crontabs/www-data"
    fi
}

process_templates() {
    if [[ -n "${PHP_DEV}" ]]; then
        export PHP_FPM_CLEAR_ENV="${PHP_FPM_CLEAR_ENV:-no}"
    fi

    _gotpl "docker-php.ini.tmpl" "${PHP_INI_DIR}/conf.d/docker-php.ini"
    _gotpl "docker-php-ext-opcache.ini.tmpl" "${PHP_INI_DIR}/conf.d/docker-php-ext-opcache.ini"
    _gotpl "docker-php-ext-xdebug.ini.tmpl" "${PHP_INI_DIR}/conf.d/docker-php-ext-xdebug.ini"
    _gotpl "zz-www.conf.tmpl" "/usr/local/etc/php-fpm.d/zz-www.conf"
    _gotpl "anaxexp.settings.php.tmpl" "${CONF_DIR}/anaxexp.settings.php"

    _gotpl "ssh_config.tmpl" "${ssh_dir}/config"
}

init_git() {
    git config --global user.email "${GIT_USER_EMAIL}"
    git config --global user.name "${GIT_USER_NAME}"
}

sudo init_container

init_ssh_client
init_git
process_templates

if [[ "${@:1:2}" == "sudo /usr/sbin/sshd" ]]; then
    init_sshd
elif [[ "${@:1:3}" == "sudo -E crond" ]]; then
    init_crond
fi

exec_init_scripts

if [[ "${1}" == "make" ]]; then
    exec "${@}" -f /usr/local/bin/actions.mk
else
    exec /usr/local/bin/docker-php-entrypoint "${@}"
fi
