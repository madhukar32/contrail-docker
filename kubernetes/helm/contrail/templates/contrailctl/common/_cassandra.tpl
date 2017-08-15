{{/* =============================================================== */}}
{{/* Cassandra config for contrailctl is formed using this template */}}
{{/* Below are the defined fields as part of this template */}}
{{/* 	- commitlog_dir */}}
{{/* 	- data_dirs */}}
{{/* =============================================================== */}}

{{- define "cassandraConfig" -}}

[CASSANDRA]

{{- if not .commitlog_dir -}}#{{- end -}}commitlog_dir = {{- .commitlog_dir | default "/var/lib/cassandra/commitlog" -}}

{{- if not .data_dirs -}}#{{- end -}}data_dirs = {{- .data_dirs | default "/var/lib/cassandra/data" -}}

{{-  end -}}
