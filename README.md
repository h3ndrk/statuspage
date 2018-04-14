# statuspage – A lightweight and simple statuspage implementation

## Concept

All items defined in the `config.yml` must be refreshed periodically. If this doesn't happen the statuspage assumes the service is down.

## Generate token

Generate the token via `/dev/urandom`:

```bash
head -c 1000 /dev/urandom | sha512sum | cut -c 1-64
```

Open the `config.yml` and paste the generated token at `statuspage.token`:

```yaml
statuspage:
  ...
  token: <token>
  ...
```

## Installation & Usage

1. Install packages via `pip install -r requirements.txt` (you may want to use a virtual environment)
2. Run the following command:

```bash
python server.py config.yml
======== Running on http://0.0.0.0:8080 ========
(Press CTRL+C to quit)
```

3. Then head over to `http://localhost:8080` in your browser.

Or use docker:

## Installation with Docker

### Build image

```bash
docker build -t statuspage .
```

### Run container

For example:

```bash
docker run --detach --restart=always --name statuspage \
    -v /root/statuspage/config.yml:/app/config.yml:ro \
    -e "TZ=Europe/Berlin" \
    -p 8080:8080 statuspage
```

Change the path to the `config.yml` and correct the timezone (the server displays the current time on the status page which might be wrong if the timezone is incorrect).

## `config.yml`

The file `config.yml` holds all groups and items of the status page. A group has a name and holds several items. An item has a name and an ID. It may be up or down and can be refreshed. IDs and names can be chosen freely.

Example YAML file:

```yaml
statuspage:
  # title of the status page (optional, default: "Status")
  title: NIPE-SYSTEMS – Status
  # token for refreshes (required), generate with:
  #   head -c 1000 /dev/urandom | sha512sum | cut -c 1-64
  token: 395194575aaad69204a1298c4f838755679888e9b502285f8b5774067863b5fd
  # interval how long an item is treated operational (optional, default: 600)
  interval: 600
  # A group has a name and holds several items. An item has a name and an ID.
  # It may be up or down and can be refreshed. IDs and names can be chosen freely.
  groups:
    SomeGroup:
      - name: HTTP/HTTPS
        id: http
      - name: DNS
        id: dns
      - name: SMTP/IMAP
        id: mail
        interval: 60 # it is possible to override the global interval
    "Group #2":
      - name: HTTP/HTTPS
        id: http
      - name: Internal DNS
        id: dns-internal
```

The following example will refresh the item with the ID `dns` which is in group *SomeGroup* and has the name *DNS*:

```
curl -v --header "X-Token: 395194575aaad69204a1298c4f838755679888e9b502285f8b5774067863b5fd" http://localhost:8080/refresh/dns
> GET /refresh/dns HTTP/1.1
> Host: localhost:8080
> User-Agent: curl/7.59.0
> Accept: */*
> X-Token: 395194575aaad69204a1298c4f838755679888e9b502285f8b5774067863b5fd
> 
< HTTP/1.1 200 OK
< Content-Type: application/json; charset=utf-8
< Content-Length: 16
< Date: Sun, 08 Apr 2018 11:12:30 GMT
< Server: Python/3.6 aiohttp/3.1.2
< 
{"refreshed": 1}
```

As you can see, the server responses with the number of refreshed items. The following example will refresh the item with ID `http` (two items have ID )

```
curl -v --header "X-Token: 395194575aaad69204a1298c4f838755679888e9b502285f8b5774067863b5fd" http://localhost:8080/refresh/http
> GET /refresh/http HTTP/1.1
> Host: localhost:8080
> User-Agent: curl/7.59.0
> Accept: */*
> X-Token: 395194575aaad69204a1298c4f838755679888e9b502285f8b5774067863b5fd
> 
< HTTP/1.1 200 OK
< Content-Type: application/json; charset=utf-8
< Content-Length: 16
< Date: Sun, 08 Apr 2018 11:12:30 GMT
< Server: Python/3.6 aiohttp/3.1.2
< 
{"refreshed": 2}
```
