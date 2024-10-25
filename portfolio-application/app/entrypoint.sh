#!/bin/bash
APP_PORT=${PORT:-5000}

# run gunicorn production server
gunicorn -w 4 --bind "0.0.0.0:$APP_PORT" --access-logfile '-' --error-logfile '-' app:app
# flask run