{{/* =============================================================== */}}
{{/* Config API section of the contrailctl is formed using this template */}}
{{/* =============================================================== */}}

{{- define "contrail.analyticsAPI" -}}

[ANALYTICS_API]

{{ include "logPortConfig" .analytics_api.log_port_info }}

{{- if not .analytics_api.aaa_mode -}}#{{- end -}}aaa_mode = {{- .analytics_api.aaa_mode | default "no-auth" }}

{{- end -}}

