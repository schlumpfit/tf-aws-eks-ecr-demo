FROM python:3.10.10-slim-buster

COPY requirements.txt /tmp/requirements.txt
RUN pip install --no-cache-dir -r /tmp/requirements.txt

WORKDIR /app
COPY flask-app/ .

CMD ["flask", "--app", "app", "run", "--host", "0.0.0.0"]