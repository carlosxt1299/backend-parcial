# 🐳 Docker Setup Guide

Esta guía te ayudará a levantar el backend NestJS con PostgreSQL usando Docker.

## 📋 Requisitos Previos

- Docker y Docker Compose instalados
- Node.js 18+ (para desarrollo local)

## 🚀 Opciones de Despliegue

### Opción 1: Solo Base de Datos (Recomendado para Desarrollo)

```bash
# Levantar solo PostgreSQL
docker-compose -f docker-compose.dev.yml up -d

# Ejecutar migraciones
npm run migration:run

# Iniciar servidor de desarrollo
npm run start:dev
```

### Opción 2: Stack Completo (Base de datos + Backend)

```bash
# Levantar todo el stack
docker-compose up -d
```

### Opción 3: Script Automatizado

```bash
# Usar el script interactivo
./start.sh
```

## 🔧 Configuración de Base de Datos

### Credenciales por Defecto

```env
Host: localhost
Port: 5432
Database: tasks_db
Username: postgres
Password: password
```

### Variables de Entorno

El archivo `.env` ya está configurado con las credenciales correctas:

```env
DATABASE_HOST=localhost
DATABASE_PORT=5432
DATABASE_USERNAME=postgres
DATABASE_PASSWORD=password
DATABASE_NAME=tasks_db
```

## 📊 Servicios Disponibles

### PostgreSQL Database
- **Puerto:** 5432
- **Usuario:** postgres
- **Contraseña:** password
- **Base de datos:** tasks_db

### pgAdmin (Solo en stack completo)
- **URL:** http://localhost:8080
- **Email:** admin@tasks.com
- **Contraseña:** admin123

### Backend API (Solo en stack completo)
- **URL:** http://localhost:3000/api

## 🛠 Comandos Útiles

### Gestión de Contenedores

```bash
# Ver estado de los contenedores
docker-compose ps

# Ver logs
docker-compose logs -f

# Parar servicios
docker-compose down

# Parar y eliminar volúmenes
docker-compose down -v

# Reconstruir imágenes
docker-compose build --no-cache
```

### Base de Datos

```bash
# Conectar a PostgreSQL
docker exec -it tasks_postgres_dev psql -U postgres -d tasks_db

# Backup de la base de datos
docker exec tasks_postgres_dev pg_dump -U postgres tasks_db > backup.sql

# Restaurar backup
docker exec -i tasks_postgres_dev psql -U postgres tasks_db < backup.sql
```

### Migraciones

```bash
# Generar nueva migración
npm run migration:generate -- src/database/migrations/NewMigration

# Ejecutar migraciones
npm run migration:run

# Revertir última migración
npm run migration:revert
```

## 🔍 Verificación

### 1. Verificar que PostgreSQL está corriendo:

```bash
docker ps | grep postgres
```

### 2. Verificar conexión a la base de datos:

```bash
docker exec tasks_postgres_dev pg_isready -U postgres -d tasks_db
```

### 3. Verificar que el backend se conecta:

```bash
npm run start:dev
```

Deberías ver: `🚀 Application is running on: http://localhost:3000/api`

## 🐛 Resolución de Problemas

### Puerto 5432 ya en uso
```bash
# Ver qué proceso usa el puerto
sudo lsof -i :5432

# Parar PostgreSQL local si está corriendo
sudo systemctl stop postgresql
```

### Problemas de permisos con Docker
```bash
# Dar permisos al usuario actual
sudo usermod -aG docker $USER
newgrp docker
```

### Base de datos no se inicializa
```bash
# Eliminar volúmenes y recrear
docker-compose down -v
docker-compose up -d
```

### Error de conexión del backend
1. Verificar que PostgreSQL esté corriendo
2. Verificar credenciales en `.env`
3. Verificar que las migraciones se ejecutaron

## 📝 Estructura de Archivos Docker

```
backend/
├── docker-compose.yml          # Stack completo
├── docker-compose.dev.yml      # Solo base de datos
├── Dockerfile                  # Imagen del backend
├── init.sql                    # Script de inicialización de DB
├── start.sh                    # Script automatizado
└── .dockerignore              # Archivos a ignorar
```

## 🎯 Flujo de Desarrollo Recomendado

1. **Levantar base de datos:**
   ```bash
   docker-compose -f docker-compose.dev.yml up -d
   ```

2. **Ejecutar migraciones:**
   ```bash
   npm run migration:run
   ```

3. **Iniciar desarrollo:**
   ```bash
   npm run start:dev
   ```

4. **Desarrollar y probar** usando las APIs en `http://localhost:3000/api`

5. **Al terminar:**
   ```bash
   docker-compose -f docker-compose.dev.yml down
   ```

## 🚀 Despliegue a Producción

Para producción, usar el `docker-compose.yml` completo con variables de entorno de producción:

```bash
# Crear .env.production con credenciales seguras
cp .env.example .env.production

# Editar variables de producción
nano .env.production

# Desplegar
docker-compose --env-file .env.production up -d
```
