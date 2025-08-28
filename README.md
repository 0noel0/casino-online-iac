# Desafío Técnico AWS – Casino Online

Este repositorio contiene la solución para el desafío técnico de diseño y aprovisionamiento de infraestructura en AWS para una operación de casino online. Incluye código **Terraform**, diagramas de arquitectura y archivos auxiliares para facilitar el despliegue y la documentación.

---

## **Arquitectura**

### **Región**
Toda la infraestructura está diseñada para la región **ca-central-1 (Canadá)**.

### **Componentes principales**
- **VPCs y Red**
  - VPC de aplicaciones (subredes públicas y privadas)
  - VPC de bodega de datos (Data Warehouse)
  - Conexión entre ambas mediante **VPC Peering**
- **Gateways**
  - Internet Gateway
  - NAT Gateway con Elastic IP
- **Balanceo de carga**
  - Application Load Balancer (ALB) con certificado en ACM
- **Servidores de aplicación (EC2)**
  - Frontsite, Backoffice, WebAPI y GameAPI desplegados en subredes privadas
- **Base de datos**
  - RDS Multi-AZ en VPC de bodega de datos
- **Cache**
  - Redis en ElastiCache para mejorar el rendimiento
- **Almacenamiento y CDN**
  - S3 para contenido estático
  - CloudFront con Origin Access Control (OAC)
- **Seguridad**
  - Grupos de seguridad segmentados por nivel (ALB, EC2, Redis, RDS)

---

## **Convención de nombres**
Todos los recursos siguen esta convención:
```
nombreRecurso-proyecto-operacion-num-region
```
Ejemplo:
- `ec2-casino-online-01-ca-central-1`
- `s3-casino-online-logs-01-ca-central-1`

---

## **Estructura del repositorio**
```
infra/
  main.tf
  variables.tf
  outputs.tf
  locals.naming.tf
  s3_extras.tf
  security_baseline.tf
  flowlogs.tf
  terraform.tfvars.example
  Makefile
  .pre-commit-config.yaml
  README.md
  /docs
    arquitectura_casino_online.svg
    arquitectura_casino_online.mmd
    costos.xlsx
    seguridad-checklist.md
```

---

## **Uso**

### **Requisitos previos**
- Terraform CLI >= 1.7
- Credenciales de AWS configuradas con permisos adecuados
- Certificado válido en ACM para el ALB

### **Comandos básicos**
```bash
make init
make plan
make apply
```
Para destruir el ambiente:
```bash
make destroy
```

---

## **Diagramas**
- **SVG vectorial**: `docs/arquitectura_casino_online.svg`
- **Mermaid** (renderiza en GitHub): `docs/arquitectura_casino_online.mmd`

---

## **Costos estimados**
En `docs/costos.xlsx` se detalla el desglose mensual estimado por:
- EC2
- RDS
- NAT Gateway
- S3
- CloudFront
- Redis
- ALB

---

## **Mejoras futuras**
- Autoescalado para EC2 y RDS
- WAF para ALB y CloudFront
- Alarmas y dashboards de CloudWatch
- Backup y Disaster Recovery automatizados

