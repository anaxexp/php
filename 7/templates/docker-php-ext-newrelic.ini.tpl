[newrelic]
extension = newrelic.so
newrelic.enabled = {{ getenv "PHP_NEWRELIC_ENABLED" "false" }}
newrelic.license = "{{ getenv "PHP_NEWRELIC_LICENSE" }}"
newrelic.appname = "{{ getenv "PHP_NEWRELIC_APPNAME" "My PHP app" }}"
newrelic.capture_params = {{ getenv "PHP_NEWRELIC_CAPTURE_PARAMS" "false" }}
newrelic.ignored_params = "{{ getenv "PHP_NEWRELIC_IGNORED_PARAMS" }}"
newrelic.loglevel = "{{ getenv "PHP_NEWRELIC_LOGLEVEL" "info" }}"
newrelic.transaction_tracer.detail = {{ getenv "PHP_NEWRELIC_TRANSACTION_TRACER_DETAIL" "1" }}
newrelic.high_security = {{ getenv "PHP_NEWRELIC_HIGH_SECURITY" "false" }}
newrelic.labels = "{{ getenv "PHP_NEWRELIC_LABELS" }}"
{{ if getenv "PHP_NEWRELIC_FRAMEWORK" }}
newrelic.framework = {{ getenv "PHP_NEWRELIC_FRAMEWORK" }}
{{ end }}
newrelic.daemon.port = "{{ getenv "PHP_NEWRELIC_DAEMON_PORT" "@newrelic-daemon" }}"
