FROM python:3.9-slim

# Set working directory
WORKDIR /app

# Copy requirements, entrypoint and project files
COPY requirements.txt entrypoint.sh babyshop_app .

# Install Python dependencies
RUN pip install -r requirements.txt

# Change permissions
RUN chmod +x entrypoint.sh

# Expose port
EXPOSE 8025

# Set entrypoint
ENTRYPOINT ["./entrypoint.sh"]