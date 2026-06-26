{{/*
============================================================
templates/_helpers.tpl
PURPOSE: Reusable template snippets
         Called from other templates using "include"
Files starting with _ are NOT rendered as manifests
They only contain helper definitions
============================================================
*/}}

{{/*
Expand the name of the chart.
Usage: {{ include "enterprise-platform.name" . }}
*/}}
{{- define "enterprise-platform.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}
{{/*
  default          → use Chart.Name if nameOverride empty
  trunc 63         → Kubernetes labels max 63 chars
  trimSuffix "-"   → remove trailing dash if truncated
*/}}

{{/*
Create a default fully qualified app name.
Usage: {{ include "enterprise-platform.fullname" . }}
*/}}
{{- define "enterprise-platform.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}
{{/*
  Result examples:
  helm install myapp ./chart → "myapp-enterprise-platform"
  helm install enterprise-platform ./chart → "enterprise-platform"
  (avoids doubling: enterprise-platform-enterprise-platform)
*/}}

{{/*
Common labels applied to ALL resources
Usage: {{ include "enterprise-platform.labels" . | indent 4 }}
*/}}
{{- define "enterprise-platform.labels" -}}
helm.sh/chart: {{ include "enterprise-platform.chart" . }}
{{ include "enterprise-platform.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
environment: {{ .Values.global.environment }}
project: {{ .Values.global.project }}
{{- end }}
{{/*
  helm.sh/chart: enterprise-platform-0.1.0
  app.kubernetes.io/name: enterprise-platform
  app.kubernetes.io/instance: myrelease
  app.kubernetes.io/version: "1.0.0"
  app.kubernetes.io/managed-by: Helm
  environment: dev
  project: enterprise-platform
*/}}

{{/*
Selector labels — used in matchLabels and Service selector
MUST be stable (never change after first deploy)
Changing these breaks rolling updates
*/}}
{{- define "enterprise-platform.selectorLabels" -}}
app.kubernetes.io/name: {{ include "enterprise-platform.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Chart name and version combined
*/}}
{{- define "enterprise-platform.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Service account name helper
*/}}
{{- define "enterprise-platform.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "enterprise-platform.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Image pull secret helper
*/}}
{{- define "enterprise-platform.imagePullSecrets" -}}
{{- with .Values.imagePullSecrets }}
imagePullSecrets:
  {{- toYaml . | nindent 2 }}
{{- end }}
{{- end }}