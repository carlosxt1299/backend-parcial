# 🔧 Guía de Pruebas con Postman

Esta guía te ayudará a probar todos los endpoints del backend NestJS usando Postman.

## 📋 Configuración Inicial de Postman

### 1. Variables de Entorno
Crea las siguientes variables de entorno en Postman:

- `base_url` = `http://localhost:3000/api`
- `jwt_token` = (se llenará automáticamente después del login)

### 2. Headers Globales
Configura estos headers para todas las requests:
- `Content-Type: application/json`

## 🔐 Pruebas de Autenticación

### 1. Registro de Usuario
```
POST {{base_url}}/auth/register
Content-Type: application/json

{
  "email": "usuario@test.com",
  "password": "password123"
}
```

**Respuesta esperada (201):**
```json
{
  "accessToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "user": {
    "id": 1,
    "email": "usuario@test.com",
    "isActive": true,
    "createdAt": "2025-09-20T13:39:20.000Z"
  }
}
```

**Test Script (para guardar el token automáticamente):**
```javascript
if (pm.response.code === 201) {
    const response = pm.response.json();
    pm.environment.set("jwt_token", response.accessToken);
    console.log("Token JWT guardado:", response.accessToken);
}
```

### 2. Login de Usuario
```
POST {{base_url}}/auth/login
Content-Type: application/json

{
  "email": "usuario@test.com",
  "password": "password123"
}
```

**Respuesta esperada (200):**
```json
{
  "accessToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "user": {
    "id": 1,
    "email": "usuario@test.com",
    "isActive": true,
    "createdAt": "2025-09-20T13:39:20.000Z"
  }
}
```

**Test Script:**
```javascript
if (pm.response.code === 200) {
    const response = pm.response.json();
    pm.environment.set("jwt_token", response.accessToken);
    console.log("Login exitoso, token guardado");
}
```

### 3. Obtener Perfil de Usuario (Protegido)
```
GET {{base_url}}/auth/profile
Authorization: Bearer {{jwt_token}}
```

**Respuesta esperada (200):**
```json
{
  "id": 1,
  "email": "usuario@test.com",
  "isActive": true,
  "createdAt": "2025-09-20T13:39:20.000Z",
  "updatedAt": "2025-09-20T13:39:20.000Z",
  "tasks": []
}
```

## 📋 Pruebas de Tareas (CRUD)

**IMPORTANTE:** Todas las requests de tareas requieren el header:
`Authorization: Bearer {{jwt_token}}`

### 1. Crear Tarea
```
POST {{base_url}}/tasks
Authorization: Bearer {{jwt_token}}
Content-Type: application/json

{
  "title": "Completar documentación del proyecto",
  "description": "Escribir la documentación completa del backend NestJS con ejemplos de uso"
}
```

**Respuesta esperada (201):**
```json
{
  "id": 1,
  "title": "Completar documentación del proyecto",
  "description": "Escribir la documentación completa del backend NestJS con ejemplos de uso",
  "done": false,
  "createdAt": "2025-09-20T13:45:00.000Z",
  "updatedAt": "2025-09-20T13:45:00.000Z",
  "userId": 1
}
```

### 2. Crear Otra Tarea
```
POST {{base_url}}/tasks
Authorization: Bearer {{jwt_token}}
Content-Type: application/json

{
  "title": "Implementar frontend",
  "description": "Crear la interfaz de usuario con React"
}
```

### 3. Obtener Todas las Tareas
```
GET {{base_url}}/tasks
Authorization: Bearer {{jwt_token}}
```

**Respuesta esperada (200):**
```json
[
  {
    "id": 1,
    "title": "Completar documentación del proyecto",
    "description": "Escribir la documentación completa del backend NestJS con ejemplos de uso",
    "done": false,
    "createdAt": "2025-09-20T13:45:00.000Z",
    "updatedAt": "2025-09-20T13:45:00.000Z",
    "userId": 1
  },
  {
    "id": 2,
    "title": "Implementar frontend",
    "description": "Crear la interfaz de usuario con React",
    "done": false,
    "createdAt": "2025-09-20T13:46:00.000Z",
    "updatedAt": "2025-09-20T13:46:00.000Z",
    "userId": 1
  }
]
```

### 4. Obtener Tarea por ID
```
GET {{base_url}}/tasks/1
Authorization: Bearer {{jwt_token}}
```

**Respuesta esperada (200):**
```json
{
  "id": 1,
  "title": "Completar documentación del proyecto",
  "description": "Escribir la documentación completa del backend NestJS con ejemplos de uso",
  "done": false,
  "createdAt": "2025-09-20T13:45:00.000Z",
  "updatedAt": "2025-09-20T13:45:00.000Z",
  "userId": 1
}
```

### 5. Actualizar Tarea (Marcar como Completada)
```
PATCH {{base_url}}/tasks/1
Authorization: Bearer {{jwt_token}}
Content-Type: application/json

{
  "done": true,
  "title": "Documentación del proyecto COMPLETADA"
}
```

**Respuesta esperada (200):**
```json
{
  "id": 1,
  "title": "Documentación del proyecto COMPLETADA",
  "description": "Escribir la documentación completa del backend NestJS con ejemplos de uso",
  "done": true,
  "createdAt": "2025-09-20T13:45:00.000Z",
  "updatedAt": "2025-09-20T13:50:00.000Z",
  "userId": 1
}
```

### 6. Actualizar Solo Descripción
```
PATCH {{base_url}}/tasks/2
Authorization: Bearer {{jwt_token}}
Content-Type: application/json

{
  "description": "Crear la interfaz de usuario con React y TypeScript, incluyendo autenticación"
}
```

### 7. Eliminar Tarea
```
DELETE {{base_url}}/tasks/2
Authorization: Bearer {{jwt_token}}
```

**Respuesta esperada (204 No Content):**
Sin cuerpo de respuesta.

## ❌ Pruebas de Errores

### 1. Registro con Email Duplicado
```
POST {{base_url}}/auth/register
Content-Type: application/json

{
  "email": "usuario@test.com",
  "password": "password123"
}
```

**Respuesta esperada (409):**
```json
{
  "statusCode": 409,
  "message": "User with this email already exists"
}
```

### 2. Login con Credenciales Incorrectas
```
POST {{base_url}}/auth/login
Content-Type: application/json

{
  "email": "usuario@test.com",
  "password": "wrongpassword"
}
```

**Respuesta esperada (401):**
```json
{
  "statusCode": 401,
  "message": "Invalid credentials"
}
```

### 3. Acceder a Tarea Sin Token
```
GET {{base_url}}/tasks
```

**Respuesta esperada (401):**
```json
{
  "statusCode": 401,
  "message": "Unauthorized"
}
```

### 4. Crear Tarea Sin Título
```
POST {{base_url}}/tasks
Authorization: Bearer {{jwt_token}}
Content-Type: application/json

{
  "description": "Tarea sin título"
}
```

**Respuesta esperada (400):**
```json
{
  "statusCode": 400,
  "message": ["Title is required"],
  "error": "Bad Request"
}
```

### 5. Obtener Tarea Inexistente
```
GET {{base_url}}/tasks/999
Authorization: Bearer {{jwt_token}}
```

**Respuesta esperada (404):**
```json
{
  "statusCode": 404,
  "message": "Task with ID 999 not found"
}
```

### 6. Email con Formato Inválido
```
POST {{base_url}}/auth/register
Content-Type: application/json

{
  "email": "email-invalido",
  "password": "password123"
}
```

**Respuesta esperada (400):**
```json
{
  "statusCode": 400,
  "message": ["Please provide a valid email address"],
  "error": "Bad Request"
}
```

### 7. Contraseña Muy Corta
```
POST {{base_url}}/auth/register
Content-Type: application/json

{
  "email": "test2@example.com",
  "password": "123"
}
```

**Respuesta esperada (400):**
```json
{
  "statusCode": 400,
  "message": ["Password must be at least 6 characters long"],
  "error": "Bad Request"
}
```

## 🔧 Scripts de Automatización para Postman

### Script para Pre-request (Colección)
```javascript
// Verificar que el token existe para endpoints protegidos
const protectedEndpoints = ['/tasks', '/auth/profile'];
const currentUrl = pm.request.url.toString();

const isProtected = protectedEndpoints.some(endpoint => 
    currentUrl.includes(endpoint)
);

if (isProtected) {
    const token = pm.environment.get("jwt_token");
    if (!token) {
        console.log("⚠️ Token JWT requerido para este endpoint");
    }
}
```

### Script para Test (Colección)
```javascript
// Verificar códigos de respuesta exitosos
pm.test("Status code should be successful", function () {
    pm.expect(pm.response.code).to.be.oneOf([200, 201, 204]);
});

// Verificar tiempo de respuesta
pm.test("Response time is less than 1000ms", function () {
    pm.expect(pm.response.responseTime).to.be.below(1000);
});

// Verificar headers de respuesta
pm.test("Response has correct content type", function () {
    const contentType = pm.response.headers.get("Content-Type");
    if (pm.response.code !== 204) {
        pm.expect(contentType).to.include("application/json");
    }
});
```

## 📊 Flujo de Pruebas Recomendado

### Secuencia 1: Autenticación
1. **Registro** → Obtener token
2. **Login** → Verificar token
3. **Perfil** → Verificar datos del usuario

### Secuencia 2: CRUD Completo
1. **Crear tarea 1** → Verificar creación
2. **Crear tarea 2** → Verificar creación
3. **Listar tareas** → Verificar ambas tareas
4. **Obtener tarea 1** → Verificar datos específicos
5. **Actualizar tarea 1** → Verificar cambios
6. **Eliminar tarea 2** → Verificar eliminación
7. **Listar tareas** → Verificar que solo queda 1

### Secuencia 3: Validación de Errores
1. **Registro duplicado** → Error 409
2. **Login incorrecto** → Error 401
3. **Acceso sin token** → Error 401
4. **Datos inválidos** → Error 400
5. **Recurso inexistente** → Error 404

## 🎯 Tips para Pruebas Efectivas

1. **Usar Variables de Entorno** para URLs y tokens
2. **Automatizar la captura de tokens** con scripts
3. **Probar casos de éxito Y error**
4. **Verificar tiempos de respuesta**
5. **Validar estructura de respuestas**
6. **Probar aislamiento de usuarios** (un usuario no puede ver tareas de otro)

¡Con esta guía puedes probar completamente todas las funcionalidades del backend! 🚀
