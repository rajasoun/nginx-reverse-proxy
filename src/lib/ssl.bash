#!/usr/bin/env bash

function generate_ssl_certificate_from_letsencrypt(){
  _docker run --rm \
      -v "${WORKSPACE}/certs:/etc/letsencrypt" \
      -e AWS_ACCESS_KEY_ID="${AWS_ACCESS_KEY_ID}" \
      -e AWS_SECRET_ACCESS_KEY="${AWS_SECRET_ACCESS_KEY}" \
      -e EMAIL="${EMAIL}" \
      -e DOMAINS="${BASE_DOMAIN}" \
      -e USE_STAGING_SERVER="${USE_STAGING_SERVER}" \
      rajasoun/certbot-dns-route53:latest

  case "$?" in
    0)
        echo "SSL Certificates Successfully Gnerated "
        echo "For Domain -> ${BASE_DOMAIN} at ${WORKSPACE}/certs" ;;
    1)
        echo "Error... Certificate Generation Failed" ;;
  esac
}

function run_main(){
  generate_ssl_certificate_from_letsencrypt
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]
then
  if ! run_main
  then
    exit 1
  fi
fi