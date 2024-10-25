import os
import sys
import logging
from flask import Flask
from dotenv import load_dotenv
from pymongo import MongoClient
from logging import StreamHandler

from movie_library.routes import pages
from prometheus_client import Summary, Counter, Histogram, Gauge
from prometheus_client.core import CollectorRegistry

load_dotenv()


def create_app():
    app = Flask(__name__)
    app.config["MONGODB_URI"] = os.environ.get("MONGODB_URI")
    app.config["SECRET_KEY"] = os.environ.get(
        "SECRET_KEY", "pf9Wkove4IKEAXvy-cQkeDPhv9Cb3Ag-wyJILbq_dFw"
    )
    app.db = MongoClient(app.config["MONGODB_URI"]).get_default_database()

    # app.db = MongoClient(app.config["MONGODB_URI"]).get_default_database()
    # Configure logging
    logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(name)s - %(levelname)s - %(message)s')
    # Define a custom formatter for JSON logging
    json_formatter = logging.Formatter('{"time": "%(asctime)s", "name": "%(name)s", "level": "%(levelname)s", "message": "%(message)s"}')
    # Create a stream handler to log to stdout
    stream_handler = logging.StreamHandler(sys.stdout)
    stream_handler.setFormatter(json_formatter)
    app.logger.addHandler(stream_handler)

    # initializing the Prometheus metrics
    app.config['http_requests_total'] = Counter('http_requests_total', 'Total HTTP requests', ['method', 'endpoint'])
    app.config['failed_logins_total'] = Counter('failed_logins_total', 'Total failed login attempts')
    app.config['active_users'] = Gauge('active_users', 'Number of active users')
    app.config['db_operation_total'] = Counter('db_operation_total', 'Total number of database operations', ['operation', 'table'])
    app.config['db_operation_duration_seconds'] = Histogram('db_operation_duration_seconds', 'Duration of database operations in seconds', ['operation', 'table'])
    app.config['movies_rated_total'] = Counter('movies_rated_total', 'Total number of movies rated')
    app.config['movies_watched_total'] = Counter('movies_watched_total', 'Total number of movies watched')
    app.config['theme_changes_total'] = Counter('theme_changes_total', 'Total number of theme changes')

    app.register_blueprint(pages)
    return app
