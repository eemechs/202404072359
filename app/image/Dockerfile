FROM python:3.7.4-alpine

WORKDIR /app

COPY requirements.txt ./

RUN pip install -r requirements.txt

COPY src/* /app

CMD ["gunicorn", "--log-level", "debug", "--bind", "0.0.0.0:8000", "api:app"]