# 🤝 Guía de Contribución

¡Gracias por tu interés en contribuir a Casino Online Infrastructure! Este documento te guiará a través del proceso de contribución.

## 📋 Tabla de Contenidos

- [Código de Conducta](#código-de-conducta)
- [¿Cómo puedo contribuir?](#cómo-puedo-contribuir)
- [Configuración del entorno de desarrollo](#configuración-del-entorno-de-desarrollo)
- [Proceso de desarrollo](#proceso-de-desarrollo)
- [Estándares de código](#estándares-de-código)
- [Proceso de Pull Request](#proceso-de-pull-request)
- [Reportar bugs](#reportar-bugs)
- [Sugerir mejoras](#sugerir-mejoras)

## Código de Conducta

Este proyecto adhiere al [Contributor Covenant Code of Conduct](https://www.contributor-covenant.org/). Al participar, se espera que mantengas este código.

## ¿Cómo puedo contribuir?

### 🐛 Reportar Bugs

Antes de crear un reporte de bug:
- Verifica que no exista ya un issue similar
- Asegúrate de usar la versión más reciente
- Recopila información sobre tu entorno

### 💡 Sugerir Mejoras

- Usa el template de feature request
- Explica claramente el problema que resuelve
- Describe la solución propuesta
- Considera alternativas

### 🔧 Contribuir con Código

- Mejoras en la infraestructura
- Corrección de bugs
- Documentación
- Tests
- Optimizaciones de seguridad

## Configuración del entorno de desarrollo

### Requisitos

- Terraform >= 1.6.0
- AWS CLI configurado
- Git
- Make (opcional)
- Editor con soporte para Terraform (VS Code recomendado)

### Configuración inicial

```bash
# 1. Fork el repositorio en GitHub

# 2. Clonar tu fork
git clone https://github.com/tu-usuario/casino-online-iac.git
cd casino-online-iac

# 3. Agregar el repositorio original como upstream
git remote add upstream https://github.com/original-owner/casino-online-iac.git

# 4. Crear archivo de variables
cp terraform.tfvars.example terraform.tfvars
# Editar terraform.tfvars con tus valores

# 5. Inicializar Terraform
terraform init
```

### Extensiones recomendadas para VS Code

- HashiCorp Terraform
- AWS Toolkit
- GitLens
- Prettier

## Proceso de desarrollo

### 1. Crear una rama

```bash
# Actualizar main
git checkout main
git pull upstream main

# Crear nueva rama
git checkout -b feature/descripcion-corta
# o
git checkout -b fix/descripcion-del-bug
```

### 2. Realizar cambios

- Haz commits pequeños y frecuentes
- Usa mensajes de commit descriptivos
- Sigue las convenciones de código

### 3. Probar cambios

```bash
# Formatear código
make fmt

# Validar configuración
make validate

# Revisar plan
make plan
```

### 4. Commit y push

```bash
git add .
git commit -m "feat: descripción clara del cambio"
git push origin feature/descripcion-corta
```

## Estándares de código

### Terraform

- Usa `terraform fmt` para formatear el código
- Nombres de recursos en snake_case
- Agrupa recursos relacionados
- Usa variables para valores reutilizables
- Documenta variables complejas
- Usa locals para cálculos complejos

### Convenciones de nombres

Sigue la convención establecida:
```
nombreRecurso-proyecto-operacion-num-region
```

### Estructura de archivos

- `main.tf`: Recursos principales
- `variables.tf`: Definición de variables
- `outputs.tf`: Outputs del módulo
- `locals.tf`: Variables locales
- Archivos específicos por servicio cuando sea necesario

### Documentación

- Actualiza README.md si es necesario
- Documenta cambios en CHANGELOG.md
- Agrega comentarios para lógica compleja
- Usa descripciones claras en variables

## Proceso de Pull Request

### Antes de enviar

- [ ] El código está formateado (`terraform fmt`)
- [ ] La configuración es válida (`terraform validate`)
- [ ] El plan se ejecuta sin errores (`terraform plan`)
- [ ] Los tests pasan (si aplica)
- [ ] La documentación está actualizada
- [ ] CHANGELOG.md está actualizado

### Template de PR

Usa el template proporcionado e incluye:

- **Descripción**: Qué cambios realizaste y por qué
- **Tipo de cambio**: Feature, bugfix, docs, etc.
- **Testing**: Cómo probaste los cambios
- **Checklist**: Marca todos los items aplicables

### Proceso de revisión

1. **Revisión automática**: GitHub Actions ejecutará checks
2. **Revisión de código**: Un maintainer revisará tu código
3. **Feedback**: Responde a comentarios y realiza cambios si es necesario
4. **Aprobación**: Una vez aprobado, tu PR será merged

## Reportar bugs

Usa el template de bug report e incluye:

- **Descripción clara** del problema
- **Pasos para reproducir** el bug
- **Comportamiento esperado** vs actual
- **Información del entorno**:
  - Versión de Terraform
  - Versión de AWS CLI
  - Sistema operativo
  - Región de AWS
- **Logs relevantes** (sin información sensible)

## Sugerir mejoras

Para sugerir nuevas features:

- **Problema**: Describe el problema que resuelve
- **Solución**: Describe tu solución propuesta
- **Alternativas**: Considera otras opciones
- **Contexto adicional**: Screenshots, links, etc.

## Mensajes de commit

Usa [Conventional Commits](https://www.conventionalcommits.org/):

```
type(scope): description

[optional body]

[optional footer]
```

### Tipos:
- `feat`: Nueva funcionalidad
- `fix`: Corrección de bug
- `docs`: Cambios en documentación
- `style`: Formateo, espacios, etc.
- `refactor`: Refactoring de código
- `test`: Agregar o modificar tests
- `chore`: Tareas de mantenimiento

### Ejemplos:
```
feat(ec2): add auto-scaling configuration
fix(rds): resolve connection timeout issue
docs(readme): update installation instructions
```

## Versionado

Seguimos [Semantic Versioning](https://semver.org/):

- **MAJOR**: Cambios incompatibles
- **MINOR**: Nueva funcionalidad compatible
- **PATCH**: Correcciones compatibles

## Preguntas

¿Tienes preguntas? No dudes en:

- Abrir un [Issue](https://github.com/tu-usuario/casino-online-iac/issues)
- Iniciar una [Discusión](https://github.com/tu-usuario/casino-online-iac/discussions)
- Contactar a los maintainers

---

¡Gracias por contribuir! 🎉