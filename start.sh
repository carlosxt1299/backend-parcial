#!/bin/bash

echo "🐳 Starting NestJS Tasks API with Docker"
echo "========================================"

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo "❌ Docker is not running. Please start Docker first."
    exit 1
fi

# Function to start database only
start_db() {
    echo "📊 Starting PostgreSQL database..."
    docker-compose -f docker-compose.dev.yml up -d
    
    echo "⏳ Waiting for database to be ready..."
    sleep 10
    
    # Check if database is ready
    if docker exec tasks_postgres_dev pg_isready -U postgres -d tasks_db > /dev/null 2>&1; then
        echo "✅ Database is ready!"
        echo "📊 Database connection details:"
        echo "   Host: localhost"
        echo "   Port: 5432"
        echo "   Database: tasks_db"
        echo "   Username: postgres"
        echo "   Password: password"
    else
        echo "❌ Database failed to start properly"
        exit 1
    fi
}

# Function to start full stack
start_full() {
    echo "🚀 Starting full stack (Database + Backend)..."
    docker-compose up -d
    
    echo "⏳ Waiting for services to be ready..."
    sleep 15
    
    echo "✅ Services started!"
    echo "🌐 Backend API: http://localhost:3000/api"
    echo "📊 pgAdmin: http://localhost:8080 (admin@tasks.com / admin123)"
}

# Function to run migrations
run_migrations() {
    echo "🔄 Running database migrations..."
    npm run migration:run
    
    if [ $? -eq 0 ]; then
        echo "✅ Migrations completed successfully!"
    else
        echo "❌ Migration failed. Please check the database connection."
    fi
}

# Function to start development server
start_dev() {
    echo "🚀 Starting development server..."
    npm run start:dev
}

# Main menu
echo "Choose an option:"
echo "1) Start database only (recommended for development)"
echo "2) Start full stack (database + backend in Docker)"
echo "3) Start database and run migrations"
echo "4) Start database, run migrations, and start dev server"
echo "5) Stop all services"
echo "6) View logs"

read -p "Enter your choice (1-6): " choice

case $choice in
    1)
        start_db
        echo ""
        echo "🎯 Next steps:"
        echo "   1. Run migrations: npm run migration:run"
        echo "   2. Start dev server: npm run start:dev"
        ;;
    2)
        start_full
        ;;
    3)
        start_db
        echo ""
        run_migrations
        ;;
    4)
        start_db
        echo ""
        run_migrations
        echo ""
        start_dev
        ;;
    5)
        echo "🛑 Stopping all services..."
        docker-compose -f docker-compose.dev.yml down
        docker-compose down
        echo "✅ All services stopped!"
        ;;
    6)
        echo "📋 Showing logs..."
        docker-compose -f docker-compose.dev.yml logs -f
        ;;
    *)
        echo "❌ Invalid option. Please choose 1-6."
        exit 1
        ;;
esac
