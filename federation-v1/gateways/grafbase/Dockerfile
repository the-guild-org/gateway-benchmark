FROM ghcr.io/grafbase/gateway:0.24.0

COPY supergraph.graphql ./

EXPOSE 4000

CMD ["--schema", "supergraph.graphql", "--listen-address", "0.0.0.0:4000"]
