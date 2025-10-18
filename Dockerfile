# Base image
FROM python:3.13-alpine

# Set working directory
WORKDIR /app

# Copy requirements first for caching
COPY requirements.txt .

# Install dependencies
RUN pip install --upgrade pip
RUN pip install -r requirements.txt

# Copy all project files
COPY . .

# Run migrations during build
RUN python3 manage.py makemigrations
RUN python3 manage.py migrate

# Expose Django port
EXPOSE 8000

# Start Django server when container runs
CMD ["python3", "manage.py", "runserver", "0.0.0.0:8000"]
