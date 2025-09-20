# API Examples

This directory contains example requests for testing the API endpoints.

## Authentication Examples

### Register User
```bash
curl -X POST http://localhost:3000/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@example.com",
    "password": "password123"
  }'
```

### Login User
```bash
curl -X POST http://localhost:3000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@example.com",
    "password": "password123"
  }'
```

### Get User Profile (Protected)
```bash
curl -X GET http://localhost:3000/api/auth/profile \
  -H "Authorization: Bearer YOUR_JWT_TOKEN_HERE"
```

## Tasks Examples

### Create Task (Protected)
```bash
curl -X POST http://localhost:3000/api/tasks \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_JWT_TOKEN_HERE" \
  -d '{
    "title": "Complete project documentation",
    "description": "Write comprehensive README and API docs"
  }'
```

### Get All Tasks (Protected)
```bash
curl -X GET http://localhost:3000/api/tasks \
  -H "Authorization: Bearer YOUR_JWT_TOKEN_HERE"
```

### Get Task by ID (Protected)
```bash
curl -X GET http://localhost:3000/api/tasks/1 \
  -H "Authorization: Bearer YOUR_JWT_TOKEN_HERE"
```

### Update Task (Protected)
```bash
curl -X PATCH http://localhost:3000/api/tasks/1 \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_JWT_TOKEN_HERE" \
  -d '{
    "title": "Updated task title",
    "description": "Updated description",
    "done": true
  }'
```

### Delete Task (Protected)
```bash
curl -X DELETE http://localhost:3000/api/tasks/1 \
  -H "Authorization: Bearer YOUR_JWT_TOKEN_HERE"
```

## Testing Workflow

1. **Register a new user** using the register endpoint
2. **Login** with the user credentials to get a JWT token
3. **Use the JWT token** in the Authorization header for all protected endpoints
4. **Create, read, update, and delete tasks** using the tasks endpoints

## Error Examples

### Invalid Email Format
```json
{
  "statusCode": 400,
  "message": ["Please provide a valid email address"],
  "error": "Bad Request"
}
```

### Unauthorized Access
```json
{
  "statusCode": 401,
  "message": "Unauthorized"
}
```

### Task Not Found
```json
{
  "statusCode": 404,
  "message": "Task with ID 999 not found"
}
```

### Validation Error
```json
{
  "statusCode": 400,
  "message": [
    "Title is required",
    "Password must be at least 6 characters long"
  ],
  "error": "Bad Request"
}
```
