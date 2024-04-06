# Etapa de construção
FROM python:3.7.4-alpine AS build

WORKDIR /app
COPY requirements.txt ./
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

COPY . .

FROM python:3.7.4-alpine

WORKDIR /app

COPY --from=build /app .

RUN pip install --no-cache-dir flask gunicorn
RUN adduser -D appuser
USER appuser

CMD ["gunicorn", "--log-level", "debug", "--bind", "0.0.0.0:8000", "api:app"]