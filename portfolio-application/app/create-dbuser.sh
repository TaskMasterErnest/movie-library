#!/bin/bash

# Read environment variables
MONGODB_USER=${MONGODB_USER}
MONGODB_PASSWORD=${MONGODB_PASSWORD}
MONGODB_ROOT_PASSWORD=${MONGODB_ROOT_PASSWORD}
MONGODB_DATABASE=${MONGODB_DATABASE}

# Create MongoDB user
echo "Creating MongoDB user..."
mongosh admin --host localhost -u root -p $MONGODB_ROOT_PASSWORD --eval "db.createUser({user: 'ernest', pwd: '$MONGODB_PASSWORD', roles: [{role: 'readWrite', db: '$MONGODB_DATABASE'}, {role: 'dbAdmin', db: 'admin'}]});"
echo "MongoDB user created."