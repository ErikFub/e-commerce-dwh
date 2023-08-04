#!/usr/bin/env bash

DATABASENAME=${1:-'ecommerce_dwh'}

echo "Creating database '$DATABASENAME'"

createdb $DATABASENAME
psql -h localhost -p 5432 -U postgres -d $DATABASENAME -f data/create/CREATE_TABLES.sql
psql -h localhost -p 5432 -U postgres -d $DATABASENAME -f data/create/CREATE_PRODUCTS.sql
psql -h localhost -p 5432 -U postgres -d $DATABASENAME -f data/create/CREATE_LABELS.sql
psql -h localhost -p 5432 -U postgres -d $DATABASENAME -f data/create/CREATE_ADDRESS.sql
psql -h localhost -p 5432 -U postgres -d $DATABASENAME -f data/create/CREATE_CUSTOMERS.sql
psql -h localhost -p 5432 -U postgres -d $DATABASENAME -f data/create/CREATE_ORDERS.sql
psql -h localhost -p 5432 -U postgres -d $DATABASENAME -f data/create/CREATE_STOCK.sql
psql -h localhost -p 5432 -U postgres -d $DATABASENAME -f data/create/CREATE_COLORS.sql
psql -h localhost -p 5432 -U postgres -d $DATABASENAME -f data/create/CREATE_SIZES.sql
