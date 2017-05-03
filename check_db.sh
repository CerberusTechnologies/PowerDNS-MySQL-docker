#!/usr/bin/env bash

HOST=$1
PORT=$2
USER=$3
PASSWORD=$4
DATABASE=$5

RESULT=$(/usr/bin/mysql --protocol=TCP --host="$HOST" --port="$PORT" --user="$USER" --password="$PASSWORD" --skip-column-names -e "SHOW DATABASES LIKE '$DATABASE'")
if [ "$RESULT" != "$DATABASE" ]; then
    /usr/bin/mysql --protocol=TCP --host="$HOST" --port="$PORT" --user="$USER" --password="$PASSWORD" -e "CREATE DATABASE '$DATABASE'" &&
	/usr/bin/mysql --protocol=TCP --host="$HOST" --port="$PORT" --user="$USER" --password="$PASSWORD" < /tmp/schema.sql ;
fi
