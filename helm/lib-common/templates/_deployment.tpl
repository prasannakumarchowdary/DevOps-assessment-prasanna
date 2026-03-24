{{/*
Common deployment template.
Usage: {{ include "lib-common.deployment" . }}
*/}}
{{- define "lib-common.deployment" -}}
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ include "lib-common.fullname" . }}
  labels:
    {{- include "lib-common.labels" . | nindent 4 }}
spec:
  replicas: {{ .Values.replicaCount | default 1 }}
  selector:
    matchLabels:
      {{- include "lib-common.selectorLabels" . | nindent 6 }}
  template:
    metadata:
      labels:
        {{- include "lib-common.selectorLabels" . | nindent 8 }}
    spec:
      containers:
        - name: {{ .Chart.Name }}
          image: "{{ .Values.image.repository }}:{{ .Values.image.tag }}"
          imagePullPolicy: {{ .Values.image.pullPolicy | default "IfNotPresent" }}

          ports:
            - name: http
              containerPort: {{ .Values.service.targetPort | default 8080 }}
              protocol: TCP

          resources:
            limits:
              cpu: {{ .Values.resources.limits.cpu | quote }}
              memory: {{ .Values.resources.limits.memory | quote }}
            requests:
              cpu: {{ .Values.resources.requests.cpu | quote }}
              memory: {{ .Values.resources.requests.memory | quote }}

          livenessProbe:
            httpGet:
              path: {{ .Values.health.path }}
              port: {{ .Values.health.port }}
            initialDelaySeconds: 5
            periodSeconds: 10

          readinessProbe:
            httpGet:
              path: {{ .Values.health.path }}
              port: {{ .Values.health.port }}
            initialDelaySeconds: 5
            periodSeconds: 10
{{- end }}
