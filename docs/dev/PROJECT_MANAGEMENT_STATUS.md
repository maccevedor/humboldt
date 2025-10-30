# Visor I2D - Project Management Implementation Status

## Current State Analysis

### Frontend Architecture
The current implementation uses hardcoded project logic in `/src/components/mapComponent/layers.js`:

**Current Project Detection:**
```javascript
var urlActual = window.location.href;
if (urlActual.includes("proyecto=ecoreservas")) {
    proyectos = 'ecoreservas';
    // Hardcoded configuration for ecoreservas
} else {
    proyectos = 'general';
    // Hardcoded configuration for general
}
```

**Hardcoded Project Configurations:**
1. **General Project:**
   - Zoom level: 6
   - Center coordinates: [-8113332, 464737]
   - Base map: OpenStreetMap visible
   - Layer groups: Historicos, Fondo de adaptación, Proyecto Oleoducto Bicentenario, etc.

2. **Ecoreservas Project:**
   - Zoom level: 9.2
   - Center coordinates: [-8249332, 544737]
   - Base map: CartoDB Positron visible
   - Layer groups: Preservación, Restauración, Uso Sostenible
   - Custom logos displayed

### Current Issues
1. **Code Modification Required:** Adding new projects requires code changes
2. **Hardcoded Layer Configuration:** All layer groups are defined in code
3. **Static Project Parameters:** Zoom, center, and base maps are hardcoded
4. **No Database Integration:** Project data is not stored in database

## Implementation Plan for HU-VisorI2D-0001

### Database Schema Design

#### Projects Table
- `id` (Primary Key, Auto-generated)
- `nombre_corto` (Short name for URL access)
- `nombre` (Full project name)
- `logo_pequeno_url` (Small logo URL)
- `logo_completo_url` (Complete logo URL)
- `nivel_zoom` (Default zoom level)
- `coordenada_central_x` (Center X coordinate)
- `coordenada_central_y` (Center Y coordinate)
- `panel_visible` (Panel visibility on startup)
- `created_at`, `updated_at`

#### Layer Groups Table
- `id` (Primary Key)
- `proyecto_id` (Foreign Key to Projects)
- `nombre` (Group name)
- `orden` (Display order)
- `fold_state` (open/close)
- `parent_group_id` (For subgroups, nullable)

#### Layers Table
- `id` (Primary Key)
- `grupo_id` (Foreign Key to Layer Groups)
- `nombre_geoserver` (GeoServer layer name)
- `nombre_display` (Display name in frontend)
- `store_geoserver` (GeoServer store name)
- `estado_inicial` (Initial visibility state)
- `metadata_id` (Metadata ID or external URL)
- `orden` (Display order within group)

#### Default Layers Table
- `id` (Primary Key)
- `proyecto_id` (Foreign Key to Projects)
- `layer_id` (Foreign Key to Layers)
- `visible_inicial` (Initial visibility)

### Backend API Endpoints

1. **GET /api/projects/** - List all projects
2. **GET /api/projects/{nombre_corto}/** - Get project by short name
3. **GET /api/projects/{id}/layer-groups/** - Get layer groups for project
4. **GET /api/projects/{id}/layers/** - Get all layers for project
5. **GET /api/projects/{id}/default-layers/** - Get default layers for project

### Frontend Implementation

#### Dynamic Project Loader
- Replace hardcoded logic with API calls
- Load project configuration from backend
- Dynamic layer group creation
- Dynamic map initialization

#### Project Configuration Service
```javascript
class ProjectService {
    async loadProject(projectName) {
        // Fetch project configuration from API
        // Return project object with layers, groups, settings
    }
    
    async initializeMap(projectConfig) {
        // Initialize map with dynamic configuration
        // Set zoom, center, base maps
        // Load layer groups dynamically
    }
}
```

### Testing Strategy

#### Unit Tests
- Project service functionality
- Dynamic layer loading
- Map initialization with different configurations
- URL parameter parsing

#### Integration Tests
- Full project loading workflow
- API endpoint responses
- Frontend-backend integration

#### Manual Testing
- Test existing projects (general, ecoreservas)
- Test new project creation
- Verify all layer functionalities work

## Migration Strategy

### Phase 1: Database Setup
1. Create new Django models for project management
2. Create migration scripts
3. Populate database with existing project data

### Phase 2: Backend API
1. Implement Django REST API endpoints
2. Add serializers for project data
3. Test API endpoints

### Phase 3: Frontend Refactoring
1. Create project service
2. Replace hardcoded logic with dynamic loading
3. Maintain backward compatibility

### Phase 4: Testing & Validation
1. Run comprehensive tests
2. Verify existing functionality
3. Performance testing

## Acceptance Criteria Verification

✅ **Project Fields:** All required fields identified and included in schema
✅ **Layer Groups:** Support for groups and subgroups
✅ **Layer Configuration:** All layer properties supported
✅ **Default Layers:** Relationship table for initial layer states
✅ **Dynamic Loading:** Map centers and loads configured layers
✅ **Layer Selection:** Panel updates with selected layer attributes
✅ **Panel Behavior:** Configurable panel visibility
✅ **No Code Changes:** New projects only require database entries

## Current Status: Ready for Implementation

The analysis is complete and the implementation plan is ready. The next steps are:
1. Create database models
2. Implement backend APIs
3. Refactor frontend for dynamic loading
4. Create comprehensive tests
