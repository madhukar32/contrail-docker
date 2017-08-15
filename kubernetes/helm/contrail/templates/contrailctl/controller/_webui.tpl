{{/* ============================================================== */}}
{{/* WEBUI section of the contrailctl is formed using this template */}}
{{/* ============================================================== */}}
{{- define "contrail.webuiConfig" -}}
[WEBUI]
{{- if not .webui -}}{{- $_ := set . "webui" dict -}}{{- end }}
{{- if not .webui.http_listen_port -}}#{{- end -}}http_listen_port = {{ .webui.http_listen_port | default 8080 }} 

{{- if not .webui.https_listen_port -}}#{{- end -}}https_listen_port = {{ .webui.https_listen_port | default 8143  }} 

{{- if not .webui.storage_enable -}}#{{- end -}}webui_storage_enable = {{ .webui.storage_enable | default "false" }}

{{- if not .webui.enable_underlay -}}#{{- end -}}enable_underlay = {{ .webui.enable_underlay | default 'false'  }}

{{- if not .webui.enable_mx -}}#{{- end -}}enable_mx = {{ .webui.enable_mx | default 'false'  }}

{{- if not .webui.enable_udd -}}#{{- end -}}enable_udd = {{ .webui.enable_udd | default "false"  }}

{{- if not .webui.service_endpoint_from_config -}}#{{- end -}}service_endpoint_from_config = {{ .webui.service_endpoint_from_config | default "false" }}

{{- if not .webui.server_options_key_file -}}#{{- end -}}server_options_key_file = {{ .webui.server_options_key_file }}

{{- if not .webui.server_options_cert_file -}}#{{- end -}}server_options_cert_file = {{ .webui.server_options_cert_file  }}

{{- end -}}
