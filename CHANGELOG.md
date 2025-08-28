# Changelog

Todos los cambios notables de este proyecto serán documentados en este archivo.

El formato está basado en [Keep a Changelog](https://keepachangelog.com/es-ES/1.0.0/),
y este proyecto adhiere a [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Agregado
- Preparación para release público
- Documentación mejorada
- Workflows de CI/CD

## [1.0.1] - 2025-01-17

### Changed
- Deshabilitado deploy automático en GitHub Actions por seguridad
- Convertido a proyecto demo sin deployments automáticos
- Actualizado README con advertencias de modo demo
- Mantenida validación de Terraform sin ejecución real

### Security
- Eliminado riesgo de deployments accidentales en AWS
- Agregadas múltiples advertencias de seguridad

## [1.0.0] - 2024-01-17

### Agregado
- Infraestructura completa de AWS para casino online
- VPC principal para aplicaciones con subredes públicas y privadas
- VPC secundaria para Data Warehouse
- Conexión VPC Peering entre ambas VPCs
- Application Load Balancer (ALB) con certificado SSL
- Instancias EC2 para Frontsite, Backoffice, WebAPI y GameAPI
- Base de datos RDS MySQL Multi-AZ
- Cache Redis con ElastiCache
- Almacenamiento S3 para contenido estático
- CloudFront CDN con Origin Access Control (OAC)
- Grupos de seguridad segmentados por nivel
- Internet Gateway y NAT Gateway
- Configuración de rutas y tablas de enrutamiento
- Logs de flujo VPC (Flow Logs)
- Baseline de seguridad
- Convención de nombres consistente
- Documentación de arquitectura
- Diagramas de infraestructura
- Makefile para automatización
- Variables de configuración
- Outputs de recursos importantes

### Seguridad
- Implementación de grupos de seguridad restrictivos
- Configuración de subredes privadas para recursos sensibles
- Habilitación de cifrado en tránsito y en reposo
- Configuración de Origin Access Control para CloudFront
- Implementación de Flow Logs para auditoría

[Unreleased]: https://github.com/tu-usuario/casino-online-iac/compare/v1.0.0...HEAD
[1.0.0]: https://github.com/tu-usuario/casino-online-iac/releases/tag/v1.0.0