#!/usr/bin/env bash

DATABASENAME=${1:-'mywebshop'}

echo "Restoring data to database $DATABASENAME"

createdb $DATABASENAME
psql -h localhost -p 5432 -U postgres -d $DATABASENAME -f data/dumps/create.sql
psql -h localhost -p 5432 -U postgres -d $DATABASENAME -f data/dumps/products.sql
psql -h localhost -p 5432 -U postgres -d $DATABASENAME -f data/dumps/articles.sql
psql -h localhost -p 5432 -U postgres -d $DATABASENAME -f data/dumps/labels.sql
psql -h localhost -p 5432 -U postgres -d $DATABASENAME -f data/dumps/customer.sql
psql -h localhost -p 5432 -U postgres -d $DATABASENAME -f data/dumps/address.sql
psql -h localhost -p 5432 -U postgres -d $DATABASENAME -f data/dumps/order.sql
psql -h localhost -p 5432 -U postgres -d $DATABASENAME -f data/dumps/order_positions.sql
psql -h localhost -p 5432 -U postgres -d $DATABASENAME -f data/dumps/stock.sql