#/bin/sh
set -e

if [ ! -n "$1" ]; then
  echo "gateway dir is missing, please run as: ./run.sh <gateway_dir>"
  exit 1
fi

export ACCOUNTS_SUBGRAPH_DELAY_MS="40~130"
export INVENTORY_SUBGRAPH_DELAY_MS="50~100"
export PRODUCTS_SUBGRAPH_DELAY_MS="100~120"
export REVIEWS_SUBGRAPH_DELAY_MS="20-150"

# needed because we are taking containers from another directory, and Docker can be stupid sometimes

export BASE_DIR=$( realpath ../fed-v1-constant-vus-over-time )

on_error(){
    cd $BASE_DIR
    docker inspect gateway
    docker logs gateway
    docker compose  -f ../../docker-compose.metrics.yaml  -f ../fed-v1-constant-vus-over-time/docker-compose.services.yaml -f ../fed-v1-constant-vus-over-time/$1/docker-compose.yaml ps
    docker compose  -f ../../docker-compose.metrics.yaml  -f ../fed-v1-constant-vus-over-time/docker-compose.services.yaml -f ../fed-v1-constant-vus-over-time/$1/docker-compose.yaml logs
}
 
trap 'on_error' ERR

docker compose  -f ../../docker-compose.metrics.yaml  -f ../fed-v1-constant-vus-over-time/docker-compose.services.yaml -f ../fed-v1-constant-vus-over-time/$1/docker-compose.yaml up -d --wait --force-recreate

if [[ -z "${CI}" ]]; then
    trap "docker compose  -f ../../docker-compose.metrics.yaml  -f ../fed-v1-constant-vus-over-time/docker-compose.services.yaml -f ../fed-v1-constant-vus-over-time/$1/docker-compose.yaml down && exit 0" INT
fi

export K6_PROMETHEUS_RW_SERVER_URL=http://localhost:9090/api/v1/write

export K6_PROMETHEUS_RW_TREND_AS_NATIVE_HISTOGRAM=true

export START_TIME="$(date +%s)"

mkdir ./$1 || echo ""

k6 --out=experimental-prometheus-rw --out json=./$1/k6_metrics.json run -e SUMMARY_PATH="./$1" ../fed-v1-constant-vus-over-time/benchmark.k6.js || echo "maybe something is wronge with k6, but we'll continue with the stats collection"

# sleep for longer, to allow us to measure the cooldown period and see if RAM/CPU usage drops

sleep 10

export END_TIME="$(date +%s)"

docker logs gateway > ./$1/gateway_log.txt

rm -rf ./$1/overview.png || echo ""

npx --quiet capture-website-cli "http://localhost:3000/d/01npcT44k/k6?orgId=1&from=${START_TIME}000&to=${END_TIME}000&kiosk" --output ./$1/overview.png --width 1200 --height 740

rm -rf ./$1/http.png || echo ""

npx --quiet capture-website-cli "http://localhost:3000/d-solo/01npcT44k/k6?orgId=1&from=${START_TIME}000&to=${END_TIME}000&panelId=41" --output ./$1/http.png --width 1200

rm -rf ./$1/containers.png || echo ""

npx --quiet capture-website-cli "http://localhost:3000/d/pMEd7m0Mz/cadvisor-exporter?orgId=1&var-host=All&var-container=accounts&var-container=inventory&var-container=products&var-container=reviews&from=${START_TIME}000&to=${END_TIME}000&kiosk" --output ./$1/containers.png --width 1200

if [[ -z "${CI}" ]]; then
    echo "Done, you can find some stats in Grafana: http://localhost:3000/d/01npcT44k/k6?orgId=1&from=${START_TIME}000&to=${END_TIME}000"
    echo "You can close this and terminate all running services by using Ctrl+C"
    while true; do sleep 10; done
fi