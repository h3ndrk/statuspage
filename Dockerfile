FROM python:3

WORKDIR /app

COPY server.py /app
COPY requirements.txt /app
COPY template.html /app

RUN pip install -r requirements.txt

EXPOSE 8080
CMD [ "python", "server.py", "config.yml" ]
