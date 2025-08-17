# Baby Tools Shop

Here you can find the Container Architecture & Deployment Guide

## Quickstart

### Prerequisites
- Docker installed and running
- Docker Compose installed
- Git (to clone the repository)

### 1. Get Started in 30 Seconds
```bash
# Clone and navigate to project
git clone <your-repo-url>
cd baby-tools-shop

# Copy environment file and configure
cp .env.example .env
# Edit .env with your settings

# Build and run (Development)
docker build -t baby-tools-shop .
docker run -p 8025:8025 baby-tools-shop

# Access your app: http://localhost:8025
```

### 2. Production Deployment (One Command)
```bash
# Deploy everything with one script
./build.sh

# Check status
docker-compose -f docker-compose.prod.yml ps

# View logs
docker-compose -f docker-compose.prod.yml logs -f
```

### 3. Stop Everything
```bash
# Stop all services
docker-compose -f docker-compose.prod.yml down

# Remove containers and images (cleanup)
docker-compose -f docker-compose.prod.yml down --rmi all --volumes
```

---

## Container Architecture Overview

### Dockerfile Structure
```dockerfile
FROM python:3.11-slim

# Set working directory
WORKDIR /app

# Copy requirements, entrypoint and project files
COPY requirements.txt .
COPY entrypoint.sh .
COPY babyshop_app .

# Install Python dependencies
RUN pip install -r requirements.txt

# Change permissions
RUN chmod +x entrypoint.sh

# Expose port
EXPOSE 8025

# Set entrypoint
ENTRYPOINT ["./entrypoint.sh"]
```

**Why this structure?**
- **Security**: Minimal base image (slim)
- **Efficiency**: Explicit COPY commands for better control
- **Automation**: Entrypoint script handles startup logic

### Docker Compose (Production)
```yaml
services:
  web:                          # Django web application
    build: .                    # Build from current directory
    ports:
      - "8025:8025"            # Map host port 8025 to container port 8025
    env_file:
      - .env                    # Load environment variables from .env file
    restart: unless-stopped     # Auto-restart on failure
```

## Environment Configuration

### .env File Setup
```env
# Django Settings
DEBUG=False
ALLOWED_HOSTS=localhost,127.0.0.1,0.0.0.0
SECRET_KEY=your-production-secret-key-here

# Port Configuration
PORT=8025
```

**Benefits:**
- **Security**: No hardcoded values in code
- **Flexibility**: Different configurations for different environments
- **Container-friendly**: Environment variables can be set at runtime

## Scripts Explained

### 1. entrypoint.sh - Container Startup Script
```bash
#!/bin/sh

# Change directory
cd /app/babyshop_app          # Navigate to Django project directory

# Apply database migrations
echo "Applying database migrations..."
python manage.py migrate       # Run Django database migrations

# Start server
echo "Starting server..."
python manage.py runserver 0.0.0.0:8025  # Start Django development server
```

**What it does:**
- **Directory navigation**: Ensures we're in the right Django project folder
- **Database setup**: Automatically applies any pending migrations
- **Server startup**: Launches Django web server on port 8025
- **Binding**: `0.0.0.0` allows external connections to the container

**Why this approach?**
- **Automation**: No manual migration steps needed
- **Consistency**: Same startup process every time
- **Debugging**: Clear logging of startup steps
- **Flexibility**: Easy to modify startup behavior

### 2. build.sh - Deployment Script
```bash
#!/bin/sh

docker-compose -f docker-compose.prod.yml up -d
```

**What it does:**
- **Production deployment**: Uses production docker-compose configuration
- **Background execution**: `-d` flag runs services in detached mode
- **Service orchestration**: Starts web services
- **One-command deployment**: Simple script for production deployment

**Why this approach?**
- **Simplicity**: Single command to deploy entire application
- **Consistency**: Always uses production configuration
- **Automation**: Can be integrated into CI/CD pipelines
- **Documentation**: Clear deployment command for team members

## How Everything Works Together

### 1. Build Process
```bash
# Build the container image
docker build -t baby-tools-shop .

# What happens:
# 1. Downloads Python 3.11-slim base image
# 2. Sets working directory to /app
# 3. Installs Python dependencies
# 4. Copies project files
# 5. Makes entrypoint script executable
# 6. Exposes port 8025
```

### 2. Runtime Process
```bash
# Start the container
docker-compose -f docker-compose.prod.yml up -d

# What happens:
# 1. Container starts and executes /app/entrypoint.sh
# 2. Script changes to /app/babyshop_app directory
# 3. Runs database migrations automatically
# 4. Starts Django server on port 8025
# 5. Application becomes accessible at http://localhost:8025
```

### 3. Production Deployment
```bash
# Deploy with docker-compose
./build.sh

# What happens:
# 1. build.sh executes docker-compose command
# 2. Builds web service from Dockerfile
# 3. Loads environment variables from .env file
# 4. Starts web service with production settings
# 5. Sets up networking between containers
```

## Key Benefits of This Architecture

### **Development**
- **Consistent environment**: Same setup across all developers
- **Easy testing**: Isolated container environment
- **Quick iteration**: Fast rebuilds with layer caching

### **Production**
- **Service isolation**: Web in separate container
- **Scalability**: Easy to scale individual services
- **Environment management**: Flexible configuration via .env files

### **Maintenance**
- **Version control**: All configuration in code
- **Reproducibility**: Exact same environment every time
- **Rollback**: Easy to revert to previous versions

## Quick Reference Commands

```bash
# Development
docker-compose -f docker-compose.prod.yml up -d

# Production
./build.sh                                    # Deploy everything
docker-compose -f docker-compose.prod.yml ps  # Check status
docker-compose -f docker-compose.prod.yml logs -f  # View logs
docker-compose -f docker-compose.prod.yml down # Stop services

# Environment setup
cp .env.example .env                          # Create environment file
# Edit .env with your settings

# Debugging
docker exec -it <container_id> /bin/bash      # Enter container
docker logs <container_id>                    # View container logs
```