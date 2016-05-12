#!/bin/bash
set -e

chown -R www-data /var/www/html

exec "$@"