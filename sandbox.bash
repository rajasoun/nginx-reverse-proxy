#!/usr/bin/env bash

set -eo pipefail

SERVICES=" -f nginx.yml -f whoami.yml"

function _ssl(){
  echo "Generate Certificates from Letsencrypt.."
  export WORKSPACE=$(git rev-parse --show-toplevel)
  source ".env"
  source "src/load.bash"
  generate_ssl_certificate_from_letsencrypt
}

function help(){
    echo "Usage: $0  {up|down|status|logs|ssl}" >&2
    echo
    echo "   up               Provision, Configure, Validate Application Stack"
    echo "   down             Destroy Application Stack"
    echo "   status           Displays Status of Application Stack"
    echo "   logs             Application Stack Logs"
    echo "   ssl              Create/Renew Certificate"
    echo
    return 1
}

opt="$1"
choice=$( tr '[:upper:]' '[:lower:]' <<<"$opt" )
case $choice in
    up)
      echo "Bring Up Application Stack"
      _ssl
      docker-compose ${SERVICES} up -d 
      echo "Goto following Links  "
      echo "https://${SUB_DOMAIN}          ->  Site with HTTPS support"
      echo "http://${SUB_DOMAIN}           ->  Gets Upgraded to https automatically"
      echo "https://${SUB_DOMAIN}/whoami   ->  Reverse Proxy Example"
      ;;
    down)
      echo "Destroy Application Stack & Services"
      docker-compose ${SERVICES} down
      rm -fr logs/nginx/*.*
      ;;
    status)
      echo "Containers Status..."
      docker-compose ${SERVICES} ps
      ;;
    logs)
      echo "Containers Log..."
      tail -f logs/nginx/*.log
      ;;
    ssl)
      _ssl
      ;;
    *)  help ;;
esac