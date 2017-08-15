{{/* =============================================================== */}}
{{/*     Control services config are defined in this template        */}}
{{/* =============================================================== */}}

{{/* ========================================== */}}
{{/* Schema config are defined in this template */}}
{{/* ========================================== */}}

{{- define "contrail.schemaConfig" -}}

[SCHEMA]

{{ include "logPortConfig" .schema.log_port_info }}

{{- end -}}

{{/* =============================================== */}}
{{/* SVC_MONITOR config are defined in this template */}}
{{/* =============================================== */}}

{{- define "contrail.svcMonitorConfig" -}}

[SVC_MONITOR]

{{ include "logPortConfig" .svc_monitor.log_port_info }}

{{- end -}}

{{/* ================================================== */}}
{{/* DEVICE_MANAGER config are defined in this template */}}
{{/* ================================================== */}}
{{- define "contrail.devMgrConfig" -}}

[DEVICE_MANAGER]

{{ include "logPortConfig" .device_manager.log_port_info }}

{{- end -}}

{{/* ======================================= */}}
{{/* DNS config are defined in this template */}}
{{/* ======================================= */}}

{{- define "contrail.dnsConfig" -}}

[DNS]

{{- include "logPortConfig" .dns.log_port_info -}}

{{- if not .dns.named_log_file -}}#{{- end -}}named_log_file = {{- .dns.named_log_file | default "/var/log/contrail/contrail-named.log" | quote }}

{{- if not .dns.dns_server_port -}}#{{- end -}}dns_server_port = {{- int .dns.dns_server_port | default 53 }}

{{- end -}}
