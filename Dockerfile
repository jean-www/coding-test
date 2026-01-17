FROM python:3.10-alpine

# TODO: Containerize the application
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

ENTRYPOINT ["python3", "main.py"]

# TODO: Remediation Lab with run as non-root
