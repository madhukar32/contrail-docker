{{/* =============================================================== */}}
{{/*   Generates varaibles needed by contrail.globalConfig template  */}}
{{/* =============================================================== */}}

{{- define "contrail.getGlobalVars" -}}

{{- required "Controller_nodes should be given as list in .Values.conf.global.controller.nodes" .controller.nodes -}}

{{- $controller_nodes := .controller.nodes -}}
{{- $analyticsdb_nodes := .analyticsdb.nodes | default .controller.nodes -}}
{{- $analytics_nodes := .analytics.nodes | default .controller.nodes -}}
{{- $config_nodes := .config.nodes | default .controller.nodes -}}
{{- if .webui.nodes -}}{{- $webui_nodes := .webui.nodes -}}{{- end -}}
{{- if .external.rabbitmqServers -}}{{ $rabbitmq_servers := .external.rabbitmqServers -}}{{- end -}}
{{- if .external.controllerZookeeperServers -}}{{ $ctrl_zookeper_servers := .external.controllerZookeeperServers -}}{{- end -}}
{{- if .external.analyticsdbZookeeperServers -}}{{ $adb_zookeper_servers := .external.analyticsdbZookeeperServers -}}{{- end -}}

{{- $len_controller_nodes := len $controller_nodes -}}
{{- $len_analyticsdb_nodes := len $analyticsdb_nodes -}}
{{- $len_analytics_nodes := len $analytics_nodes -}}
{{- $len_config_nodes := len $config_nodes -}}
{{- if $rabbitmq_servers -}}{{- $len_rabbitmq_servers := len $rabbitmq_servers -}}{{- end -}}
{{- if $ctrl_zookeper_servers -}}{{- $len_ctrl_zookeper_servers := len $ctrl_zookeper_servers -}}{{- end -}}
{{- if $adb_zookeper_servers -}}{{- $len_adb_zookeper_servers := len $adb_zookeper_servers -}}{{- end -}}

{{- end -}}

{{/* =============================================================== */}}
{{/* GLOBAL section of the contrailctl is formed using this template */}}
{{/* =============================================================== */}}

{{- define "contrail.globalConfig" -}}

{{- include "contrail.getGlobalVars" . -}}

[GLOBAL]

controller_nodes = {{- if gt $len_controller_nodes 1 -}}{{- $controller_nodes | join "," }}{{- else -}} {{- first $controller_nodes }}{{- end -}}

analyticsdb_nodes = {{- if gt $len_analyticsdb_nodes 1 -}}{{- $analyticsdb_nodes | join "," }}{{- else -}}{{- first $analyticsdb_nodes }}{{- end -}}

analytics_nodes = {{- if gt $len_analytics_nodes 1 -}}{{- $analytics_nodes | join "," }}{{- else -}}{{- first $analytics_nodes }}{{- end -}}

config_nodes = {{- if gt $len_config_nodes 1 -}}{{- $config_nodes | join "," }}{{- else -}}{{- first $config_nodes }}{{- end -}}

controller_ip = {{- .controller.virtual_ip | default first $controller_nodes }}
config_ip = {{- .config.virtual_ip | default first $config_nodes }}
analytics_ip = {{- .analytics.virtual_ip | default first $analytics_nodes }}
analyticsdb_ip = {{- .analyticsdb.virtual_ip | default first $analyticsidb_nodes }}

{{- if not .controller.enableControlService -}}#{{- end -}}enable_control_service = {{- .controller.enableControlService | default "true" }}
{{- if not .webui.enableWebuiService -}}#{{- end -}}enable_webui_service = {{- .webui.enableWebuiService | default "true" }}
{{- if not .config.enableWebuiService -}}#{{- end -}}enable_config_service = {{- .webui.enableConfigService | default "true" -}}

{{- if not .config.cassandraUser -}}#{{- end -}}configdb_cassandra_user = {{- .config.cassandraUser | default '' -}}
{{- if not .config.cassandraPassword -}}#{{- end -}}configdb_cassandra_password = {{- .config.cassandraPassword | default '' -}}
{{- if not .analyticsdb.cassandraUser -}}#{{- end -}}analyticsdb_cassandra_user = {{- .analyticsdb.cassandraUser | default '' -}}
{{- if not .analyticsdb.cassandraPassword -}}#{{- end -}}analyticsdb_cassandra_password = {{- .analyticsdb.cassandraPassword | default '' -}}

{{/* TODO check if the hosts_entries format works */}}
{{- if not .hostsEntries -}}#{{- end -}}hosts_entries = {{- .hostsEntries | default '' -}}
{{- if not .cloudOrchestrator -}}#{{- end -}}cloud_orchestrator = {{- .cloudOrchestrator | default "kubernetes" }}


{{- if not .uvePartitionCount -}}#{{- end -}}uve_partition_count = {{- .uvePartitionCount }}

{{- if not .external.rabbitmqServers -}}#{{- end -}}external_rabbitmq_servers = {{- if gt $rabbitmq_servers 1 -}}{{- $rabbitmq_servers | join "," }}{{- else -}}{{- first $rabbitmq_servers }}{{- end -}}
{{- if not .external.controllerZookeeperServers -}}#{{- end -}}external_zookeeper_servers = {{- if gt $ctrl_zookeper_servers 1 -}}{{- $ctrl_zookeper_servers | join "," }}{{- else -}}{{- first $ctrl_zookeper_servers }}{{- end -}}
{{- if not .external.analyticsdbZookeeperServers -}}#{{- end -}}external_analyticsdb_zookeeper_servers = {{- if gt $adb_zookeper_servers 1 -}}{{- $adb_zookeper_servers | join "," }}{{- else -}}{{- first $adb_zookeper_servers }}{{- end -}}

{{- if not .ssl.xmppAuth -}}#{{- end -}}xmpp_auth_enable = {{- .ssl.xmppAuth | default 'false' }}
{{- if not .ssl.xmppDNSAuth -}}#{{- end -}}xmpp_dns_auth_enable = {{- .ssl.xmppDNSAuth | default 'false' }}
{{- if not .ssl.sandesh -}}#{{- end -}}sandesh_ssl_enable = {{- .ssl.sandesh | default 'false' }}
{{- if not .ssl.introspect -}}#{{- end -}}introspect_ssl_enable = {{- .ssl.introspect | default 'false' }}

{{- if not .apiserver.authProtocol -}}#{{- end -}}apiserver_auth_protocol = {{- .apiserver.authProtocol | default 'http' }}
{{- if not .apiserver.certfile -}}#{{- end -}}apiserver_certfile = {{- .apiserver.certfile |  default '' }}
{{- if not .apiserver.keyfile -}}#{{- end -}}apiserver_keyfile = {{- .apiserver.keyfile | default '' }}
{{- if not .apiserver.cafile -}}#{{- end -}}apiserver_cafile = {{- .apiserver.cafile | default '' }}
{{- if not .apiserver.insecure -}}#{{- end -}}apiserver_insecure = {{- .apiserver.insecure | default '' }}

{{- if not .neutron.metadataIP -}}#{{- end -}}neutron_metadata_ip = {{- .neutron.metadataIP | default '' }}
{{- if not .neutron.metadataPort -}}#{{- end -}}neutron_metadata_port = {{- .neutron.metadataPort | default '' }}

{{- end -}}
