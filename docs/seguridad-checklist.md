
# Checklist de Seguridad (resumen)
- [x] S3 assets con versionado y cifrado
- [x] Bucket de logs para ALB
- [x] CloudTrail multi-región habilitado
- [x] GuardDuty habilitado
- [x] VPC Flow Logs habilitado (CW Logs)
- [ ] RDS con `storage_encrypted = true` (aplicado si se detectó el recurso)
- [ ] Redis con tránsito/descanso cifrado y `auth_token` (aplicado si se detectó el recurso)
- [ ] WAF (opcional, no incluido)
- [ ] SSM para EC2 (opcional, no incluido)
