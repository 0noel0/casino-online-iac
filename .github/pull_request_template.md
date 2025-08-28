## 📋 Descripción

Describe brevemente los cambios realizados en este PR.

## 🔄 Tipo de Cambio

¿Qué tipo de cambio introduce este PR? Marca con una `x` todas las opciones que apliquen:

- [ ] 🐛 Bug fix (cambio que corrige un issue)
- [ ] ✨ Nueva funcionalidad (cambio que agrega funcionalidad)
- [ ] 💥 Breaking change (fix o feature que causaría que funcionalidad existente no funcione como se espera)
- [ ] 📚 Documentación (cambios solo en documentación)
- [ ] 🎨 Estilo (formateo, espacios en blanco, etc; sin cambios de código)
- [ ] ♻️ Refactoring (cambio de código que no corrige bug ni agrega funcionalidad)
- [ ] ⚡ Performance (cambio que mejora el rendimiento)
- [ ] ✅ Test (agregar tests faltantes o corregir tests existentes)
- [ ] 🔧 Chore (cambios en el proceso de build o herramientas auxiliares)

## 🎯 Issues Relacionados

Este PR cierra/resuelve:
- Closes #(issue number)
- Fixes #(issue number)
- Resolves #(issue number)

## 🧪 Testing

Describe las pruebas que realizaste para verificar tus cambios:

- [ ] `terraform fmt` - Código formateado correctamente
- [ ] `terraform validate` - Configuración válida
- [ ] `terraform plan` - Plan ejecutado sin errores
- [ ] `terraform apply` - Aplicado exitosamente en entorno de prueba
- [ ] Tests manuales realizados
- [ ] Tests automatizados pasan

### 🖥️ Entorno de Testing

- **Terraform Version**: 
- **AWS Provider Version**: 
- **AWS Region**: 
- **Sistema Operativo**: 

## 📸 Screenshots (si aplica)

Agrega screenshots que muestren los cambios, especialmente para cambios en la UI o outputs.

## 📋 Checklist

Antes de enviar este PR, verifica que:

### 🔍 Código
- [ ] Mi código sigue las convenciones de estilo del proyecto
- [ ] He realizado una auto-revisión de mi código
- [ ] He comentado mi código, particularmente en áreas difíciles de entender
- [ ] He removido cualquier código comentado o debug
- [ ] No hay hardcoded secrets o información sensible

### 📚 Documentación
- [ ] He actualizado la documentación correspondiente
- [ ] He actualizado el CHANGELOG.md
- [ ] He actualizado variables.tf con descripciones apropiadas
- [ ] He actualizado outputs.tf si es necesario

### 🧪 Testing
- [ ] He agregado tests que prueban mi fix o funcionalidad
- [ ] Tests nuevos y existentes pasan localmente
- [ ] He verificado que no hay regresiones

### 🔒 Seguridad
- [ ] He considerado las implicaciones de seguridad de mis cambios
- [ ] He seguido las mejores prácticas de seguridad
- [ ] No he introducido nuevas vulnerabilidades

## 🔄 Cambios en la Infraestructura

¿Este PR introduce cambios que afectan la infraestructura existente?

- [ ] No, solo cambios de código/documentación
- [ ] Sí, pero son cambios compatibles hacia atrás
- [ ] Sí, y requieren migración/actualización manual
- [ ] Sí, y son breaking changes

### 📊 Plan de Terraform

<details>
<summary>Terraform Plan Output</summary>

```hcl
# Pega aquí el output de `terraform plan`
# ASEGÚRATE de remover cualquier información sensible
```

</details>

## 🚀 Deployment Notes

¿Hay algo especial que los reviewers/maintainers deban saber sobre el deployment?

- [ ] Requiere variables de entorno adicionales
- [ ] Requiere permisos AWS adicionales
- [ ] Requiere pasos manuales post-deployment
- [ ] Requiere coordinación con otros sistemas
- [ ] Otros: _especifica_

## 📝 Notas Adicionales

Agrega cualquier información adicional que pueda ser útil para los reviewers.

## 🤝 Reviewers

@mention a personas específicas que deberían revisar este PR

---

**Nota para Reviewers**: Por favor verifica que todos los items del checklist estén marcados antes de aprobar este PR.