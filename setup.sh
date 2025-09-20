#!/bin/bash

echo "🚀 NestJS Tasks API Setup Script"
echo "================================="

# Check if .env file exists
if [ ! -f .env ]; then
    echo "📋 Creating .env file from template..."
    cp .env.example .env
    echo "✅ .env file created. Please update with your database credentials."
else
    echo "✅ .env file already exists."
fi

# Install dependencies
echo "📦 Installing dependencies..."
npm install

# Build the application
echo "🔨 Building the application..."
npm run build

echo ""
echo "🎉 Setup completed successfully!"
echo ""
echo "📝 Next steps:"
echo "1. Update your .env file with correct database credentials"
echo "2. Create the PostgreSQL database: CREATE DATABASE tasks_db;"
echo "3. Run migrations: npm run migration:run"
echo "4. Start the development server: npm run start:dev"
echo ""
echo "🌐 The API will be available at: http://localhost:3000/api"
echo ""
echo "📚 API Endpoints:"
echo "- POST /api/auth/register - Register new user"
echo "- POST /api/auth/login - Login user"
echo "- GET /api/auth/profile - Get user profile (protected)"
echo "- GET /api/tasks - Get all tasks (protected)"
echo "- POST /api/tasks - Create task (protected)"
echo "- GET /api/tasks/:id - Get task by ID (protected)"
echo "- PATCH /api/tasks/:id - Update task (protected)"
echo "- DELETE /api/tasks/:id - Delete task (protected)"
