# Remove Hardcoded Ecoreservas Items - Implementation Plan

## 📋 Overview

This document outlines the changes needed to remove the hardcoded "Ecoregión relacionada a las Ecoreservas Mancilla y Tocancipá" and "Ecoregión relacionada a la Ecoreserva San Antero" items from the frontend and make them dynamically generated through the Python API.

## 🎯 Identified Hardcoded Elements

### Current Hardcoded HTML Structure
The following hardcoded elements are currently generated in the frontend:

```html
<!-- Hardcoded Element 1: Cundinamarca Ecoreservas -->
<div class="card overflow-auto" id="combinedCapas_Cundi">
    <div class="card-header bg-info">
        <a class="btn btn-link" href="#" data-toggle="collapse" 
           aria-expanded="true" data-target="#combinedCollapse_combinedCapas_Cundi" 
           style="font-weight: bold; text-decoration: underline; font-style: italic;">
           Ecoregión relacionada a las Ecoreservas Mancilla y Tocancipá
        </a>
    </div>
    <div id="combinedCollapse_combinedCapas_Cundi" class="collapse">
        <!-- Sub-groups: Compensación, Inversión 1%, Inversión Voluntaria -->
    </div>
</div>

<!-- Hardcoded Element 2: San Antero Ecoreservas -->
<div class="card overflow-auto" id="combinedCapas_San">
    <div class="card-header bg-warning">
        <a class="btn btn-link" href="#" data-toggle="collapse" 
           aria-expanded="true" data-target="#combinedCollapse_combinedCapas_San" 
           style="font-weight: bold; text-decoration: underline; font-style: italic;">
           Ecoregión relacionada a la Ecoreserva San Antero
        </a>
    </div>
    <div id="combinedCollapse_combinedCapas_San" class="collapse">
        <!-- Sub-groups: Inversión 1%, Inversión Voluntaria -->
    </div>
</div>
```

## 🔍 Source Location

**File**: `humboldt/visor-geografico-I2D/src/components/mapComponent/controls/tree-layers.js`

**Lines**: 97-106

```javascript
// Line 100: Hardcoded Cundinamarca title
var combinedCardsCundi = createCombinedCards('Ecoregión relacionada a las Ecoreservas Mancilla y Tocancipá', 'combinedCapas_Cundi', 'bg-info');

// Line 103: Hardcoded San Antero title  
var combinedCardsSan = createCombinedCards('Ecoregión relacionada a la Ecoreserva San Antero', 'combinedCapas_San', 'bg-warning');
```

## 🛠️ Required Changes

### 1. Backend API Enhancement

#### 1.1 Create New Model for Ecoregion Groups
**File**: `humboldt/visor-geografico-I2D-backend/applications/projects/models.py`

Add a new model for ecoregion metadata:

```python
class EcoregionGroup(models.Model):
    """Model to store ecoregion group metadata for dynamic rendering"""
    
    proyecto = models.ForeignKey(Project, on_delete=models.CASCADE, related_name='ecoregion_groups')
    nombre = models.CharField(max_length=200, help_text="Ecoregion group name")
    nombre_corto = models.CharField(max_length=50, help_text="Short identifier")
    css_class = models.CharField(max_length=50, default='bg-info', help_text="CSS class for header")
    orden = models.PositiveIntegerField(default=0, help_text="Display order")
    activo = models.BooleanField(default=True)
    
    class Meta:
        ordering = ['orden', 'nombre']
        unique_together = ['proyecto', 'nombre_corto']
    
    def __str__(self):
        return f"{self.proyecto.nombre} - {self.nombre}"
```

#### 1.2 Update Project Serializer
**File**: `humboldt/visor-geografico-I2D-backend/applications/projects/serializers.py`

```python
class EcoregionGroupSerializer(serializers.ModelSerializer):
    class Meta:
        model = EcoregionGroup
        fields = ['id', 'nombre', 'nombre_corto', 'css_class', 'orden', 'activo']

class ProjectSerializer(serializers.ModelSerializer):
    layer_groups = LayerGroupSerializer(many=True, read_only=True)
    ecoregion_groups = EcoregionGroupSerializer(many=True, read_only=True)  # Add this line
    
    class Meta:
        model = Project
        fields = [
            'id', 'nombre', 'nombre_corto', 'nivel_zoom',
            'coordenada_central_x', 'coordenada_central_y',
            'panel_visible', 'base_map_visible',
            'layer_groups', 'ecoregion_groups'  # Add ecoregion_groups here
        ]
```

#### 1.3 Create Migration
**Command to run**:
```bash
docker-compose exec backend python manage.py makemigrations projects
docker-compose exec backend python manage.py migrate
```

#### 1.4 Populate Ecoregion Data
**File**: `humboldt/visor-geografico-I2D-backend/applications/projects/management/commands/populate_ecoregions.py`

```python
from django.core.management.base import BaseCommand
from applications.projects.models import Project, EcoregionGroup

class Command(BaseCommand):
    help = 'Populate ecoregion groups for ecoreservas project'
    
    def handle(self, *args, **options):
        try:
            ecoreservas_project = Project.objects.get(nombre_corto='ecoreservas')
            
            # Create ecoregion groups
            ecoregions = [
                {
                    'nombre': 'Ecoregión relacionada a las Ecoreservas Mancilla y Tocancipá',
                    'nombre_corto': 'mancilla_tocancipa',
                    'css_class': 'bg-info',
                    'orden': 1
                },
                {
                    'nombre': 'Ecoregión relacionada a la Ecoreserva San Antero',
                    'nombre_corto': 'san_antero',
                    'css_class': 'bg-warning',
                    'orden': 2
                }
            ]
            
            for eco_data in ecoregions:
                ecoregion, created = EcoregionGroup.objects.get_or_create(
                    proyecto=ecoreservas_project,
                    nombre_corto=eco_data['nombre_corto'],
                    defaults=eco_data
                )
                
                if created:
                    self.stdout.write(
                        self.style.SUCCESS(f'Created ecoregion: {ecoregion.nombre}')
                    )
                else:
                    self.stdout.write(f'Ecoregion already exists: {ecoregion.nombre}')
                    
        except Project.DoesNotExist:
            self.stdout.write(
                self.style.ERROR('Ecoreservas project not found. Run populate_projects first.')
            )
```

### 2. Frontend Changes

#### 2.1 Update Project Service
**File**: `humboldt/visor-geografico-I2D/src/components/services/projectService.js`

Add method to handle ecoregion groups:

```javascript
// Add this method to the projectService class
getEcoregionGroups() {
    if (this.currentProject && this.currentProject.ecoregion_groups) {
        return this.currentProject.ecoregion_groups.filter(group => group.activo);
    }
    return [];
}
```

#### 2.2 Refactor tree-layers.js
**File**: `humboldt/visor-geografico-I2D/src/components/mapComponent/controls/tree-layers.js`

Replace the hardcoded section (lines 97-106) with dynamic generation:

```javascript
// REMOVE these hardcoded lines (97-106):
/*
if (proyecto === 'ecoreservas') {
    // Define the group names
    var ggrupo = ['Compensación', 'Inversión 1%', 'Inversión Voluntaria'];
    var gggrupo = ['Inversión 1%', 'Inversión Voluntaria'];
    // Display the accordion
    accordion.className = 'd-block';

    // Create an element for Cundinamarca
    var combinedCardsCundi = createCombinedCards('Ecoregión relacionada a las Ecoreservas Mancilla y Tocancipá', 'combinedCapas_Cundi', 'bg-info');
    var combinedCollapsesCundi = combinedCardsCundi;
    // Create an element for San Antero
    var combinedCardsSan = createCombinedCards('Ecoregión relacionada a la Ecoreserva San Antero', 'combinedCapas_San', 'bg-warning');
    var combinedCollapsesSan = combinedCardsSan;
    // Extract the last three groups
    var lastThreeGroups = layers.slice(2, 14);
    var lastThreeGroupss = layers.slice(layers.length - 9);

    // Create combined cards for each group
    createCombinedCardsForGroups(ggrupo, combinedCardsCundi, combinedCollapsesCundi, lastThreeGroups, 0);
    createCombinedCardsForGroups(gggrupo, combinedCardsSan, combinedCollapsesSan, lastThreeGroupss, 1);
}
*/

// REPLACE with dynamic ecoregion generation:
if (proyecto === 'ecoreservas') {
    accordion.className = 'd-block';
    createDynamicEcoregions(layers);
}
```

#### 2.3 Add Dynamic Ecoregion Functions
**File**: `humboldt/visor-geografico-I2D/src/components/mapComponent/controls/tree-layers.js`

Add new functions at the end of the file:

```javascript
import projectService from '../../services/projectService';

// Add this function to create dynamic ecoregions
async function createDynamicEcoregions(layers) {
    try {
        const ecoregionGroups = projectService.getEcoregionGroups();
        
        if (!ecoregionGroups || ecoregionGroups.length === 0) {
            console.warn('No ecoregion groups found, falling back to static implementation');
            createStaticEcoregirons(layers); // Fallback
            return;
        }
        
        // Define group mappings (this could also come from API in the future)
        const groupMappings = {
            'mancilla_tocancipa': {
                groups: ['Compensación', 'Inversión 1%', 'Inversión Voluntaria'],
                layerSlice: layers.slice(2, 14)
            },
            'san_antero': {
                groups: ['Inversión 1%', 'Inversión Voluntaria'],
                layerSlice: layers.slice(layers.length - 9)
            }
        };
        
        // Create dynamic ecoregion cards
        ecoregionGroups.forEach((ecoregion, index) => {
            const mapping = groupMappings[ecoregion.nombre_corto];
            if (!mapping) {
                console.warn(`No mapping found for ecoregion: ${ecoregion.nombre_corto}`);
                return;
            }
            
            const ecoregionId = `combinedCapas_${ecoregion.nombre_corto}`;
            const combinedCard = createCombinedCards(
                ecoregion.nombre,
                ecoregionId,
                ecoregion.css_class
            );
            
            createCombinedCardsForGroups(
                mapping.groups,
                combinedCard,
                combinedCard,
                mapping.layerSlice,
                index
            );
        });
        
    } catch (error) {
        console.error('Error creating dynamic ecoregions:', error);
        createStaticEcoregirons(layers); // Fallback to static
    }
}

// Fallback function for static implementation
function createStaticEcoregirons(layers) {
    console.warn('Using static ecoregion implementation as fallback');
    
    // Define the group names
    var ggrupo = ['Compensación', 'Inversión 1%', 'Inversión Voluntaria'];
    var gggrupo = ['Inversión 1%', 'Inversión Voluntaria'];
    
    // Create an element for Cundinamarca
    var combinedCardsCundi = createCombinedCards(
        'Ecoregión relacionada a las Ecoreservas Mancilla y Tocancipá', 
        'combinedCapas_Cundi', 
        'bg-info'
    );
    var combinedCollapsesCundi = combinedCardsCundi;
    
    // Create an element for San Antero
    var combinedCardsSan = createCombinedCards(
        'Ecoregión relacionada a la Ecoreserva San Antero', 
        'combinedCapas_San', 
        'bg-warning'
    );
    var combinedCollapsesSan = combinedCardsSan;
    
    // Extract the last three groups
    var lastThreeGroups = layers.slice(2, 14);
    var lastThreeGroupss = layers.slice(layers.length - 9);

    // Create combined cards for each group
    createCombinedCardsForGroups(ggrupo, combinedCardsCundi, combinedCollapsesCundi, lastThreeGroups, 0);
    createCombinedCardsForGroups(gggrupo, combinedCardsSan, combinedCollapsesSan, lastThreeGroupss, 1);
}
```

## 🚀 Implementation Steps

### Step 1: Backend Updates
1. Add the `EcoregionGroup` model to `models.py`
2. Update the `ProjectSerializer` to include ecoregion groups
3. Create and run database migrations
4. Create the management command to populate ecoregion data
5. Run the command to populate initial data

### Step 2: Frontend Updates
1. Update `projectService.js` to handle ecoregion groups
2. Modify `tree-layers.js` to use dynamic ecoregion generation
3. Add fallback mechanisms for backward compatibility

### Step 3: Testing
1. Test that existing functionality still works
2. Verify ecoregion groups are loaded dynamically from API
3. Test fallback behavior when API data is unavailable

### Step 4: Data Migration (Optional)
If you want to make the ecoregion names editable through Django admin:
1. Add the `EcoregionGroup` model to admin interface
2. Create admin interface for easy editing

## 🔧 Commands to Execute

```bash
# 1. Create and run migrations
docker-compose exec backend python manage.py makemigrations projects
docker-compose exec backend python manage.py migrate

# 2. Populate ecoregion data
docker-compose exec backend python manage.py populate_ecoregions

# 3. Test the changes
docker-compose exec backend python manage.py test applications.projects

# 4. Restart services to apply changes
docker-compose restart frontend backend
```

## ✅ Verification Steps

1. **API Response Check**: Verify that `/api/projects/{id}/` includes `ecoregion_groups` in response
2. **Frontend Rendering**: Confirm that ecoregion titles are loaded dynamically
3. **Fallback Testing**: Temporarily break the API to ensure fallback works
4. **Admin Interface**: Check that ecoregions can be edited through Django admin

## 📝 Benefits After Implementation

- ✅ **No Hardcoded Strings**: All ecoregion titles managed through database
- ✅ **Editable Content**: Admin users can modify ecoregion names without code changes
- ✅ **Scalable**: Easy to add new ecoregions or modify existing ones
- ✅ **Consistent**: All project metadata managed through same API structure
- ✅ **Maintainable**: Changes don't require frontend code modifications

## 🎯 Future Enhancements

1. **Group Mappings**: Make the group-to-layer mappings configurable through API
2. **Internationalization**: Add multi-language support for ecoregion names
3. **User Permissions**: Add role-based access control for ecoregion management
4. **Audit Trail**: Track changes to ecoregion configurations

---

**Note**: This implementation maintains backward compatibility while transitioning to a fully dynamic system. The fallback mechanism ensures the system continues to work even if there are API issues.