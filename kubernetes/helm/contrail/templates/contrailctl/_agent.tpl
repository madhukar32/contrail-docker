{{/* =============================================================== */}}
{{/* AGENT section of the contrailctl is formed using this template */}}
{{/* =============================================================== */}}
{{- define "contrail.agentConfig" -}}
[AGENT]

{{- if eq .hostOs "centos7" -}}{{- $_ := set .conf.agent "compile_vrouter_module" "False" -}}{{- end }}
compile_vrouter_module = {{ .agent.compileVrouterModule | default "True" }}

{{- if not .conf.agent.ctrlDataNetwork -}}#{{- end -}}ctrl_data_network = {{ .conf.agent.ctrlDataNetwork }}
{{- if not .conf.agent.qosQueueIdList -}}#{{- end -}}qos_queue_id_list = {{ .conf.agent.qosQueueIdList }}

{{- if not .conf.agent.qosLogicalQueueList -}}#{{- end -}}qos_logical_queue_list = {{ .conf.agent.qosLogicalQueueList }}

{{- if not .conf.agent.qosDefaultNicQueue -}}#{{- end -}}qos_default_nic_queue = {{ .conf.agent.qosDefaultNicQueue }}

{{- if not .conf.agent.qosPriorityTagging -}}#{{- end -}}qos_priority_tagging = {{ .conf.agent.qosPriorityTagging }}

{{- if not .conf.agent.priorityIdList -}}#{{- end -}}priority_id_list = {{ .conf.agent.priorityIdList }}

{{- if not .conf.agent.prioritySchedulingList -}}#{{- end -}}priority_scheduling_list = {{ .conf.agent.priority_scheduling_list }}

{{- if not .conf.agent.priorityBandwidthList -}}#{{- end -}}priority_bandwidth_list = {{ .conf.agent.priorityBandwidthList }}

{{- if not .conf.agent.vrouterModuleParams -}}#{{- end -}}vrouter_module_params = {{ .conf.agent.vrouterModuleParams }}
[HYPERVISOR]
{{- if not .conf.agent.hypervisor.type -}}#{{- end -}}type = {{ .conf.agent.hypervisor.type | default kvm }}
{{- end -}}
