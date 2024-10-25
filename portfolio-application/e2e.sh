#!/bin/bash
set -x

# Check if the correct number of arguments are provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <APP_URL>"
    exit 1
fi

# Set the APP_URL
APP_URL=$1

echo "Starting E2E tests on ${APP_URL}..."
sleep 5s

# Send a request to the APP_URL and store the HTTP status code
statusCode=$(curl -s -o /dev/null -w %{http_code} -X POST -F username=user1 -F password=password1 -F confirm_password=password1 "${APP_URL}")

# Check the status code
if [ "$statusCode" == "200" ]; then
  echo "Test Successful"
  exit 0
else
  echo "E2E Test Failed! Received HTTP response code: ${statusCode}"
  exit 1
fi

# curl -s -o /dev/null -w %{http_code} -X POST -F username=user1 -F password=password1 -F confirm_password=password1 http://0.0.0.0:8085/signup