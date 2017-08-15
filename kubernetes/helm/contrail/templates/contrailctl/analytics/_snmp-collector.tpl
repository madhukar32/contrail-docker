{{/* =============================================================== */}}
{{/* SNMP_COLLECTOR section of the contrailctl is formed using this template */}}
{{/* =============================================================== */}}


{{- define "contrail.snmpConfig" -}}

[SNMP_COLLECTOR]

{{ include "logPortConfig" .snmp_collector.log_port_info }}

{{- if not .snmp_collector.scan_frequency -}}#{{- end -}}scan_frequency = {{ .snmp_collector.scan_frequency | default 600 }}

{{- if not .snmp_collector.fast_scan_frequency -}}#{{- end -}}fast_scan_frequency = {{ .snmp_collector.fast_scan_frequency | default 60 }}

{{- end }}
