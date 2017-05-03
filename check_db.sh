#!/usr/bin/env bash

RESULT=$(/usr/bin/mysql --protocol=TCP --host="$SQL_HOST" --port="$SQL_PORT" --user="$SQL_USER" --password="$SQL_PASS" --skip-column-names -e "SHOW DATABASES LIKE '$SQL_DB'")
if [ "$RESULT" != "$SQL_DB" ]; then
    /usr/bin/mysql --protocol=TCP --host="$SQL_HOST" --port="$SQL_PORT" --user="$SQL_USER" --password="$SQL_PASS" -e "CREATE DATABASE '$SQL_DB'" &&
	/usr/bin/mysql --protocol=TCP --host="$SQL_HOST" --port="$SQL_PORT" --user="$SQL_USER" --password="$SQL_PASS" < /tmp/schema.sql ;
fi
