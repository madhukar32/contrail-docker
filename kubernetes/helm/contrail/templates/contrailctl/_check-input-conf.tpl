{{/* =============================================================== */}}
{{/*           Check existence of the input values                   */}}
{{/*    if not defined then set the correct data struct              */}}
{{/* =============================================================== */}}

{{- define "contrail.checkInputConfStruct" -}}

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
{{- if not .conf.control.log_port_info -}}{{- $_ := set .conf.control "log_port_info" dict -}}{{- end -}}

{{- if not .conf.contrail_api -}}{{- $_ := set .conf "contrail_api" dict -}}{{- end -}}
{{- if not .conf.contrail_api.log_port_info -}}{{- $_ := set .conf.contrail_api "log_port_info" dict -}}{{- end -}}

{{- if not .conf.schema -}}{{- $_ := set .conf "schema" dict -}}{{- end -}}
{{- if not .conf.schema.log_port_info -}}{{- $_ := set .conf.schema "log_port_info" dict -}}{{- end -}}

{{- if not .conf.svc_monitor -}}{{- $_ := set .conf "svc_monitor" dict -}}{{- end -}}
{{- if not .conf.svc_monitor.log_port_info -}}{{- $_ := set .conf.svc_monitor "log_port_info" dict -}}{{- end -}}

{{- if not .conf.device_manager -}}{{- $_ := set .conf "device_manager" dict -}}{{- end -}}
{{- if not .conf.device_manager.log_port_info -}}{{- $_ := set .conf.device_manager "log_port_info" dict -}}{{- end -}}

{{- if not .conf.dns -}}{{- $_ := set .conf "dns" dict -}}{{- end -}}
{{- if not .conf.dns.log_port_info -}}{{- $_ := set .conf.dns "log_port_info" dict -}}{{- end -}}

{{- if not .conf.analytics_api -}}{{- $_ := set .conf "analytics_api" dict -}}{{- end -}}
{{- if not .conf.analytics_api.log_port_info -}}{{- $_ := set .conf.analytics_api "log_port_info" dict -}}{{- end -}}

{{- if not .conf.analytics_colletor -}}{{- $_ := set .conf "analytics_colletor" dict -}}{{- end -}}
{{- if not .conf.analytics_colletor.log_port_info -}}{{- $_ := set .conf.analytics_colletor "log_port_info" dict -}}{{- end -}}

{{- if not .conf.alarm_gen -}}{{- $_ := set .conf "alarm_gen" dict -}}{{- end -}}
{{- if not .conf.alarm_gen.log_port_info -}}{{- $_ := set .conf.alarm_gen "log_port_info" dict -}}{{- end -}}

{{- if not .conf.query_engine -}}{{- $_ := set .conf "query_engine" dict -}}{{- end -}}
{{- if not .conf.query_engine.log_port_info -}}{{- $_ := set .conf.query_engine "log_port_info" dict -}}{{- end -}}

{{- if not .conf.topology -}}{{- $_ := set .conf "topology" dict -}}{{- end -}}
{{- if not .conf.topology.log_port_info -}}{{- $_ := set .conf.topology "log_port_info" dict -}}{{- end -}}

{{- if not .conf.snmp_collector -}}{{- $_ := set .conf "snmp_collector" dict -}}{{- end -}}
{{- if not .conf.snmp_collector.log_port_info -}}{{- $_ := set .conf.snmp_collector "log_port_info" dict -}}{{- end -}}

{{- if not .conf.webui -}}{{- $_ := set .conf "webui" dict -}}{{- end -}}

{{- if not .conf.rabbitmq -}}{{- $_ := set .conf "rabbitmq" dict -}}{{- end -}}

{{- if not .conf.configdb_cassandra -}}{{- $_ := set .conf "configdb_cassandra" dict -}}{{- end -}}

{{- if not .conf.analyticsdb_cassandra -}}{{- $_ := set .conf "analyticsdb_cassandra" dict -}}{{- end -}}

{{- if not .conf.agent -}}{{- $_ := set .conf "agent" dict -}}{{- end -}}

{{- if not .conf.kubernetes -}}{{- $_ := set .conf "kubernetes" dict -}}{{- end -}}

{{- end -}}
