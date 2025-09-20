-- init.sql - PostgreSQL initialization script
-- This script will be executed when the PostgreSQL container starts for the first time

-- Create the tasks database (if not exists)
CREATE DATABASE tasks_db;

-- Connect to tasks_db
\c tasks_db;

-- Create extensions if needed
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Set timezone
SET timezone = 'UTC';

-- Grant permissions to postgres user
GRANT ALL PRIVILEGES ON DATABASE tasks_db TO postgres;

-- Print success message
SELECT 'Database tasks_db initialized successfully!' as message;
