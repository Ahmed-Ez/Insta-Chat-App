#!/bin/bash
set -e

if [ -f /chat-app/tmp/pids/server.pid ]; then
  rm /chat-app/tmp/pids/server.pid
fi

bundle exec rake db:migrate 2>/dev/null || bundle exec rake db:setup

exec bundle exec "$@"