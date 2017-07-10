FROM alpine:3.6
RUN apk add --update \
    python \
    python-dev \
    py-pip \
  && pip install requests \
  && rm -rf /var/cache/apk/*

COPY configmap_modifier.py /

ENTRYPOINT ["sh", "-c", "tail -f /dev/null"]
