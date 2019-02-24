# raven-prosody
XMPP server for Raven

wsURL: `ws:127.0.0.1:5280/xmpp-websocket`

```sh
$ docker build -t raven-prosody .
$ docker run -d --name prosody -p 5280:5280 -p 80:80 raven-prosody:latest
$ docker logs -f prosody
$ docker exec -it prosody bash
```