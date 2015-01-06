#!/bin/bash

set -e

if [ "${GRAPHITE_HOST}" == "**None**" ]; then
    unset ELASTICSEARCH_HOST
fi

if [ "${GRAPHITE_USER}" == "**None**" ]; then
    unset ELASTICSEARCH_USER
fi

if [ "${GRAPHITE_PASS}" == "**None**" ]; then
    unset ELASTICSEARCH_PASS
fi

if [ "${ELASTICSEARCH_HOST}" == "**None**" ]; then
    unset ELASTICSEARCH_HOST
fi

if [ "${ELASTICSEARCH_USER}" == "**None**" ]; then
    unset ELASTICSEARCH_USER
fi

if [ "${ELASTICSEARCH_PASS}" == "**None**" ]; then
    unset ELASTICSEARCH_PASS
fi


if [ "${HTTP_PASS}" == "**Random**" ]; then
    unset HTTP_PASS
fi

if [ ! -f /.basic_auth_configured ]; then
    /set_basic_auth.sh
fi

if [ ! -f /.grafana_configured ]; then
    /set_grafana.sh
fi

echo "=> Starting and running Nginx..."
/usr/sbin/nginx
