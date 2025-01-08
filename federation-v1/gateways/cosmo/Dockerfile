FROM alpine:20250108

RUN apk --no-cache add curl

WORKDIR /home/gw
COPY router.json ./

ENV ROUTER_VERSION=0.117.0

RUN curl -L https://github.com/wundergraph/cosmo/releases/download/router%40${ROUTER_VERSION}/router-router@${ROUTER_VERSION}-linux-$(uname -m | sed s:aarch:arm:| sed s:x86_:amd:).tar.gz | gunzip -dc | tar x && mv router /usr/local/bin

ENV LOG_LEVEL=fatal
ENV LISTEN_ADDR=0.0.0.0:4000
ENV TRACING_ENABLED=false
ENV METRICS_ENABLED=false
ENV METRICS_OTLP_ENABLED=false
ENV GRAPHQL_METRICS_ENABLED=false
ENV PROMETHEUS_ENABLED=false
ENV ROUTER_CONFIG_PATH=router.json

EXPOSE 4000

WORKDIR /home/gw

ENTRYPOINT ["/usr/local/bin/router"]
