FROM python:3.12-slim 

WORKDIR /app

COPY requirements.txt .

RUN apt-get update && apt-get install -y \
    gcc \
    g++ \
    libpq-dev \
    postgresql-client \
    && rm -rf /var/lib/apt/lists/*

RUN pip install --no-cache-dir -r requirements.txt

COPY . .

RUN useradd -m -u 1000 flaskuser && \
    chown -R flaskuser:flaskuser /app

USER flaskuser

EXPOSE 5000

CMD ["python", "app.py"]