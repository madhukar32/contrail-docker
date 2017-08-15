{{/* =============================================================== */}}
{{/* log and port of the contrailctl is formed using this template */}}
{{/* Below are the defined fields as part of this template */}}
{{/* 	- log_file */}}
{{/* 	- log_level */}}
{{/* 	- introspect_port */}}
{{/* 	- listen_port */}}
{{/* =============================================================== */}}

{{- define "logPortConfig" -}}

{{- if not .log_file -}}#{{- end -}}log = {{ .log_file }}

{{- if not .log_level -}}#{{- end -}}log_level = {{ .log_level | default "SYS_NOTICE" }}

{{- if not .introspect_port -}}#{{- end -}}introspect_port = {{ .introspect_port }}

{{- if not .listen_port -}}#{{- end -}}listen_port = {{ .listen_port }}

{{- end -}}
