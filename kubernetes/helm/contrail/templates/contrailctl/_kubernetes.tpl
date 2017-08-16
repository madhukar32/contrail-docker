{{/* =================================================================== */}}
{{/* KUBERNETES section of the contrailctl is formed using this template */}}
{{/* =================================================================== */}}
{{- define "contrail.kubernetesConfig" -}}

[KUBERNETES]

{{- $kubernetes_api_server_default := first .global.controller.nodes }}
api_server = {{ .kubernetes.apiServer | default $kubernetes_api_server_default }}
cluster_name = {{ .kubernetes.clusterName | default "default-cluster" }}
cluster_network = {}
pod_subnets = {{ .kubernetes.podSubnets | default "10.32.0.0/12" }}
service_subnets = {{ .kubernetes.svcSubnets | default "10.96.0.0/12" }}
cluster_project = {{ if not .kubernetes.clusterProject -}}{'domain': 'default-domain', 'project': 'default'}{{ else -}}{{ .kubernetes.clusterProject }}{{- end }}
[KUBERNETES_VNC]
public_fip_pool = {{- if not .kubernetes.publicFipPool -}}{}{{- else -}}{{ .kubernetes.publicFipPool }}{{- end -}}
{{- end -}}
