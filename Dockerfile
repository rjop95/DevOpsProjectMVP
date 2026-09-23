# Usamos una imagen oficial ligera de Python basada en Debian slim
FROM python:3.11-slim

# Evita que Python escriba archivos .pyc en disco y habilita logs en tiempo real
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Directorio de trabajo dentro del contenedor
WORKDIR /app

# Instalamos dependencias del sistema necesarias si fuera el caso
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Copiamos e instalamos los requerimientos de Python
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copiamos el resto del código de la aplicación al contenedor
COPY ./app /app/app

# SEGURIDAD: Creamos un usuario sin privilegios para no correr la app como root
RUN useradd -u 1000 appuser && chown -R appuser /app
USER appuser

# Exponemos el puerto en el que la aplicación escuchará
EXPOSE 8000

# Comando por defecto para ejecutar la aplicación
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]