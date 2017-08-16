{{/* =============================================================== */}}
{{/*           Check existence of the input values                   */}}
{{/*    if not defined then set the correct data struct              */}}
{{/* =============================================================== */}}

{{- define "contrail.checkInputConfStruct" -}}

{{- if not .hostOs -}}{{- $_ := set . "hostOs" "ubuntu" -}}{{- end -}}
{{- if not .conf -}}{{- $_ := set . "conf" dict -}}{{- end -}}
{{- if not .conf.global -}}{{- $_ := set .conf "global" dict -}}{{- end -}}
{{- if not .conf.global.controller -}}{{- $_ := set .conf.global "controller" dict -}}{{- end -}}
{{- if not .conf.global.analyticsdb -}}{{- $_ := set .conf.global "analyticsdb" dict -}}{{- end -}}
{{- if not .conf.global.analytics -}}{{- $_ := set .conf.global "analytics" dict -}}{{- end -}}
{{- if not .conf.global.config -}}{{- $_ := set .conf.global "config" dict -}}{{- end -}}
{{- if not .conf.global.webui -}}{{- $_ := set .conf.global "webui" dict -}}{{- end -}}
{{- if not .conf.global.external -}}{{- $_ := set .conf.global "external" dict -}}{{- end -}}
{{- if not .conf.global.ssl -}}{{- $_ := set .conf.global "ssl" dict -}}{{- end -}}
{{- if not .conf.global.apiserver -}}{{- $_ := set .conf.global "apiserver" dict -}}{{- end -}}
{{- if not .conf.global.neutron -}}{{- $_ := set .conf.global "neutron" dict -}}{{- end -}}
 
{{- if not .conf.controller -}}{{- $_ := set .conf "controller" dict -}}{{- end -}}
{{- if not .conf.control -}}{{- $_ := set .conf "control" dict -}}{{- end -}}
{{- if not .conf.control.logPortInfo -}}{{- $_ := set .conf.control "log_port_info" dict -}}{{- end -}}

{{- if not .conf.contrailAPI -}}{{- $_ := set .conf "contrail_api" dict -}}{{- end -}}
{{- if not .conf.contrailAPI.logPortInfo -}}{{- $_ := set .conf.contrailAPI "log_port_info" dict -}}{{- end -}}

{{- if not .conf.schema -}}{{- $_ := set .conf "schema" dict -}}{{- end -}}
{{- if not .conf.schema.logPortInfo -}}{{- $_ := set .conf.schema "log_port_info" dict -}}{{- end -}}

{{- if not .conf.svcMonitor -}}{{- $_ := set .conf "svc_monitor" dict -}}{{- end -}}
{{- if not .conf.svcMonitor.logPortInfo -}}{{- $_ := set .conf.svcMonitor "log_port_info" dict -}}{{- end -}}

{{- if not .conf.deviceManager -}}{{- $_ := set .conf "device_manager" dict -}}{{- end -}}
{{- if not .conf.deviceManager.logPortInfo -}}{{- $_ := set .conf.deviceManager "log_port_info" dict -}}{{- end -}}

{{- if not .conf.dns -}}{{- $_ := set .conf "dns" dict -}}{{- end -}}
{{- if not .conf.dns.logPortInfo -}}{{- $_ := set .conf.dns "log_port_info" dict -}}{{- end -}}

{{- if not .conf.analyticsAPI -}}{{- $_ := set .conf "analytics_api" dict -}}{{- end -}}
{{- if not .conf.analyticsAPI.logPortInfo -}}{{- $_ := set .conf.analyticsAPI "log_port_info" dict -}}{{- end -}}

{{- if not .conf.analyticsCollector -}}{{- $_ := set .conf "analytics_colletor" dict -}}{{- end -}}
{{- if not .conf.analyticsCollector.logPortInfo -}}{{- $_ := set .conf.analytics_colletor "log_port_info" dict -}}{{- end -}}

{{- if not .conf.alarmGen -}}{{- $_ := set .conf "alarm_gen" dict -}}{{- end -}}
{{- if not .conf.alarmGen.logPortInfo -}}{{- $_ := set .conf.alarmGen "log_port_info" dict -}}{{- end -}}

{{- if not .conf.queryEngine -}}{{- $_ := set .conf "query_engine" dict -}}{{- end -}}
{{- if not .conf.queryEngine.logPortInfo -}}{{- $_ := set .conf.queryEngine "log_port_info" dict -}}{{- end -}}

{{- if not .conf.topology -}}{{- $_ := set .conf "topology" dict -}}{{- end -}}
{{- if not .conf.topology.logPortInfo -}}{{- $_ := set .conf.topology "log_port_info" dict -}}{{- end -}}

{{- if not .conf.snmpCollector -}}{{- $_ := set .conf "snmp_collector" dict -}}{{- end -}}
{{- if not .conf.snmpCollector.logPortInfo -}}{{- $_ := set .conf.snmpCollector "log_port_info" dict -}}{{- end -}}

{{- if not .conf.webui -}}{{- $_ := set .conf "webui" dict -}}{{- end -}}

{{- if not .conf.rabbitmq -}}{{- $_ := set .conf "rabbitmq" dict -}}{{- end -}}

{{- if not .conf.configdb_cassandra -}}{{- $_ := set .conf "configdb_cassandra" dict -}}{{- end -}}

{{- if not .conf.analyticsdb_cassandra -}}{{- $_ := set .conf "analyticsdb_cassandra" dict -}}{{- end -}}

{{- if not .conf.agent -}}{{- $_ := set .conf "agent" dict -}}{{- end -}}
{{- if not .conf.agent.hypervisor -}}{{- $_ := set .conf.agent "hypervisor" dict -}}{{- end -}}

{{- if not .conf.kubernetes -}}{{- $_ := set .conf "kubernetes" dict -}}{{- end -}}

{{- if not .conf.kubernetesVNC -}}{{- $_ := set .conf "kubernetesVNC" dict -}}{{- end -}}

{{- end -}}
