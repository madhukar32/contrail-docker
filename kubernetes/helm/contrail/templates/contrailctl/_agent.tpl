{{/* =============================================================== */}}
{{/* AGENT section of the contrailctl is formed using this template */}}
{{/* =============================================================== */}}
{{- define "contrail.agentConfig" -}}
[AGENT]

{{- if not .hostOs -}}{{- $_ := set . "hostOs" "ubuntu" -}}{{- end }}
{{- if eq .hostOs "centos7" -}}{{- $_ := set .conf.agent "compile_vrouter_module" "False" -}}{{- end }}
compile_vrouter_module = {{ .agent.compile_vrouter_module | default "True" }}

{{- if not .conf.agent.qos_queue_id_list -}}#{{- end -}}qos_queue_id_list = {{ .conf.agent.qos_queue_id_list }}

{{- if not .conf.agent.qos_logical_queue_list -}}#{{- end -}}qos_logical_queue_list = {{ .conf.agent.qos_logical_queue_list }}

{{- if not .conf.agent.qos_default_nic_queue -}}#{{- end -}}qos_default_nic_queue = {{ .conf.agent.qos_default_nic_queue }}

{{- if not .conf.agent.qos_priority_tagging -}}#{{- end -}}qos_priority_tagging = {{ .conf.agent.qos_priority_tagging }}

{{- if not .conf.agent.priority_id_list -}}#{{- end -}}priority_id_list = {{ .conf.agent.priority_id_list }}

{{- if not .conf.agent.priority_scheduling_list -}}#{{- end -}}priority_scheduling_list = {{ .conf.agent.priority_scheduling_list }}

{{- if not .conf.agent.priority_bandwidth_list -}}#{{- end -}}priority_bandwidth_list = {{ .conf.agent.priority_bandwidth_list }}

{{- if not .conf.agent.vrouter_module_params -}}#{{- end -}}vrouter_module_params = {{ .conf.agent.vrouter_module_params }}
[HYPERVISOR]
{{- if not .conf.agent.hypervisor.type -}}#{{- end -}}type = {{ .conf.agent.hypervisor.type | default kvm }}
{{- end -}}
