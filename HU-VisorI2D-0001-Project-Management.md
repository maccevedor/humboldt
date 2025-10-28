# HU-VisorI2D-0001 - Gestión de Proyectos

## Descripción

Se debe tener una forma básica de gestionar proyectos en la plataforma, de manera que no se requiera hacer modificaciones de código cuando se desee agregar o modificar la información de un proyecto.

**Como:** Administrador  
**Quiero:** Gestionar los proyectos en la plataforma sin necesidad de modificar el código  
**Para:** Agilizar la incorporación y modificación de proyectos

## Estado del Desarrollo

✅ **COMPLETADO** - Sistema de gestión de proyectos dinámico completamente funcional

## Arquitectura Implementada

### Backend (Django REST API)

#### Modelos de Base de Datos

**1. Project (Proyecto)**
```python
class Project(models.Model):
    nombre_corto = models.CharField(max_length=50, unique=True)  # Para URL access
    nombre = models.CharField(max_length=200)                   # Nombre completo
    logo_pequeno_url = models.URLField(blank=True, null=True)   # Logo pequeño
    logo_completo_url = models.URLField(blank=True, null=True)  # Logo completo
    nivel_zoom = models.FloatField(default=6.0)                 # Nivel de zoom
    coordenada_central_x = models.FloatField()                  # Coordenada X central
    coordenada_central_y = models.FloatField()                  # Coordenada Y central
    panel_visible = models.BooleanField(default=True)           # Panel visible al inicio
    base_map_visible = models.CharField(max_length=50)          # Mapa base por defecto
```

**2. LayerGroup (Grupo de Capas)**
```python
class LayerGroup(models.Model):
    proyecto = models.ForeignKey(Project, related_name='layer_groups')
    nombre = models.CharField(max_length=200)
    orden = models.IntegerField(default=0)
    fold_state = models.CharField(choices=[('open', 'Open'), ('close', 'Close')])
    parent_group = models.ForeignKey('self', null=True, blank=True)  # Para subgrupos
```

**3. Layer (Capa)**
```python
class Layer(models.Model):
    grupo = models.ForeignKey(LayerGroup, related_name='layers')
    nombre_geoserver = models.CharField(max_length=200)      # Nombre en GeoServer
    nombre_display = models.CharField(max_length=200)       # Nombre para mostrar
    store_geoserver = models.CharField(max_length=200)      # Store de GeoServer
    estado_inicial = models.BooleanField(default=False)     # Visible al inicio
    metadata_id = models.CharField(max_length=500)          # ID de metadatos
    orden = models.IntegerField(default=0)                  # Orden de visualización
```

#### API Endpoints

| Endpoint | Método | Descripción |
|----------|--------|-------------|
| `/api/projects/` | GET | Lista todos los proyectos |
| `/api/projects/{id}/` | GET | Detalle de un proyecto específico |
| `/api/projects/by-name/{nombre_corto}/` | GET | Proyecto por nombre corto |
| `/api/projects/{id}/layer_groups/` | GET | Grupos de capas de un proyecto |
| `/api/projects/{id}/layers/` | GET | Todas las capas de un proyecto |

### Frontend (JavaScript/ES6)

#### ProjectService

**Funcionalidades principales:**
- Carga dinámica de proyectos desde API
- Cache de configuraciones de proyecto
- Fallback a configuración estática si API no disponible
- Manejo de parámetros URL (`?proyecto=nombre_corto`)

**Métodos clave:**
```javascript
// Cargar proyecto por nombre
await projectService.loadProject('general')

// Obtener configuración del mapa
const mapConfig = projectService.getMapConfig()

// Obtener capas inicialmente visibles
const visibleLayers = projectService.getInitiallyVisibleLayers()

// Obtener capas organizadas por grupos
const organizedLayers = projectService.getOrganizedLayers()
```

#### Integración con Map Component

**Refactorización de selectLayers:**
- ✅ Eliminadas condiciones hardcodeadas (`if projectType === 'general'`)
- ✅ Implementada selección dinámica basada en configuración de API

**Modelos Implementados:**
- `Project`: Configuración de proyectos (zoom, centro, logos, etc.)
- `LayerGroup`: Grupos jerárquicos de capas
- `Layer`: Capas individuales con configuración WMS

## Criterios de Aceptación

### ✅ Campos de Proyecto Implementados

- [x] **id** - Autogenerado por Django
- [x] **nombre_corto** - Para acceso desde URL
- [x] **nombre** - Nombre completo del proyecto
- [x] **logo_pequeno_url** - URL del logo pequeño
- [x] **logo_completo_url** - URL del logo completo
- [x] **nivel_zoom** - Nivel de zoom inicial
- [x] **coordenada_central_x/y** - Coordenadas del centro del mapa
- [x] **grupos_capas** - Relación con LayerGroup

### ✅ Campos de Grupo/Subgrupo Implementados

- [x] **nombre** - Nombre del grupo
- [x] **capas** - Relación con Layer
- [x] **subgrupo** - Relación jerárquica (parent_group)
- [x] **orden** - Orden de visualización
- [x] **fold_state** - Estado inicial (abierto/cerrado)

### ✅ Campos de Capa Implementados

- [x] **nombre_geoserver** - Nombre de la capa en GeoServer
- [x] **nombre_display** - Nombre para mostrar en frontend
- [x] **store_geoserver** - Store donde está alojada la capa
- [x] **estado_inicial** - Si aparece encendida/apagada al iniciar
- [x] **metadata_id** - ID del metadato asociado o URL externa
- [x] **orden** - Orden dentro del grupo

### ✅ Funcionalidades Frontend

- [x] **Carga centrada** - Mapa se centra en área del proyecto
- [x] **Capas por defecto** - Se cargan las capas configuradas
- [x] **Panel de capas** - Comportamiento configurable (visible/no visible)
- [x] **Selección de elementos** - Visualización en panel de capas seleccionadas
- [x] **Actualización de atributos** - Listado de atributos en panel lateral

## Ejemplo de Respuesta API

```json
{
    "id": 1,
    "nombre_corto": "general",
    "nombre": "Visor General I2D",
    "logo_pequeno_url": null,
    "logo_completo_url": null,
    "nivel_zoom": 6.0,
    "coordenada_central_x": -8113332.0,
    "coordenada_central_y": 464737.0,
    "panel_visible": true,
    "base_map_visible": "streetmap",
    "layer_groups": [
        {
            "id": 1,
            "nombre": "Historicos",
            "orden": 1,
            "fold_state": "close",
            "parent_group": null,
            "layers": [
                {
                    "id": 1,
                    "nombre_geoserver": "aicas",
                    "nombre_display": "AICAS",
                    "store_geoserver": "Historicos",
                    "estado_inicial": false,
                    "metadata_id": "09ee583d-d397-4eb8-99df-92bb6f0d0c4c",
                    "orden": 0
                }
            ],
            "subgroups": []
        }
    ],
    "created_at": "2025-08-28T09:56:44.724483Z",
    "updated_at": "2025-08-28T09:56:44.724501Z"
}
```

## Supuestos y Restricciones

### ✅ Implementados

- [x] **Sin interfaz gráfica** - Gestión directa en base de datos y GeoServer
- [x] **Capacidad del administrador** - Operaciones directas en DB y GeoServer
- [x] **Sin modificaciones de código** - Nuevos proyectos solo requieren datos en DB

### Flujo de Trabajo para Nuevos Proyectos

1. **Configurar en GeoServer:**
   - Crear workspace para el proyecto
   - Configurar datastores necesarios
   - Publicar capas con nombres específicos

2. **Configurar en Base de Datos:**
   ```sql
   -- Crear proyecto
   INSERT INTO projects (nombre_corto, nombre, nivel_zoom, coordenada_central_x, coordenada_central_y) 
   VALUES ('nuevo_proyecto', 'Nuevo Proyecto', 8.0, -8000000, 500000);
   
   -- Crear grupos de capas
   INSERT INTO layer_groups (proyecto_id, nombre, orden, fold_state) 
   VALUES (1, 'Grupo Principal', 1, 'close');
   
   -- Crear capas
   INSERT INTO layers (grupo_id, nombre_geoserver, nombre_display, store_geoserver, estado_inicial, orden)
   VALUES (1, 'capa_ejemplo', 'Capa de Ejemplo', 'store_ejemplo', false, 1);
   ```

3. **Acceso desde Frontend:**
   - URL: `http://localhost:8080/?proyecto=nuevo_proyecto`
   - El sistema carga automáticamente la configuración

## Archivos Modificados

### Backend
- `applications/projects/models.py` - Modelos de datos
- `applications/projects/views.py` - ViewSets y API endpoints
- `applications/projects/serializers.py` - Serializadores JSON
- `applications/projects/urls.py` - Rutas de API
- `applications/projects/admin.py` - Interfaz de administración Django

### Frontend
- `src/components/services/projectService.js` - Servicio de gestión de proyectos
- `src/components/mapComponent/map.js` - Integración con selección dinámica de capas
- `src/components/mapComponent/dynamicMap.js` - Soporte para proyectos dinámicos

## Testing y Verificación

### Comandos de Prueba

```bash
# Verificar API de proyectos
curl http://localhost:8001/api/projects/

# Obtener proyecto específico
curl http://localhost:8001/api/projects/by-name/general/

# Verificar grupos de capas
curl http://localhost:8001/api/projects/1/layer_groups/
```

### Casos de Prueba Frontend

1. **Carga proyecto general:** `http://localhost:8080/?proyecto=general`
2. **Carga proyecto ecoreservas:** `http://localhost:8080/?proyecto=ecoreservas`
3. **Fallback sin parámetro:** `http://localhost:8080/`
4. **Proyecto inexistente:** `http://localhost:8080/?proyecto=inexistente`

## Estado de Implementación

| Componente | Estado | Notas |
|------------|--------|-------|
| Modelos Backend | ✅ Completo | Todos los campos requeridos |
| API REST | ✅ Completo | Endpoints funcionales |
| ProjectService | ✅ Completo | Cache y fallbacks implementados |
| Integración Map | ✅ Completo | selectLayers refactorizado |
| Documentación | ✅ Completo | Guías y ejemplos |
| Testing | ✅ Completo | Casos de prueba verificados |

## Próximos Pasos Recomendados

1. **Interfaz de Administración Web** - Crear UI para gestión de proyectos
2. **Validaciones Avanzadas** - Verificar existencia de capas en GeoServer
3. **Import/Export** - Herramientas para migrar configuraciones
4. **Versionado** - Control de versiones de configuraciones de proyecto
5. **Monitoreo** - Logs y métricas de uso de proyectos

## Fixes Aplicados

### Layer Name Mismatch Fix (Agosto 2025)

**Problema Identificado:**
- Las capas WMS se solicitaban correctamente pero no se mostraban en el mapa
- La base de datos contenía nombres de capas incorrectos que no coincidían con GeoServer
- Ejemplo: DB tenía `Preservación_priorizando_todos_los_enfoques_Compensación` pero GeoServer tiene `Preservación_priorizando_todos_los_enfoques_Inversión_no_menos_1_`

**Solución Implementada:**
1. **SQL Fix Script:** `/scripts/fix_ecoreservas_layer_names.sql`
   - Actualiza nombres de capas en la base de datos para coincidir con GeoServer
   - Incluye verificación de cambios aplicados
   
2. **Python Import Fix:** `populate_projects.py`
   - Actualizado para usar nombres correctos de GeoServer desde el inicio
   - Previene futuros problemas de sincronización

**Capas Corregidas:**
- `Preservación_priorizando_todos_los_enfoques_Compensación` → `Preservación_priorizando_todos_los_enfoques_Inversión_no_menos_1_`
- `Preservación_priorizando_Costos_de_Oportunidad_Compensación` → `Preservación_priorizando_Costos_de_Oportunidad_Inversión_no_menos_1_`
- `Preservación_priorizando_Costos_Abióticos_Compensación` → `Preservación_priorizando_Costos_Abióticos_Inversión_no_menos_1_`

**Resultado:**
- ✅ Capas WMS ahora se renderizan correctamente en el mapa
- ✅ Requests WMS exitosos con nombres de capas válidos
- ✅ Sincronización completa entre base de datos y GeoServer

### Layer Configuration Fixes (Septiembre 1, 2025)

**Problema Identificado:**
- Frontend mostraba 9 grupos de capas (hardcodeados) pero API solo retornaba 4 grupos
- Capas GEF Páramos tenían workspace incorrecto (`Historicos` en lugar de `gefparamos`)
- Base de datos contenía capas que no existían en GeoServer

**Solución Implementada:**
1. **Agregados 6 grupos de capas faltantes:**
   - Capas Base, División político-administrativa, Proyecto Oleoducto Bicentenario
   - Gobernanza, Restauración, GEF Páramos

2. **Corregidas configuraciones de workspace:**
   - `paramo` layer: `Historicos` → `gefparamos`
   - `municipio` layer: `Historicos` → `gefparamos`

3. **Limpieza de base de datos:**
   - Removidas 8 capas no existentes en GeoServer
   - Removidos 4 grupos vacíos después de limpieza

**Scripts Utilizados:**
- `docs/add_missing_general_layer_groups.sql` - Script SQL para agregar grupos faltantes
- `docs/add_missing_layers.py` - Script Python Django ORM para gestión de capas
- `docs/layer_configuration_fixes.md` - Documentación completa de cambios

**Estado Final:**
- ✅ API retorna 5 grupos de capas válidos para proyecto general
- ✅ Todas las capas tienen workspace correcto en GeoServer
- ✅ Frontend carga dinámicamente sin fallback a capas hardcodeadas
- ✅ Requests WMS exitosos para todas las capas

---

**Fecha de Implementación:** Agosto-Septiembre 2025  
**Estado:** ✅ PRODUCCIÓN - Completamente funcional  
**Branch:** `manager_projects` - Todos los cambios committeados  
**Desarrollador:** Sistema de gestión dinámico de proyectos Visor I2D
