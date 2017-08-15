{{/* =============================================================== */}}
{{/* ANALYTICS_COLLECTOR section of the contrailctl is formed using this template */}}
{{/* =============================================================== */}}

{{- define "contrail.collectorConfig" -}}

[ANALYTICS_COLLECTOR]
{{ include "logPortConfig" .analytics_collector.log_port_info }}

{{- if not .analytics_collector.syslog_port-}}#{{- end -}}syslog_port = {{ .analytics_collector.syslog_port | default -1 }}

{{- if not .analytics_collector.analytics_flow_ttl -}}#{{- end -}}analytics_flow_ttl = {{ .analytics_collector.analytics_flow_ttl | default 48 }}

{{- if not .analytics_collector.analytics_statistics_ttl -}}#{{- end -}}analytics_statistics_ttl = {{ .analytics_collector.analytics_statistics_ttl | default 2160 }}

{{- if not .analytics_collector.analytics_config_audit_ttl -}}#{{- end -}}analytics_config_audit_ttl = {{ .analytics_collector.analytics_config_audit_ttl | default 24 }}

{{- if not .analytics_collector.analytics_data_ttl -}}#{{- end -}}analytics_data_ttl = {{ .analytics_collector.analytics_data_ttl | default }}

{{- end -}}

