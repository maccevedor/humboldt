# Plan de Aprendizaje - Visor-I2D
## Guía Completa para Aprender las Tecnologías del Stack

Este plan te guiará paso a paso para aprender todas las tecnologías utilizadas en el proyecto Visor-I2D, desde conceptos básicos hasta configuración avanzada.

---

## 📋 Prerrequisitos Generales

### Herramientas Básicas
- [X] **Git** - Control de versiones
- [X] **VS Code** o editor de código preferido
- [X] **Terminal/CMD** - Línea de comandos
- [X] **Navegador web** con herramientas de desarrollador

### Conocimientos Base Recomendados
- [X] HTML básico
- [X] CSS básico
- [X] JavaScript básico
- [X] Conceptos de programación orientada a objetos

---

## 🎯 FASE 1: Fundamentos Web y Herramientas

### Semana 1-2: Tecnologías Base

#### HTML5 y CSS3/SCSS
**Objetivos:**
- [ ] Entender la estructura semántica de HTML5
- [ ] Aprender CSS3 y preprocesadores SCSS
- [ ] Implementar diseño responsivo

**Recursos de Aprendizaje:**
- MDN Web Docs (HTML/CSS)
- Sass Documentation
- CSS Grid y Flexbox

**Práctica con el Proyecto:**
```bash
# Explorar la estructura HTML del proyecto
cd ./visor-geografico-I2D/src
code index.html

# Analizar los estilos SCSS
cd scss/
ls -la
code sizes.scss  # Revisar mixins responsivos
```

**Ejercicios:**
1. Modificar las variables de breakpoint en `sizes.scss`
2. Crear un nuevo mixin para móviles
3. Experimentar con los estilos existentes

#### JavaScript ES6+
**Objetivos:**
- [ ] Sintaxis moderna de JavaScript
- [ ] Promises y async/await
- [ ] Módulos ES6
- [ ] Manipulación del DOM

**Práctica con el Proyecto:**
```bash
# Explorar el JavaScript del proyecto
cd ./visor-geografico-I2D/src
code index.js
cd components/
ls -la  # Revisar componentes JavaScript
```

---

## 🛠️ FASE 2: Herramientas de Desarrollo Frontend

### Semana 3: Node.js y Gestión de Paquetes

#### Node.js y npm
**Objetivos:**
- [ ] Entender el ecosistema Node.js
- [ ] Gestión de dependencias con npm
- [ ] Scripts de npm

**Configuración Práctica:**
```bash
# Verificar instalación de Node.js
node --version  # Debe ser 15.3.0+
npm --version

# Clonar y configurar el proyecto frontend
# Run from project root directory
git clone https://github.com/PEM-Humboldt/visor-geografico-I2D.git
cd visor-geografico-I2D/

# Analizar dependencias
code package.json
npm install

# Ejecutar en modo desarrollo
npm start
```

#### Parcel Bundler
**Objetivos:**
- [ ] Entender qué es un bundler
- [ ] Configuración de Parcel
- [ ] Hot reload y desarrollo

**Práctica:**
```bash
# Explorar configuración de Parcel
npm run dev  # Modo desarrollo
npm run build  # Compilación para producción

# Analizar el bundle generadol
ls -la build/
```

---

## 🎨 FASE 3: Librerías Frontend Principales

### Semana 4-5: Frameworks CSS y UI

#### Bootstrap 4.5.3
**Objetivos:**
- [ ] Sistema de grid responsivo
- [ ] Componentes predefinidos
- [ ] Utilidades CSS

**Práctica con el Proyecto:**
```bash
# Buscar uso de Bootstrap en el proyecto
grep -r "bootstrap" src/
grep -r "col-" src/  # Buscar clases de grid
```

#### jQuery 3.5.1 y jQuery UI
**Objetivos:**
- [ ] Manipulación del DOM con jQuery
- [ ] Eventos y AJAX
- [ ] Componentes de jQuery UI

**Ejercicios:**
1. Identificar uso de jQuery en el proyecto
2. Crear un componente interactivo simple
3. Implementar una petición AJAX

### Semana 6-7: Mapas y Visualización

#### OpenLayers 6.5.0
**Objetivos:**
- [ ] Conceptos de mapas web
- [ ] Capas y fuentes de datos
- [ ] Controles e interacciones

**Configuración Práctica:**
```bash
# Explorar configuración de mapas
find src/ -name "*map*" -o -name "*layer*"
grep -r "ol\." src/  # Buscar uso de OpenLayers
```

**Ejercicios:**
1. Crear un mapa básico
2. Añadir una capa WMS
3. Implementar controles personalizados

#### AmCharts 4.10.15
**Objetivos:**
- [ ] Gráficos interactivos
- [ ] Configuración de datos
- [ ] Personalización visual

---

## 🐍 FASE 4: Backend con Python y Django

### Semana 8-9: Python y Entorno

#### Python 3.9.2
**Objetivos:**
- [ ] Sintaxis de Python
- [ ] Programación orientada a objetos
- [ ] Gestión de paquetes con pip

**Configuración del Entorno:**
```bash
# Verificar Python
python3 --version  # Debe ser 3.9.2+
pip3 --version

# Crear entorno virtual
# Run from project root directory
python3 -m venv venv-visor
source venv-visor/bin/activate

# Clonar proyecto backend
git clone https://github.com/PEM-Humboldt/visor-geografico-I2D-backend.git
cd visor-geografico-I2D-backend/

# Instalar dependencias
pip install -r requirements.txt
```

### Semana 10-12: Django Framework

#### Django 3.1.7
**Objetivos:**
- [ ] Arquitectura MVT (Model-View-Template)
- [ ] ORM de Django
- [ ] Sistema de URLs
- [ ] Administración

**Configuración Práctica:**
```bash
# Explorar estructura del proyecto Django
cd visor-geografico-I2D-backend/
tree -L 2

# Analizar configuración
cd i2dbackend/settings/
ls -la
code base.py  # Configuración base

# Explorar aplicaciones
cd ../../applications/
ls -la
```

**Ejercicios:**
1. Crear una nueva aplicación Django
2. Definir un modelo simple
3. Crear vistas y URLs

#### Django Rest Framework 3.12.2
**Objetivos:**
- [ ] APIs REST
- [ ] Serializadores
- [ ] ViewSets y Routers
- [ ] Autenticación

**Práctica:**
```bash
# Explorar APIs existentes
find applications/ -name "serializers.py"
find applications/ -name "views.py"
grep -r "APIView\|ViewSet" applications/
```

---

## 🗄️ FASE 5: Base de Datos y Servicios

### Semana 13: PostgreSQL y psycopg2

#### PostgreSQL 13
**Objetivos:**
- [ ] Conceptos de bases de datos relacionales
- [ ] SQL básico y avanzado
- [ ] Configuración y administración

**Configuración con Docker:**
```bash
# Levantar base de datos con Docker Compose
cd visor-geografico-I2D-backend/
docker-compose up db -d

# Conectar a la base de datos
docker exec -it visor-geografico-i2d-backend_db_1 psql -U i2d_user -d i2d_db
```

#### psycopg2 2.8.6
**Objetivos:**
- [ ] Conexión Python-PostgreSQL
- [ ] Manejo de transacciones
- [ ] Optimización de consultas

---

## 🐳 FASE 6: Containerización y Despliegue

### Semana 14-15: Docker y Docker Compose

#### Docker
**Objetivos:**
- [ ] Conceptos de contenedores
- [ ] Dockerfile
- [ ] Imágenes y volúmenes

**Práctica:**
```bash
# Frontend Docker
cd visor-geografico-I2D/
docker build -t visor-frontend .
docker run -p 8080:80 visor-frontend

# Backend Docker
cd ../visor-geografico-I2D-backend/
docker build -t visor-backend .
```

#### Docker Compose
**Objetivos:**
- [ ] Orquestación multi-contenedor
- [ ] Redes Docker
- [ ] Variables de entorno

**Configuración Completa:**
```bash
# Levantar todo el stack
cd visor-geografico-I2D-backend/
docker-compose up -d

# Verificar servicios
docker-compose ps
docker-compose logs web
```

---

## 🌐 FASE 7: Servicios Web y APIs

### Semana 16: Nginx y Gunicorn

#### Nginx
**Objetivos:**
- [ ] Servidor web y proxy reverso
- [ ] Configuración de virtual hosts
- [ ] Servir archivos estáticos

#### Gunicorn
**Objetivos:**
- [ ] Servidor WSGI
- [ ] Configuración de workers
- [ ] Monitoreo y logs

### Semana 17: Servicios Externos

#### GeoServer 2.11.2
**Objetivos:**
- [ ] Servidor de mapas
- [ ] Servicios WMS/WFS
- [ ] Configuración de capas

#### GBIF API
**Objetivos:**
- [ ] APIs de biodiversidad
- [ ] Integración de datos
- [ ] Manejo de grandes datasets

---

## 🔧 FASE 8: Herramientas de Desarrollo

### Semana 18: Calidad de Código

#### Herramientas Python
```bash
# Configurar herramientas de calidad
pip install pylint pylint-django isort

# Analizar código
pylint applications/gbif/
isort applications/gbif/models.py --check-only
```

#### Herramientas JavaScript
```bash
# Configurar ESLint y Prettier (opcional)
npm install --save-dev eslint prettier
```

---

## 🎯 PROYECTOS PRÁCTICOS

### Proyecto 1: Mini Visor de Mapas
**Objetivos:**
- Crear un visor básico con OpenLayers
- Conectar con una API simple
- Implementar controles básicos

### Proyecto 2: API de Biodiversidad
**Objetivos:**
- Crear una API REST con Django
- Conectar con PostgreSQL
- Implementar filtros y búsquedas

### Proyecto 3: Integración Completa
**Objetivos:**
- Conectar frontend y backend
- Implementar autenticación
- Desplegar con Docker

---

## 📚 Recursos Adicionales

### Documentación Oficial
- [Django Documentation](https://docs.djangoproject.com/)
- [Django Rest Framework](https://www.django-rest-framework.org/)
- [OpenLayers Documentation](https://openlayers.org/en/latest/doc/)
- [Bootstrap Documentation](https://getbootstrap.com/docs/4.5/)

### Cursos Recomendados
- Django for Beginners (William Vincent)
- JavaScript: The Definitive Guide
- OpenLayers Workshop

### Comunidades
- Django Discord/Slack
- OpenLayers GitHub Discussions
- Stack Overflow

---

## ✅ Lista de Verificación Final

### Frontend
- [ ] Proyecto funciona en desarrollo (`npm start`)
- [ ] Build de producción exitoso (`npm run build`)
- [ ] Mapas se cargan correctamente
- [ ] Componentes interactivos funcionan

### Backend
- [ ] Servidor Django ejecutándose
- [ ] Base de datos conectada
- [ ] APIs REST respondiendo
- [ ] Administración Django accesible

### Integración
- [ ] Frontend consume APIs del backend
- [ ] CORS configurado correctamente
- [ ] Docker Compose levanta todo el stack
- [ ] Datos de prueba cargados

### Despliegue
- [ ] Contenedores Docker funcionando
- [ ] Nginx sirviendo archivos estáticos
- [ ] Base de datos persistente
- [ ] Logs configurados

---

## 🚀 Próximos Pasos

Una vez completado este plan, estarás preparado para:
1. Contribuir al proyecto Visor-I2D
2. Desarrollar aplicaciones web geoespaciales
3. Crear APIs REST robustas
4. Implementar soluciones con contenedores
5. Trabajar con datos de biodiversidad

¡Buena suerte en tu aprendizaje! 🌱
