FROM python:3.10-slim

# TODO: Containerize the application
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

ENTRYPOINT ["python3", "main.py"]
