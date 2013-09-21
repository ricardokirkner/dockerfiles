#!/bin/bash

# start postgresql
service postgresql start

# start apache
service apache2 start

# keep in foregrouskipnd
while true; do sleep 86400 ; done
