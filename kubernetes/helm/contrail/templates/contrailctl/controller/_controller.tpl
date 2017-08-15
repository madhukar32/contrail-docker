{{/* =============================================================== */}}
{{/* CONTROLLER section of the contrailctl is formed using this template */}}
{{/* =============================================================== */}}

{{- define "contrail.controllerConfig" -}}

[CONTROLLER]

{{- if not .controller.encap_priority -}}#{{- end -}}encap_priority = {{- .controller.encap_priority | default "MPLSoUDP,MPLSoGRE,VXLAN" }}

{{- if not .controller.external_routers_list -}}#{{- end -}}external_routers_list = {{- .controller.external_routers_list }}

{{- if not .controller.bgp_asn -}}#{{- end -}}bgp_asn = {{- .controller.bgp_asn | default 64512 }}

{{- if not .controller.flow_export_rate -}}#{{- end -}}flow_export_rate = {{- .controller.flow_export_rate }}

{{- end -}}

{{/* =============================================================== */}}
{{/* CONTROL section of the contrailctl is formed using this template */}}
{{/* =============================================================== */}}

{{- define "contrail.controlConfig" -}}

[CONTROL]

{{- include "logPortConfig" .control.log_port_info }}

{{- if not .control.bgp_port -}}#{{- end -}}bgp_port = {{ .control.bgp_port | default 179 }}

{{- if not .control.xmpp_server_port -}}#{{- end -}}xmpp_server_port = {{ .control.xmpp_server_port | default 5269 }}

{{- end -}}
