#!/bin/bash

/usr/bin/python /opt/graphite/bin/carbon-cache.py start 2>&1 >> /var/log/carbon.log
