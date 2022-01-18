#!/bin/bash
set -e

rm -f /pai-chat/tmp/pids/server.pid

exec "$@"
