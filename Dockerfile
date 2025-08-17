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