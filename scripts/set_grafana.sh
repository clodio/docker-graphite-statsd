#!/bin/bash
set -e

if [ -f /.grafana_configured ]; then
    echo "=> Grafana has been configured!"
    exit 0
fi

if [ "${GRAPHITE_HOST}" = "**ChangeMe**" ]; then
    echo "=> No address of GRAPHITE is specified!"
    echo "=> Program terminated!"
    exit 1
fi

if [ "${GRAPHITE_PORT}" = "**ChangeMe**" ]; then
    echo "=> No PORT of GRAPHITE is specified!"
    echo "=> Program terminated!"
    exit 1
fi
if [ "${ELASTICSEARCH_HOST}" = "**ChangeMe**" ]; then
    echo "=> No address of ELASTICSEARCH is specified!"
    echo "=> Program terminated!"
    exit 1
fi

if [ "${ELASTICSEARCH_PORT}" = "**ChangeMe**" ]; then
    echo "=> No PORT of ELASTICSEARCH is specified!"
    echo "=> Program terminated!"
    exit 1
fi


echo "=> Configuring Grafana"
if [ -n "${GRAPHITE_USER}" ] && [ -n "${GRAPHITE_PASS}" ]; then
    echo "Configuring graphite with user and password"
else
    echo "Configuring graphite without user and password"
    sed -i -e "s/<--GRAPHITE_USER-->:<--GRAPHITE_PASS-->@//g" /var/www/grafana/public/config.js
fi
if [ -n "${ELASTICSEARCH_USER}" ] && [ -n "${ELASTICSEARCH_PASS}" ]; then
    echo "Configuring graphite with user and password"
else
    echo "Configuring graphite without user and password"
    sed -i -e "s/<--ELASTICSEARCH_USER-->:<--ELASTICSEARCH_PASS-->@//g" /var/www/grafana/public/config.js
fi

sed -i -e "s/<--PROTO-->/${GRAPHITE_PROTO}/g" \
    -e "s/<--GRAPHITE_PROTO-->/${GRAPHITE_PROTO}/g" \
    -e "s/<--GRAPHITE_HOST-->/${GRAPHITE_HOST}/g" \
    -e "s/<--GRAPHITE_PORT-->/${GRAPHITE_PORT}/g" \
    -e "s/<--GRAPHITE_HOST-->/${GRAPHITE_HOST}/g" \
    -e "s/<--GRAPHITE_USER-->/${GRAPHITE_USER}/g" \
    -e "s/<--GRAPHITE_PASS-->/${GRAPHITE_PASS}/g" \
    -e "s/<--ELASTICSEARCH_PROTO-->/${ELASTICSEARCH_PROTO}/g" \
    -e "s/<--ELASTICSEARCH_HOST-->/${ELASTICSEARCH_HOST}/g" \
    -e "s/<--ELASTICSEARCH_PORT-->/${ELASTICSEARCH_PORT}/g" \
    -e "s/<--ELASTICSEARCH_HOST-->/${ELASTICSEARCH_HOST}/g" \
    -e "s/<--ELASTICSEARCH_USER-->/${ELASTICSEARCH_USER}/g" \
    -e "s/<--ELASTICSEARCH_PASS-->/${ELASTICSEARCH_PASS}/g" /var/www/grafana/public/config.js

touch /.grafana_configured
echo "=> Grafana has been configured as follows:"
echo "   Graphite PROTOCOL:  ${GRAPHITE_PROTO}"
echo "   Graphite ADDRESS:  ${GRAPHITE_HOST}"
echo "   Graphite PORT:     ${GRAPHITE_PORT}"
echo "   Graphite USERNAME: ${GRAPHITE_USER}"
echo "   Graphite PASSWORD: ${GRAPHITE_PASS}"
echo "   ElasticSearch PROTOCOL:  ${ELASTICSEARCH_PROTO}"
echo "   ElasticSearch ADDRESS:  ${ELASTICSEARCH_HOST}"
echo "   ElasticSearch PORT:     ${ELASTICSEARCH_PORT}"
echo "   ElasticSearch USERNAME: ${ELASTICSEARCH_USER}"
echo "   ElasticSearch PASSWORD: ${ELASTICSEARCH_PASS}"
echo "   ** Please check your environment variables if you find something is misconfigured. **"
echo "=> Done!"
