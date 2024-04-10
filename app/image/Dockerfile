FROM python:3.7.4-alpine@sha256:36903d9f7915ee7099d2eadea845e717d01a133354a088554abce4f2e6ca1c55

WORKDIR /app

COPY requirements.txt ./

RUN pip install -r requirements.txt

COPY src/* /app

CMD ["gunicorn", "--log-level", "debug", "--bind", "0.0.0.0:8000", "api:app"]