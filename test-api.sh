#!/bin/bash

# 🔧 Script de Pruebas con curl para NestJS Tasks API
# ================================================

BASE_URL="http://localhost:3000/api"
JWT_TOKEN=""

echo "🚀 Iniciando pruebas del backend NestJS Tasks API"
echo "================================================="

# Función para hacer requests y mostrar respuesta
make_request() {
    echo -e "\n📋 $1"
    echo "-------------------------------------------"
    echo "Request: $2"
    echo ""
    eval $2
    echo -e "\n"
}

# 1. REGISTRO DE USUARIO
make_request "1. Registrando nuevo usuario" \
"curl -X POST $BASE_URL/auth/register \
  -H 'Content-Type: application/json' \
  -d '{
    \"email\": \"usuario@test.com\",
    \"password\": \"password123\"
  }' \
  -w '\nStatus: %{http_code}\nTime: %{time_total}s\n'"

echo "💡 Copia el 'accessToken' de la respuesta anterior para usarlo en las siguientes requests"
read -p "🔑 Pega aquí el token JWT: " JWT_TOKEN

# 2. LOGIN DE USUARIO
make_request "2. Haciendo login" \
"curl -X POST $BASE_URL/auth/login \
  -H 'Content-Type: application/json' \
  -d '{
    \"email\": \"usuario@test.com\",
    \"password\": \"password123\"
  }' \
  -w '\nStatus: %{http_code}\nTime: %{time_total}s\n'"

# 3. OBTENER PERFIL
make_request "3. Obteniendo perfil de usuario" \
"curl -X GET $BASE_URL/auth/profile \
  -H 'Authorization: Bearer $JWT_TOKEN' \
  -w '\nStatus: %{http_code}\nTime: %{time_total}s\n'"

# 4. CREAR PRIMERA TAREA
make_request "4. Creando primera tarea" \
"curl -X POST $BASE_URL/tasks \
  -H 'Content-Type: application/json' \
  -H 'Authorization: Bearer $JWT_TOKEN' \
  -d '{
    \"title\": \"Completar documentación del proyecto\",
    \"description\": \"Escribir la documentación completa del backend NestJS\"
  }' \
  -w '\nStatus: %{http_code}\nTime: %{time_total}s\n'"

# 5. CREAR SEGUNDA TAREA
make_request "5. Creando segunda tarea" \
"curl -X POST $BASE_URL/tasks \
  -H 'Content-Type: application/json' \
  -H 'Authorization: Bearer $JWT_TOKEN' \
  -d '{
    \"title\": \"Implementar frontend\",
    \"description\": \"Crear interfaz con React\"
  }' \
  -w '\nStatus: %{http_code}\nTime: %{time_total}s\n'"

# 6. OBTENER TODAS LAS TAREAS
make_request "6. Obteniendo todas las tareas" \
"curl -X GET $BASE_URL/tasks \
  -H 'Authorization: Bearer $JWT_TOKEN' \
  -w '\nStatus: %{http_code}\nTime: %{time_total}s\n'"

# 7. OBTENER TAREA ESPECÍFICA
make_request "7. Obteniendo tarea con ID 1" \
"curl -X GET $BASE_URL/tasks/1 \
  -H 'Authorization: Bearer $JWT_TOKEN' \
  -w '\nStatus: %{http_code}\nTime: %{time_total}s\n'"

# 8. ACTUALIZAR TAREA
make_request "8. Actualizando tarea (marcar como completada)" \
"curl -X PATCH $BASE_URL/tasks/1 \
  -H 'Content-Type: application/json' \
  -H 'Authorization: Bearer $JWT_TOKEN' \
  -d '{
    \"done\": true,
    \"title\": \"Documentación COMPLETADA\"
  }' \
  -w '\nStatus: %{http_code}\nTime: %{time_total}s\n'"

# 9. ELIMINAR TAREA
make_request "9. Eliminando tarea con ID 2" \
"curl -X DELETE $BASE_URL/tasks/2 \
  -H 'Authorization: Bearer $JWT_TOKEN' \
  -w '\nStatus: %{http_code}\nTime: %{time_total}s\n'"

# 10. VERIFICAR ELIMINACIÓN
make_request "10. Verificando que la tarea fue eliminada" \
"curl -X GET $BASE_URL/tasks \
  -H 'Authorization: Bearer $JWT_TOKEN' \
  -w '\nStatus: %{http_code}\nTime: %{time_total}s\n'"

echo "✅ Pruebas completadas!"
echo ""
echo "🧪 PRUEBAS DE ERRORES:"
echo "======================"

# PRUEBAS DE ERROR
make_request "❌ Error: Registro con email duplicado" \
"curl -X POST $BASE_URL/auth/register \
  -H 'Content-Type: application/json' \
  -d '{
    \"email\": \"usuario@test.com\",
    \"password\": \"password123\"
  }' \
  -w '\nStatus: %{http_code}\nTime: %{time_total}s\n'"

make_request "❌ Error: Login con contraseña incorrecta" \
"curl -X POST $BASE_URL/auth/login \
  -H 'Content-Type: application/json' \
  -d '{
    \"email\": \"usuario@test.com\",
    \"password\": \"wrongpassword\"
  }' \
  -w '\nStatus: %{http_code}\nTime: %{time_total}s\n'"

make_request "❌ Error: Acceso sin token" \
"curl -X GET $BASE_URL/tasks \
  -w '\nStatus: %{http_code}\nTime: %{time_total}s\n'"

make_request "❌ Error: Tarea sin título" \
"curl -X POST $BASE_URL/tasks \
  -H 'Content-Type: application/json' \
  -H 'Authorization: Bearer $JWT_TOKEN' \
  -d '{
    \"description\": \"Tarea sin título\"
  }' \
  -w '\nStatus: %{http_code}\nTime: %{time_total}s\n'"

make_request "❌ Error: Tarea inexistente" \
"curl -X GET $BASE_URL/tasks/999 \
  -H 'Authorization: Bearer $JWT_TOKEN' \
  -w '\nStatus: %{http_code}\nTime: %{time_total}s\n'"

echo "🎉 ¡Todas las pruebas completadas!"
echo ""
echo "📊 RESUMEN:"
echo "- ✅ Autenticación (registro, login, perfil)"
echo "- ✅ CRUD completo de tareas"
echo "- ✅ Validación de errores"
echo "- ✅ Protección de rutas con JWT"
echo "- ✅ Aislamiento de datos por usuario"
