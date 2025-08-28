# Casino Online - Infraestructura como Código (IaC)

[![Terraform](https://img.shields.io/badge/Terraform-1.6.0-623CE4?style=flat&logo=terraform)](https://www.terraform.io/)
[![AWS](https://img.shields.io/badge/AWS-Cloud-FF9900?style=flat&logo=amazon-aws)](https://aws.amazon.com/)
[![License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

Infraestructura completa en AWS para una operación de casino online, implementada con **Terraform** siguiendo las mejores prácticas de seguridad, escalabilidad y mantenibilidad.

## Tabla de Contenidos

- [Arquitectura](#-arquitectura)
- [Requisitos Previos](#-requisitos-previos)
- [Instalación y Despliegue](#-instalación-y-despliegue)
- [Configuración](#-configuración)
- [Uso](#-uso)
- [Estructura del Proyecto](#-estructura-del-proyecto)
- [Seguridad](#-seguridad)
- [Licencia](#-licencia)

---

## Arquitectura

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

## Requisitos Previos

Antes de comenzar, asegúrate de tener instalado:

- [Terraform](https://www.terraform.io/downloads.html) >= 1.6.0
- [AWS CLI](https://aws.amazon.com/cli/) configurado con credenciales apropiadas
- Cuenta de AWS con permisos administrativos
- [Git](https://git-scm.com/) para clonar el repositorio
- [Make](https://www.gnu.org/software/make/) (opcional, para usar el Makefile)

### Permisos AWS Requeridos

Tu usuario/rol de AWS debe tener permisos para crear y gestionar:
- VPC, Subnets, Route Tables, Internet/NAT Gateways
- EC2 Instances, Security Groups, Load Balancers
- RDS Instances, ElastiCache
- S3 Buckets, CloudFront Distributions
- ACM Certificates, Route53 (si usas dominios propios)

---

## Instalación y Despliegue

### 1. Clonar el repositorio

```bash
git clone https://github.com/tu-usuario/casino-online-iac.git
cd casino-online-iac
```

### 2. Configurar variables

```bash
# Copiar el archivo de ejemplo
cp terraform.tfvars.example terraform.tfvars

# Editar con tus valores
vim terraform.tfvars
```

### 3. Inicializar Terraform

```bash
# Usando Make (recomendado)
make init

# O directamente con Terraform
terraform init
```

### 4. Planificar el despliegue

```bash
# Usando Make
make plan

# O directamente con Terraform
terraform plan
```

### 5. Aplicar la infraestructura

```bash
# Usando Make
make apply

# O directamente con Terraform
terraform apply
```

---

## Configuración

### Variables Requeridas

Edita el archivo `terraform.tfvars` con los siguientes valores:

```hcl
# Información del proyecto
project    = "promaketing"
operation  = "casino"
region     = "ca-central-1"
account_id = "123456789012"  # Tu AWS Account ID

# Dominios (opcional)
root_domain   = "tudominio.com"
app_domain    = "app.tudominio.com"
api_domain    = "api.tudominio.com"
assets_domain = "assets.tudominio.com"

# Certificados SSL (opcional)
acm_cert_arn_regional = "arn:aws:acm:ca-central-1:123456789012:certificate/..."
acm_cert_arn_cf      = "arn:aws:acm:us-east-1:123456789012:certificate/..."
```

### Variables de Entorno (CI/CD)

Para GitHub Actions, configura estos secrets:

- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`
- `AWS_ACCOUNT_ID`
- `ROOT_DOMAIN`
- `APP_DOMAIN`
- `API_DOMAIN`
- `ASSETS_DOMAIN`

---

## Uso

### Comandos Disponibles

```bash
# Formatear código Terraform
make fmt

# Validar configuración
make validate

# Ver plan de cambios
make plan

# Aplicar cambios
make apply

# Destruir infraestructura
make destroy
```

### Outputs Importantes

Después del despliegue, obtendrás:

- **ALB DNS Name**: Punto de entrada principal
- **RDS Endpoint**: Conexión a la base de datos
- **Redis Endpoints**: Cache endpoints
- **S3 Bucket**: Almacenamiento de assets
- **CloudFront Domain**: CDN para contenido estático

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

## Estructura del Proyecto

```
casino-online-iac/
├── .github/
│   └── workflows/
│       ├── terraform.yml      # CI/CD para Terraform
│       └── release.yml        # Workflow de releases
├── docs/
│   ├── arquitectura_casino_online.mmd
│   ├── arquitectura_casino_online.svg
│   ├── costos.xlsx
│   └── seguridad-checklist.md
├── main.tf                    # Recursos principales
├── variables.tf               # Definición de variables
├── outputs.tf                 # Outputs del módulo
├── locals.naming.tf           # Convenciones de nombres
├── security_baseline.tf       # Configuración de seguridad
├── flowlogs.tf               # Logs de flujo VPC
├── s3_extras.tf              # Configuración adicional S3
├── terraform.tfvars.example  # Ejemplo de variables
├── Makefile                  # Comandos automatizados
├── .gitignore               # Archivos ignorados por Git
├── CHANGELOG.md             # Historial de cambios
├── CONTRIBUTING.md          # Guía de contribución
├── LICENSE                  # Licencia del proyecto
├── SECURITY.md             # Política de seguridad
├── VERSION                 # Versión actual
└── README.md              # Este archivo
```

### Archivos Principales

- **`main.tf`**: Contiene todos los recursos de AWS (VPCs, EC2, RDS, etc.)
- **`variables.tf`**: Define todas las variables configurables
- **`outputs.tf`**: Expone información importante después del despliegue
- **`security_baseline.tf`**: Configuraciones de seguridad y compliance
- **`flowlogs.tf`**: Configuración de logs de flujo para auditoría

---

## Seguridad

Este proyecto implementa múltiples capas de seguridad:

- **Segmentación de red**: VPCs separadas para aplicaciones y datos
- **Subredes privadas**: Recursos críticos sin acceso directo a internet
- **Grupos de seguridad**: Reglas restrictivas por capa
- **Cifrado**: En tránsito y en reposo para todos los datos
- **Flow Logs**: Auditoría completa del tráfico de red
- **Origin Access Control**: Acceso seguro a S3 desde CloudFront

Para reportar vulnerabilidades de seguridad, por favor lee [SECURITY.md](SECURITY.md).

---

## Licencia

Este proyecto está licenciado bajo la Licencia MIT - ver el archivo [LICENSE](LICENSE) para más detalles.

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

