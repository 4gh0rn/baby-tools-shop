#!/bin/sh

# Change directory
cd /app/babyshop_app

# Apply database migrations
echo "Applying database migrations..."
python manage.py migrate

# Start server
echo "Starting server..."
gunicorn --bind 0.0.0.0:8025 babyshop.wsgi:application
