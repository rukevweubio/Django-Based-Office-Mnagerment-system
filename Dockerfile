FROM python:3.12.6-alpine

# Set working directory
WORKDIR /app

# Install system updates and clean up
# Install system dependencies (Alpine uses apk, not apt-get)
RUN apk add --no-cache gcc musl-dev libffi-dev libpq-dev


# Copy requirements and install dependencies
COPY requirements.txt .
RUN pip install --upgrade pip && pip install --no-cache-dir -r requirements.txt

# Copy project files
COPY . .

# Expose Django port
EXPOSE 8000

# Run Django server
ENTRYPOINT ["python"]

CMD ["manage.py" , "runserver", "0.0.0.0:8000"]


