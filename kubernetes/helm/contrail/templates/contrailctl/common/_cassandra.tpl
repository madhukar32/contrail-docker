{{/* =============================================================== */}}
{{/* Cassandra config for contrailctl is formed using this template */}}
{{/* Below are the defined fields as part of this template */}}
{{/* 	- commitlog_dir */}}
{{/* 	- data_dirs */}}
{{/* =============================================================== */}}

{{- define "contrail.cassandraConfig" -}}

[CASSANDRA]

{{- if not .commitLogDir -}}#{{- end -}}commitlog_dir = {{- .commitLogDir | default "/var/lib/cassandra/commitlog" -}}

{{- if not .dataDirs -}}#{{- end -}}data_dirs = {{- .dataDirs | default "/var/lib/cassandra/data" -}}

{{-  end -}}
