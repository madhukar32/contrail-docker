{{/* =============================================================== */}}
{{/* log and port of the contrailctl is formed using this template */}}
{{/* Below are the defined fields as part of this template */}}
{{/* 	- log_file */}}
{{/* 	- log_level */}}
{{/* 	- introspect_port */}}
{{/* 	- listen_port */}}
{{/* =============================================================== */}}

{{- define "contrail.logPortConfig" -}}

{{- if not .logFile -}}#{{- end -}}log = {{ .logFile }}

{{- if not .logLevel -}}#{{- end -}}log_level = {{ .logLevel | default "SYS_NOTICE" }}

{{- if not .introspectPort -}}#{{- end -}}introspect_port = {{ .introspectPort }}

{{- if not .listenPort -}}#{{- end -}}listen_port = {{ .listenPort }}

{{- end -}}
