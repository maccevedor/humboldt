# Visor I2D - Índice de Documentación

Este documento proporciona un índice completo de toda la documentación del proyecto Visor I2D.

## 📁 Estructura de Documentación

```
docs/
├── INDEX.md                    # Este archivo - índice principal
├── setup/                      # Guías de configuración inicial
├── guides/                     # Guías de uso y desarrollo
├── implementation/             # Documentación de implementaciones
├── reports/                    # Informes técnicos
├── dev/                        # Documentación de desarrollo
├── uat/                        # Documentación de UAT
└── prod/                       # Documentación de producción
```

---

## 🚀 Setup - Configuración Inicial

Documentación para configurar el proyecto por primera vez.

### [DOCKER_SETUP_README.md](./setup/DOCKER_SETUP_README.md)
**Propósito:** Guía completa para configurar el entorno Docker  
**Contenido:**
- Configuración de contenedores Docker
- Variables de entorno
- Comandos Docker Compose
- Troubleshooting de Docker

### [GIT_SETUP_README.md](./setup/GIT_SETUP_README.md)
**Propósito:** Configuración de repositorios Git y submódulos  
**Contenido:**
- Clonación del repositorio principal
- Inicialización de submódulos
- Configuración de ramas
- Workflow de Git

### [DJANGO_GIS_SETUP.md](./setup/DJANGO_GIS_SETUP.md)
**Propósito:** Configuración de Django GIS y PostGIS  
**Contenido:**
- Instalación de dependencias GIS
- Configuración de PostGIS
- Modelos GeoDjango
- Testing de funcionalidad GIS

### [CONFIGURATION_BEST_PRACTICES.md](./setup/CONFIGURATION_BEST_PRACTICES.md)
**Propósito:** Mejores prácticas de configuración  
**Contenido:**
- Gestión de variables de entorno
- Configuración por ambiente (dev/uat/prod)
- Seguridad y credenciales
- Optimización de rendimiento

---

## 📖 Guides - Guías de Uso

Guías prácticas para tareas comunes de desarrollo.

### [DJANGO_GIS_COMMANDS.md](./guides/DJANGO_GIS_COMMANDS.md)
**Propósito:** Comandos útiles de Django GIS  
**Contenido:**
- Comandos de gestión de Django
- Operaciones espaciales
- Consultas GIS
- Debugging

### [DJANGO_MIGRATIONS_GUIDE.md](./guides/DJANGO_MIGRATIONS_GUIDE.md)
**Propósito:** Guía completa de migraciones Django  
**Contenido:**
- Creación de migraciones
- Aplicación de migraciones
- Resolución de conflictos
- Rollback de migraciones

### [TESTING_INSTRUCTIONS.md](./guides/TESTING_INSTRUCTIONS.md)
**Propósito:** Instrucciones para testing  
**Contenido:**
- Ejecución de tests
- Tests unitarios
- Tests de integración
- Coverage

### [LEARNING_PLAN.md](./guides/LEARNING_PLAN.md)
**Propósito:** Plan de aprendizaje del proyecto  
**Contenido:**
- Arquitectura del sistema
- Stack tecnológico
- Recursos de aprendizaje
- Roadmap de conocimiento

---

## 🔧 Implementation - Implementaciones

Documentación de características implementadas.

### [DYNAMIC_PROJECT_IMPLEMENTATION_COMPLETE.md](./implementation/DYNAMIC_PROJECT_IMPLEMENTATION_COMPLETE.md)
**Propósito:** Implementación del sistema de proyectos dinámicos  
**Contenido:**
- Sistema de gestión de proyectos
- API de proyectos
- Frontend dinámico
- Integración completa

### [HIERARCHICAL_LAYERS_IMPLEMENTATION_SUMMARY.md](./implementation/HIERARCHICAL_LAYERS_IMPLEMENTATION_SUMMARY.md)
**Propósito:** Implementación de capas jerárquicas  
**Contenido:**
- Estructura de 3 niveles
- Grupos de capas
- Relaciones padre-hijo
- UI de árbol de capas

### [FINAL_IMPLEMENTATION_SUMMARY.md](./implementation/FINAL_IMPLEMENTATION_SUMMARY.md)
**Propósito:** Resumen de implementación final  
**Contenido:**
- Estado final del proyecto
- Características completadas
- Integración frontend-backend
- Verificación funcional

### [DEFAULTLAYER_REMOVAL_SUMMARY.md](./implementation/DEFAULTLAYER_REMOVAL_SUMMARY.md)
**Propósito:** Eliminación de capas por defecto hardcodeadas  
**Contenido:**
- Refactorización de código
- Migración a sistema dinámico
- Cambios en la base de datos

### [REMOVE_HARDCODED_ECORESERVAS.md](./implementation/REMOVE_HARDCODED_ECORESERVAS.md)
**Propósito:** Eliminación de lógica hardcodeada de Ecoreservas  
**Contenido:**
- Refactorización de proyecto Ecoreservas
- Sistema dinámico de proyectos
- Migración de datos

---

## 📊 Reports - Informes Técnicos

Informes técnicos detallados del proyecto.

### [INFORME_BACKEND_VISOR_I2D.md](./reports/INFORME_BACKEND_VISOR_I2D.md)
**Propósito:** Informe técnico del backend  
**Contenido:**
- Arquitectura backend
- APIs REST
- Base de datos
- Rendimiento

### [INFORME_FRONTEND_VISOR_I2D.md](./reports/INFORME_FRONTEND_VISOR_I2D.md)
**Propósito:** Informe técnico del frontend  
**Contenido:**
- Arquitectura frontend
- Componentes
- Integración con OpenLayers
- UI/UX

### [INFORME_TECNICO_CAMBIOS_VISOR_I2D.md](./reports/INFORME_TECNICO_CAMBIOS_VISOR_I2D.md)
**Propósito:** Informe técnico consolidado de cambios  
**Contenido:**
- Resumen de todos los cambios
- Mejoras implementadas
- Migración de sistemas
- Documentación completa

---

## 💻 Dev - Desarrollo

Documentación para desarrolladores.

### [CONSOLIDATED_PROJECT_SUMMARY.md](./dev/CONSOLIDATED_PROJECT_SUMMARY.md)
**Propósito:** Resumen consolidado del proyecto  
**Contenido:**
- Visión general del proyecto
- Componentes principales
- Estado actual
- Próximos pasos

### [PROJECT_MANAGEMENT_STATUS.md](./dev/PROJECT_MANAGEMENT_STATUS.md)
**Propósito:** Estado de gestión del proyecto  
**Contenido:**
- Tareas completadas
- Tareas pendientes
- Roadmap
- Prioridades

### [HU-VisorI2D-0001-Project-Management.md](./dev/HU-VisorI2D-0001-Project-Management.md)
**Propósito:** Historia de usuario - Gestión de proyectos  
**Contenido:**
- Requisitos
- Implementación
- Testing
- Aceptación

### [FRONTEND_PR_SUMMARY.md](./dev/FRONTEND_PR_SUMMARY.md)
**Propósito:** Resumen de Pull Request del frontend  
**Contenido:**
- Cambios en frontend
- Archivos modificados
- Testing realizado

### [PR_DESCRIPTION_FRONTEND.md](./dev/PR_DESCRIPTION_FRONTEND.md)
**Propósito:** Descripción detallada de PR frontend  
**Contenido:**
- Descripción de cambios
- Motivación
- Impacto
- Screenshots

### [UPGRADE_STRATEGY.md](./dev/UPGRADE_STRATEGY.md)
**Propósito:** Estrategia de actualización  
**Contenido:**
- Plan de actualización de dependencias
- Compatibilidad
- Riesgos
- Rollback

### [commit_info.md](./dev/commit_info.md)
**Propósito:** Información de commits importantes  
**Contenido:**
- Commits relevantes
- Cambios significativos
- Referencias

### [CLAUDE.md](./dev/CLAUDE.md)
**Propósito:** Documentación para asistente AI  
**Contenido:**
- Estructura del proyecto
- Contexto técnico
- Convenciones
- Información útil para AI

---

## 🧪 UAT - User Acceptance Testing

Documentación para ambiente de UAT.

### [QUICK_START_UAT.md](./uat/QUICK_START_UAT.md)
**Propósito:** Inicio rápido en UAT  
**Contenido:**
- Configuración rápida
- Comandos básicos
- Verificación

### [UAT_DEPLOYMENT_GUIDE.md](./uat/UAT_DEPLOYMENT_GUIDE.md)
**Propósito:** Guía de despliegue en UAT  
**Contenido:**
- Proceso de despliegue
- Configuración de ambiente
- Verificación post-despliegue

### [UAT_SETUP_SUMMARY.md](./uat/UAT_SETUP_SUMMARY.md)
**Propósito:** Resumen de configuración UAT  
**Contenido:**
- Configuración completa
- Variables de entorno
- Servicios

---

## 🏭 Prod - Producción

Documentación para ambiente de producción.

*(Actualmente vacío - agregar documentación de producción aquí)*

---

## 🛠️ Scripts

Los scripts de utilidad se encuentran en `/scripts/`:

### Scripts de Shell
- **db-setup.sh** - Configuración inicial de base de datos
- **deploy-uat.sh** - Despliegue a UAT
- **deploy.sh** - Despliegue general
- **fix_migration.sh** - Corrección de migraciones
- **git-setup.sh** - Configuración de Git
- **run_backend_tests_docker.sh** - Ejecución de tests en Docker
- **test_dynamic_projects.sh** - Testing de proyectos dinámicos
- **user.sh** - Gestión de usuarios

### Scripts SQL
- **add_missing_general_layer_groups.sql** - Agregar grupos de capas faltantes
- **fix_ecoreservas_layer_names.sql** - Corrección de nombres de capas
- **init-db-schema.sql** - Inicialización de esquema
- **init-postgis.sql** - Inicialización de PostGIS
- **update_ecoreservas_colors.sql** - Actualización de colores

### Scripts Python
- **add_missing_layers.py** - Agregar capas faltantes
- **create_ecoreservas_layers.py** - Crear capas de Ecoreservas
- **test_django_gis.py** - Testing de Django GIS
- **verify_django_gis.py** - Verificación de Django GIS

---

## 📝 Notas

- Toda la documentación está en formato Markdown
- Los scripts están organizados por tipo (shell, SQL, Python)
- La documentación se actualiza continuamente
- Para contribuir, seguir las convenciones establecidas

---

## 🔗 Enlaces Útiles

- [README Principal](../README.md)
- [Repositorio Frontend](https://github.com/maccevedor/visor-geografico-I2D)
- [Repositorio Backend](https://github.com/maccevedor/visor-geografico-I2D-backend)

---

**Última actualización:** 2025-10-30
