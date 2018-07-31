<?php
/**
 * @file
 * AnaxExp environment configuration for generic PHP project.
 */

{{ if getenv "ANAXEXP_HOSTS" }}{{ range jsonArray (getenv "ANAXEXP_HOSTS") }}
$anaxexp['hosts'][] = '{{ . }}';
{{ end }}{{ end }}

$anaxexp['files_dir'] = '{{ getenv "FILES_DIR" }}';

$anaxexp['db']['host'] = '{{ getenv "DB_HOST" }}';
$anaxexp['db']['name'] = '{{ getenv "DB_NAME" }}';
$anaxexp['db']['username'] = '{{ getenv "DB_USER" }}';
$anaxexp['db']['password'] = '{{ getenv "DB_PASSWORD" }}';
$anaxexp['db']['driver'] = '{{ getenv "DB_DRIVER" }}';

$anaxexp['redis']['host'] = '{{ getenv "REDIS_HOST" }}';
$anaxexp['redis']['port'] = '{{ getenv "REDIS_PORT" "6379" }}';
$anaxexp['redis']['password'] = '{{ getenv "REDIS_PASSWORD" }}';

$anaxexp['varnish']['host'] = '{{ getenv "VARNISH_HOST" }}';
$anaxexp['varnish']['terminal_port'] = '{{ getenv "VARNISH_TERMINAL_PORT" "6082" }}';
$anaxexp['varnish']['secret'] = '{{ getenv "VARNISH_SECRET" }}';
$anaxexp['varnish']['version'] = '{{ getenv "VARNISH_VERSION" }}';

$anaxexp['memcached']['host'] = '{{ getenv "MEMCACHED_HOST" }}';
$anaxexp['memcached']['port'] = '{{ getenv "MEMCACHED_PORT" "11211" }}';
