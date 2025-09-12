FROM python:3.12.6-alpine

# Set working directory
WORKDIR /app

# Install system updates and clean up
RUN apt-get update && apt-get upgrade -y && apt-get install -y gcc libpq-dev && rm -rf /var/lib/apt/lists/*

# Copy requirements and install dependencies
COPY requirements.txt .
RUN pip install --upgrade pip && pip install --no-cache-dir -r requirements.txt

# Copy project files
COPY . .

# Expose Django port
EXPOSE 8000

# Run Django server
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
