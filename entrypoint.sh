#!/bin/sh
# Docker entrypoint script.

# Wait until Postgres is ready
# while ! pg_isready -q -h $DB_HOST -p 5432 -U $DB_USER
# do
#   echo "$(date) - waiting for database to start"
#   sleep 2
# done

# Create database if it doesn't exist.
if [[ -z `psql -Atqc "\\list $PGDATABASE"` ]]; then
  echo "Database $PGDATABASE does not exist. Creating..."
  createdb -E UTF8 $PGDATABASE -l en_US.UTF-8 -T template0
  echo "Database $PGDATABASE created."
fi

./bin/ex_micro_blog eval ExMicroBlog.Release.migrate

./bin/ex_micro_blog start
# ./prod/rel/ex_micro_blog/bin/ex_micro_blog eval ExMicroBlog.Release.migrate

# ./prod/rel/ex_micro_blog/bin/ex_micro_blog start