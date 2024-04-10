FROM python:3.7.4-alpine3.9@sha256:fd16c98a1809316497413e3fba99c8098e48071a93eb71bb9e6131eeca98b26a

WORKDIR /app

COPY requirements.txt ./

RUN pip install -r requirements.txt

COPY src/* /app

CMD ["gunicorn", "--log-level", "debug", "--bind", "0.0.0.0:8000", "api:app"]