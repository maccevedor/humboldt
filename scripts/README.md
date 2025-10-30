# Scripts de Utilidad - Visor I2D

Este directorio contiene todos los scripts de utilidad para el proyecto Visor I2D.

## 📁 Estructura

```
scripts/
├── README.md                           # Este archivo
├── data_backups/                       # Backups de datos SQL
├── migrations/                         # Scripts de migración de datos
├── *.sh                                # Scripts de shell
├── *.sql                               # Scripts SQL
└── *.py                                # Scripts Python
```

---

## 🔧 Scripts de Shell (.sh)

### Configuración y Setup

#### `db-setup.sh`
**Propósito:** Configuración inicial de la base de datos  
**Uso:**
```bash
./scripts/db-setup.sh
```
**Descripción:**
- Crea esquemas de base de datos
- Inicializa PostGIS
- Configura permisos
- Carga datos iniciales

#### `git-setup.sh`
**Propósito:** Configuración de repositorios Git  
**Uso:**
```bash
./scripts/git-setup.sh
```
**Descripción:**
- Inicializa submódulos
- Configura ramas
- Establece upstream remotes

### Despliegue

#### `deploy.sh`
**Propósito:** Script de despliegue general  
**Uso:**
```bash
./scripts/deploy.sh [environment]
```
**Descripción:**
- Despliega la aplicación
- Ejecuta migraciones
- Reinicia servicios

#### `deploy-uat.sh`
**Propósito:** Despliegue específico para UAT  
**Uso:**
```bash
./scripts/deploy-uat.sh
```
**Descripción:**
- Despliega a ambiente UAT
- Usa configuración .env.uat
- Ejecuta verificaciones post-despliegue

### Testing

#### `run_backend_tests_docker.sh`
**Propósito:** Ejecutar tests del backend en Docker  
**Uso:**
```bash
./scripts/run_backend_tests_docker.sh
```
**Descripción:**
- Ejecuta suite de tests en contenedor
- Genera reportes de coverage
- Verifica integridad de APIs

#### `test_dynamic_projects.sh`
**Propósito:** Testing de sistema de proyectos dinámicos  
**Uso:**
```bash
./scripts/test_dynamic_projects.sh
```
**Descripción:**
- Verifica APIs de proyectos
- Prueba carga dinámica de capas
- Valida configuración de proyectos

### Mantenimiento

#### `fix_migration.sh`
**Propósito:** Corrección de problemas de migraciones  
**Uso:**
```bash
./scripts/fix_migration.sh
```
**Descripción:**
- Resuelve conflictos de migraciones
- Limpia migraciones huérfanas
- Sincroniza estado de base de datos

#### `user.sh`
**Propósito:** Gestión de usuarios  
**Uso:**
```bash
./scripts/user.sh [create|delete|list] [username]
```
**Descripción:**
- Crea usuarios de Django
- Gestiona permisos
- Lista usuarios existentes

---

## 🗄️ Scripts SQL (.sql)

### Inicialización

#### `init-db-schema.sql`
**Propósito:** Inicialización de esquemas de base de datos  
**Uso:**
```bash
psql -U i2d_user -d i2d_db -f scripts/init-db-schema.sql
```
**Descripción:**
- Crea esquemas: django, gbif_consultas, capas_base, geovisor
- Establece permisos
- Configura search_path

#### `init-postgis.sql`
**Propósito:** Inicialización de extensión PostGIS  
**Uso:**
```bash
psql -U i2d_user -d i2d_db -f scripts/init-postgis.sql
```
**Descripción:**
- Crea extensión PostGIS
- Configura funciones espaciales
- Verifica instalación

### Datos

#### `add_missing_general_layer_groups.sql`
**Propósito:** Agregar grupos de capas faltantes al proyecto general  
**Uso:**
```bash
psql -U i2d_user -d i2d_db -f scripts/add_missing_general_layer_groups.sql
```
**Descripción:**
- Inserta grupos de capas faltantes
- Actualiza jerarquías
- Corrige relaciones

#### `fix_ecoreservas_layer_names.sql`
**Propósito:** Corrección de nombres de capas de Ecoreservas  
**Uso:**
```bash
psql -U i2d_user -d i2d_db -f scripts/fix_ecoreservas_layer_names.sql
```
**Descripción:**
- Normaliza nombres de capas
- Actualiza metadatos
- Corrige inconsistencias

#### `update_ecoreservas_colors.sql`
**Propósito:** Actualización de colores de capas Ecoreservas  
**Uso:**
```bash
psql -U i2d_user -d i2d_db -f scripts/update_ecoreservas_colors.sql
```
**Descripción:**
- Actualiza esquema de colores
- Aplica paleta consistente
- Mejora visualización

---

## 🐍 Scripts Python (.py)

### Gestión de Capas

#### `add_missing_layers.py`
**Propósito:** Agregar capas faltantes a la base de datos  
**Uso:**
```bash
cd visor-geografico-I2D-backend
python ../scripts/add_missing_layers.py
```
**Descripción:**
- Detecta capas faltantes
- Inserta en base de datos
- Actualiza configuración

#### `create_ecoreservas_layers.py`
**Propósito:** Crear estructura completa de capas para proyecto Ecoreservas  
**Uso:**
```bash
cd visor-geografico-I2D-backend
python ../scripts/create_ecoreservas_layers.py
```
**Descripción:**
- Crea jerarquía de 3 niveles
- Configura grupos y subgrupos
- Inserta todas las capas de Ecoreservas

### Testing y Verificación

#### `test_django_gis.py`
**Propósito:** Testing completo de funcionalidad Django GIS  
**Uso:**
```bash
cd visor-geografico-I2D-backend
python ../scripts/test_django_gis.py
```
**Descripción:**
- Verifica configuración PostGIS
- Prueba operaciones espaciales
- Valida modelos GeoDjango

#### `verify_django_gis.py`
**Propósito:** Verificación rápida de Django GIS  
**Uso:**
```bash
cd visor-geografico-I2D-backend
python ../scripts/verify_django_gis.py
```
**Descripción:**
- Verifica conexión a PostGIS
- Comprueba extensiones
- Valida configuración básica

---

## 📦 Subdirectorios

### `data_backups/`

Contiene backups SQL de datos importantes:

- **default_layers_data.sql** - Backup de capas por defecto
- **layer_groups_data.sql** - Backup de grupos de capas
- **layers_data.sql** - Backup completo de capas
- **projects_data.sql** - Backup de proyectos

**Uso:**
```bash
psql -U i2d_user -d i2d_db -f scripts/data_backups/[archivo].sql
```

### `migrations/`

Scripts de migración de datos:

- **0002_restauracion_data_fix.py** - Corrección de datos de restauración

**Uso:**
```bash
cd visor-geografico-I2D-backend
python ../scripts/migrations/[script].py
```

---

## 🔒 Permisos

Asegúrate de que los scripts tengan permisos de ejecución:

```bash
chmod +x scripts/*.sh
```

---

## ⚠️ Notas Importantes

1. **Backups:** Siempre hacer backup antes de ejecutar scripts que modifiquen datos
2. **Ambiente:** Verificar que estás en el ambiente correcto (dev/uat/prod)
3. **Dependencias:** Algunos scripts requieren que Docker esté corriendo
4. **Orden:** Algunos scripts deben ejecutarse en orden específico (ej: init-db-schema.sql antes que init-postgis.sql)

---

## 📝 Convenciones

- Scripts de shell usan extensión `.sh`
- Scripts SQL usan extensión `.sql`
- Scripts Python usan extensión `.py`
- Nombres descriptivos en snake_case
- Comentarios en español
- Documentación inline en scripts complejos

---

## 🆘 Troubleshooting

### Error: Permission denied
```bash
chmod +x scripts/[script].sh
```

### Error: psql: command not found
Asegúrate de tener PostgreSQL client instalado o usa Docker:
```bash
docker-compose exec db psql -U i2d_user -d i2d_db -f /path/to/script.sql
```

### Error: Django settings not configured
Para scripts Python, asegúrate de estar en el directorio del backend:
```bash
cd visor-geografico-I2D-backend
python ../scripts/[script].py
```

---

## 🔗 Enlaces

- [Documentación Principal](../docs/INDEX.md)
- [README del Proyecto](../README.md)
- [Guías de Setup](../docs/setup/)

---

**Última actualización:** 2025-10-30
