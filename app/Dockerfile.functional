FROM python:3.7.4-alpine

WORKDIR /app
COPY ./requirements.txt requirements.txt
RUN pip install --no-cache-dir --upgrade -r requirements.txt
COPY . .

CMD ["gunicorn", "--log-level", "debug", "--bind", "0.0.0.0:8000", "api:app"]