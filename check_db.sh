#!/usr/bin/env bash

HOST=$1
PORT=$2
USER=$3
PASSWORD=$4
DATABASE=$5

RESULT="mysql -h $HOST -P $PORT -u $USER -p$PASSWORD --skip-column-names -e \"SHOW DATABASES LIKE '$DATABASE'\""
if [ "$RESULT" -ne "$DATABASE" ]; then
    mysql -h "$HOST" -P "$PORT" -u "$USER" -p"$PASSWORD" -e "CREATE DATABASE '$DATABASE'" &&
	mysql -h "$HOST" -P "$PORT" -u "$USER" -p"$PASSWORD" "$DATABASE" < /tmp/schema.sql;
fi
