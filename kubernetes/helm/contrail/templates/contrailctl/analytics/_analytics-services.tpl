{{/* =============================================================== */}}
{{/* Analytics services of the contrailctl is formed using this template */}}
{{/* =============================================================== */}}

{{- define "contrail.alarmGenConfig" -}}

[ALARM_GEN]

{{ include "logPortConfig" .alarm_gen.log_port_info }}

{{- end -}}

{{- define "contrail.queryEngineConfig" -}}

[QUERY_ENGINE]

{{ include "logPortConfig" .query_engine.log_port_info }}

{{- end -}}

{{- define "contrail.topologyConfig" -}}

[TOPOLOGY]

{{ include "logPortConfig" .topology.log_port_info }}

{{- end -}}
