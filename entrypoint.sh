#!/bin/sh

# Change directory
cd /app/babyshop_app

# Apply database migrations
echo "Applying database migrations..."
python manage.py migrate

# Start server
echo "Starting server..."
python manage.py runserver 0.0.0.0:8025
