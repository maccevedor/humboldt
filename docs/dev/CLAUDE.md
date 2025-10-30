# Visor-I2D: Geographic Information System for Biodiversity Data

## 📋 Project Overview

**Visor-I2D** is a unified Geographic Information System (GIS) developed by the **Instituto Alexander von Humboldt Colombia** for visualizing, analyzing, and managing biodiversity data. The project consists of a complete development environment using Docker Compose that integrates both frontend and backend components as Git submodules.

### 🎯 Key Features
- **🗺️ Interactive Geographic Visualization**: Maps with OpenLayers for biodiversity data
- **📊 Data Analysis**: Visualization tools with AmCharts
- **🔍 Advanced Search**: Filters and queries for biological records
- **📱 Responsive Design**: Adaptive interface for different devices
- **🔒 User Management**: Authentication and permissions system
- **🌐 REST APIs**: Web services for system integration

---

## 🏗️ System Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    Docker Compose Environment               │
├─────────────────────────────────────────────────────────────┤
│  User → Nginx Proxy :80 → Frontend :8080 + Backend :8001   │
│                           ↓                                 │
│                    PostgreSQL + PostGIS :5432              │
│                           Redis Cache :6379                │
└─────────────────────────────────────────────────────────────┘
```

---

## 📁 Project Structure

```
humboldt/
├── 📄 README.md                    # Main project documentation
├── 📄 docker-compose.yml           # Docker services orchestration
├── 📄 .gitmodules                  # Git submodules configuration
├── 📁 scripts/                     # Database and setup scripts
├── 📁 nginx/                       # Nginx proxy configuration
├── 📁 datosgs/                     # Geographic data storage
├── 📁 visor-geografico-I2D/        # 🔗 Frontend Submodule
└── 📁 visor-geografico-I2D-backend/ # 🔗 Backend Submodule
```

---

## 🔗 Git Submodules

The project uses **two Git submodules** to manage the frontend and backend components independently:

### 1. 📱 Frontend Submodule: `visor-geografico-I2D`
- **Repository**: `https://github.com/maccevedor/visor-geografico-I2D.git`
- **Branch**: `main`
- **Technology Stack**:
  - **Node.js** 15.3.0
  - **HTML/JavaScript/SCSS**
  - **jQuery** 3.5.1
  - **Bootstrap** 4.5.3
  - **FontAwesome** 5.15.1
  - **OpenLayers** 6.5.0 (for maps)
  - **GeoServer** 2.11.2

#### Frontend Structure:
```
visor-geografico-I2D/
├── 📄 package.json              # Node.js dependencies
├── 📄 Dockerfile               # Frontend container config
├── 📁 src/
│   ├── 📄 index.html           # Main HTML entry point
│   ├── 📄 index.js             # JavaScript entry point
│   ├── 📁 components/          # UI components (45 items)
│   ├── 📁 assets/              # Static assets
│   └── 📁 scss/                # Stylesheets
├── 📁 build/                   # Production build output
└── 📁 dist/                    # Distribution files
```

### 2. ⚙️ Backend Submodule: `visor-geografico-I2D-backend`
- **Repository**: `https://github.com/maccevedor/visor-geografico-I2D-backend.git`
- **Branch**: `main`
- **Technology Stack**:
  - **Python** 3.9.2
  - **Django** 3.1.7 (web framework)
  - **Django REST Framework** (API development)
  - **PostgreSQL** with PostGIS (spatial database)
  - **psycopg2** (PostgreSQL adapter)
  - **Gunicorn** (WSGI server)

#### Backend Structure:
```
visor-geografico-I2D-backend/
├── 📄 manage.py                # Django management script
├── 📄 requirements.txt         # Python dependencies
├── 📄 dockerfile              # Backend container config
├── 📄 secret.json             # Configuration secrets
├── 📁 i2dbackend/             # Main Django project
│   ├── 📄 urls.py             # URL routing
│   ├── 📄 wsgi.py             # WSGI configuration
│   └── 📁 settings/           # Environment-specific settings
├── 📁 applications/           # Django apps
├── 📁 gbif/                   # GBIF data integration
├── 📁 media/                  # User-uploaded files
└── 📁 static/                 # Static assets
```

---

## 🐳 Docker Services

The `docker-compose.yml` orchestrates the following services:

1. **📊 Database (`db`)**:
   - PostgreSQL 16 Alpine
   - Container: `visor_i2d_db`
   - Port: 5432
   - Includes PostGIS for spatial data

2. **⚙️ Backend (`backend`)**:
   - Django application
   - Container: `visor_i2d_backend`
   - Port: 8001
   - Runs with Gunicorn (3 workers)

3. **📱 Frontend (`frontend`)**:
   - Node.js application
   - Port: 8080
   - Serves the geographic viewer interface

4. **🔄 Nginx Proxy**:
   - Reverse proxy
   - Port: 80
   - Routes traffic to frontend/backend

---

## 🚀 Development Workflow

### Prerequisites
- Docker 19.03.13+
- Docker Compose 1.28.5+
- Git 2.23+

### Quick Start
```bash
# Clone with submodules
git clone --recursive https://github.com/maccevedor/humboldt.git

# Start all services
docker-compose up -d

# Access the application
# Frontend: http://localhost:8080
# Backend API: http://localhost:8001
# Database: localhost:5432
```

### Submodule Management
```bash
# Initialize submodules
git submodule init
git submodule update

# Update submodules to latest
git submodule update --remote

# Work on a specific submodule
cd visor-geografico-I2D
git checkout main
# Make changes, commit, push

# Update parent repository
cd ..
git add visor-geografico-I2D
git commit -m "Update frontend submodule"
```

---

## 📚 Key Documentation Files

- **`README.md`**: Main project overview and setup instructions
- **`DOCKER_SETUP_README.md`**: Detailed Docker configuration guide
- **`GIT_SETUP_README.md`**: Git submodules management guide
- **`LEARNING_PLAN.md`**: Development learning path
- **`UPGRADE_STRATEGY.md`**: System upgrade methodology

---

## 🔧 Configuration Notes

Based on previous troubleshooting (from memories):
- **ALLOWED_HOSTS**: Backend configured for `'0.0.0.0'`, `'localhost'`, `'127.0.0.1'`
- **Docker Volumes**: Backend code mounted to `/project` (not `/app`)
- **API Endpoints**: Available at `/dpto`, `/mpio`, `/gbif`, `/admin`

---

## 🎯 Purpose & Use Cases

The Visor-I2D system serves as a comprehensive platform for:
- **Biodiversity Research**: Visualizing and analyzing biological records
- **Geographic Analysis**: Spatial data processing and mapping
- **Data Integration**: Connecting with GBIF and other biodiversity databases
- **Educational Tools**: Interactive exploration of Colombian biodiversity
- **Scientific Collaboration**: Sharing and accessing research data

This system represents a modern, scalable approach to biodiversity informatics, leveraging containerization and microservices architecture for reliable deployment and maintenance.

---

## 🔄 User Query Flow: Frontend to Backend

### Overview
The Visor-I2D system handles user queries through a well-structured flow from the frontend JavaScript components to the Django backend APIs, ultimately querying the PostgreSQL database with spatial data.

### 📱 Frontend Query Initiation

#### 1. **User Interface Components**
- **Search Input**: Located in `src/components/mapComponent/controls/search.js`
- **Map Interactions**: Click events and geographic selections
- **Chart Requests**: Data visualization triggers from sidebar components

#### 2. **Search Example Flow**
```javascript
// User types in search input (search.js)
$('#search-input').on('input', (e) => {
    clearTimeout(timeout);
    timeout = setTimeout(() => {
        let urlReq = 'mpio/search/' + e.target.value;
        pythonGetRequest(searchCallback, urlReq, 'No fue posible buscar la información')
    }, 10);
})
```

#### 3. **HTTP Request Handler**
- **File**: `src/components/server/pythonserver/pythonRequest.js`
- **Function**: `pythonGetRequest()` and `pythonPostRequest()`
- **Technology**: jQuery AJAX with cross-domain support

```javascript
export const pythonGetRequest = (handleData, param, error, errorCallback) => {
    $.ajax({
        url: PYTHONSERVER + param,
        type: "GET",
        crossDomain: true,
        success: function (data, status, xhr) {
            handleData(data);
        },
        error: function (jqXHR, exception) {
            $('.toast').toast('show');
            $('#toastBody').html(error)
            errorCallback && errorCallback()
        }
    });
}
```

#### 4. **API Endpoint Configuration**
- **File**: `src/components/server/url.js`
- **Backend URL**: `PYTHONSERVER = 'https://api-v1s0r.humboldt.org.co/'` (production) or `localhost:8001` (development)

### ⚙️ Backend Request Processing

#### 5. **URL Routing**
- **Main Router**: `i2dbackend/urls.py`
- **Application Routes**: Distributed across Django apps

```python
urlpatterns = [
    path('admin/', admin.site.urls),
    re_path('', include('applications.dpto.urls')),
    re_path('', include('applications.mupio.urls')),
    re_path('', include('applications.mupiopolitico.urls')),
    re_path('', include('applications.gbif.urls')),
    re_path('', include('applications.user.urls')),
]
```

#### 6. **Application-Specific Routing**
- **Municipality Queries**: `applications/mupio/urls.py`
- **GBIF Data**: `applications/gbif/urls.py`
- **Department Data**: `applications/dpto/urls.py`

```python
# Example: mupio/urls.py
urlpatterns = [
    path('api/mpio/charts/<kid>', views.mpioQuery.as_view()),
    path('api/mpio/dangerCharts/<kid>', views.mpioDanger.as_view())
]
```

#### 7. **View Processing**
- **Framework**: Django REST Framework (DRF)
- **View Type**: `ListAPIView` for data retrieval
- **Serialization**: Custom serializers for JSON response formatting

```python
# Example: mupio/views.py
class mpioQuery(ListAPIView):
    serializer_class = mpioQueriesSerializer

    def get_queryset(self):
        kid = self.kwargs['kid']
        return MpioQueries.objects.filter(codigo=kid).exclude(tipo__isnull=True).distinct('tipo')
```

### 🗄️ Database Layer

#### 8. **Model Definition**
- **ORM**: Django ORM with PostgreSQL backend
- **Spatial Support**: PostGIS for geographic data
- **Tables**: Pre-existing database views and tables

```python
# Example: mupio/models.py
class MpioQueries(models.Model):
    codigo = models.CharField(max_length=5, blank=True, null=True)
    tipo = models.TextField(blank=True, null=True)
    registers = models.BigIntegerField(blank=True, null=True)
    species = models.BigIntegerField(blank=True, null=True)
    exoticas = models.BigIntegerField(blank=True, null=True)
    endemicas = models.BigIntegerField(blank=True, null=True)
    geom = models.TextField(blank=True, null=True)
    nombre = models.CharField(max_length=254, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'mpio_queries'
```

#### 9. **Database Query Execution**
- **Database**: PostgreSQL 16 with PostGIS extension
- **Connection**: Through Django's database connection pool
- **Optimization**: Filtered queries with `.exclude()` and `.distinct()`

### 📤 Response Flow

#### 10. **Data Serialization**
- **Serializers**: Convert Django model instances to JSON
- **Format**: REST API standard JSON responses

```python
# Example: mupio/serializers.py
class mpioQueriesSerializer(serializers.ModelSerializer):
    class Meta:
        model = MpioQueries
        fields = '__all__'
```

#### 11. **HTTP Response**
- **Format**: JSON with appropriate HTTP status codes
- **Headers**: CORS-enabled for cross-origin requests
- **Error Handling**: Standardized error responses

#### 12. **Frontend Response Handling**
- **Success Callback**: Process and display data
- **Error Handling**: Toast notifications for user feedback
- **Data Integration**: Update maps, charts, and UI components

```javascript
// Example success callback
var searchCallback = (data) => {
    createDropdown('mpio', 'municipio', data);
}
```

### 🗺️ Specific Query Types

#### **Geographic Search Queries**
1. **Municipality Search**: `mpio/search/{query}` → Municipality dropdown results
2. **Department Data**: `dpto/charts/{id}` → Department biodiversity statistics
3. **GBIF Integration**: `gbif/gbifinfo` → Global biodiversity data

#### **Chart Data Queries**
1. **Biodiversity Charts**: Species counts, endemic species, exotic species
2. **Threat Analysis**: Endangered species data by region
3. **Temporal Data**: Download dates and data versioning

#### **Map Layer Queries**
1. **WMS Requests**: To GeoServer for map layer rendering
2. **WFS Requests**: For vector data and feature information
3. **Spatial Queries**: PostGIS-powered geographic intersections

### 🔧 Error Handling & Performance

#### **Frontend Error Management**
- Toast notifications for user-friendly error messages
- Timeout handling for slow network requests
- Input validation and debouncing

#### **Backend Error Management**
- Django's built-in exception handling
- Custom error responses for API endpoints
- Database connection error recovery

#### **Performance Optimizations**
- **Frontend**: Request debouncing (10ms delay on search input)
- **Backend**: Database query optimization with filters and exclusions
- **Caching**: Potential Redis integration for frequently accessed data
- **Connection Pooling**: Django's database connection management

This comprehensive query flow ensures efficient data retrieval and presentation while maintaining a responsive user experience across the biodiversity information system.


### 🔍 Detailed Flow Steps

#### **Frontend Layer (Steps 1-5)**
1. **User Interaction**: Search input, map click, or chart request
2. **Event Handler**: JavaScript event listeners capture user actions
3. **Debouncing**: 10ms timeout prevents excessive API calls
4. **AJAX Request**: jQuery sends HTTP request to backend
5. **URL Construction**: `PYTHONSERVER + endpoint + parameters`

#### **Network Layer (Step 6)**
6. **Docker Routing**: Request hits backend container on port 8001

#### **Backend Routing (Steps 7-9)**
7. **Django URL Dispatcher**: Main `urls.py` routes to appropriate app
8. **Application Router**: App-specific `urls.py` matches exact endpoint
9. **View Selection**: Maps to appropriate Django REST Framework view

#### **Business Logic (Steps 10-12)**
10. **View Processing**: `ListAPIView` or custom view handles request
11. **Query Construction**: Django ORM builds database query
12. **Parameter Filtering**: Apply filters, exclusions, and distinctions

#### **Data Layer (Steps 13-14)**
13. **Database Execution**: PostgreSQL + PostGIS processes spatial queries
14. **Result Set**: Raw data returned from database

#### **Response Processing (Steps 15-17)**
15. **Serialization**: Django serializers convert models to JSON
16. **HTTP Response**: Formatted JSON with appropriate status codes
17. **CORS Headers**: Cross-origin headers for frontend access


#### **Frontend Response (Steps 18-21)**
18. **AJAX Callback**: Success or error handler triggered
19. **Error Handling**: Toast notifications for failures
20. **UI Updates**: Dynamic updates to maps, charts, dropdowns
21. **User Feedback**: Visual confirmation of completed action

### � Performance Optimizations in Flow

- **⏱️ Debouncing**: Prevents API spam during typing
- **🔄 Connection Pooling**: Django manages database connections
- **📦 Lazy Loading**: Only load data when needed
- **🎯 Filtered Queries**: Reduce database load with specific filters
- **� Responsive UI**: Non-blocking AJAX for smooth user experience
