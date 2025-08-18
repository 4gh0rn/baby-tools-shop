# Baby Tools Shop

Container Architecture & Deployment Guide

## Table of Contents
- [Quickstart](#quickstart)
- [Usage](#usage)
- [Environment Configuration](#environment-configuration)
- [Scripts](#scripts)

## Quickstart

### Prerequisites
- Docker
- Docker Compose
- Git

### Get Started

**1. Clone and navigate to the project**
```bash
git clone git@github.com:4gh0rn/baby-tools-shop.git
cd baby-tools-shop
```

**2. Copy environment file and edit with your settings**
```bash
cp .env.example .env
```

**3. Build and run**
```bash
docker-compose -f docker-compose.prod.yml up -d
```

Access your app: `http://<your-ip>:8025`

---

## Usage

### Container Architecture Overview

#### Dockerfile Structure
See [Dockerfile](./Dockerfile) for implementation.

**Key components:**
- Python 3.9-slim base image
- Automated startup with entrypoint script
- Port 8025 exposed

#### Alternative Setup (without Docker Compose)
```bash
docker build -t baby-tools-shop .
```
```bash
docker run -p 8025:8025 \
  -e DEBUG=False \
  -e SECRET_KEY=your-secret-key \
  -e ALLOWED_HOSTS=localhost,127.0.0.1,0.0.0.0 \
  baby-tools-shop
```

#### Docker Compose (Production)
See [docker-compose.prod.yml](./docker-compose.prod.yml) for configuration.

## Environment Configuration

### .env File Setup
```env
DEBUG=False
ALLOWED_HOSTS=localhost,127.0.0.1,0.0.0.0
SECRET_KEY=your-production-secret-key-here
```

## Scripts

### entrypoint.sh
See [entrypoint.sh](./entrypoint.sh) - handles migrations and server startup.

### build.sh
See [build.sh](./build.sh) - production deployment script.

## Quick Reference


# Production deployment
```bash
./build.sh
```
# Check status
```bash
docker-compose -f docker-compose.prod.yml ps
```
# View logs
```bash
docker-compose -f docker-compose.prod.yml logs -f
```
# Stop services
```bash
docker-compose -f docker-compose.prod.yml down
```