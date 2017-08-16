{{/* =============================================================== */}}
{{/* Analyticsdb container's contrailctl config is formed using this template */}}
{{/* =============================================================== */}}

{{- define "contrail.analyticsdbConfig" -}}

{{/* ==================== CASSADRA SECTION ======================= */}}

{{- include "contrail.cassandraConfig" .analyticsdbCassandra -}}

{{- end -}}
