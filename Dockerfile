FROM python:3

WORKDIR /app

COPY requirements.txt /app

RUN pip install -r requirements.txt

COPY server.py /app
COPY down.png /app
COPY up.png /app
COPY template.html /app

EXPOSE 8080
CMD [ "python", "server.py", "config.yml" ]
