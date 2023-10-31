from dotenv import load_dotenv
from os import getenv

load_dotenv()

LOG_LEVEL: str = getenv('LOG_LEVEL')

API_PORT: int = int(getenv('API_PORT'))

DB_HOST: str = getenv('DB_HOST')
DB_PORT: str = int(getenv('DB_PORT'))
DB_USERNAME: str = getenv('DB_USERNAME')
DB_PASSWORD: str = getenv('DB_PASSWORD')
DB_NAME: str = getenv('DB_NAME')
DB_QUERIES: str = getenv('DB_QUERIES')

COMM_HOST: str = getenv('COMM_HOST')
COMM_PORT: str = int(getenv('COMM_PORT'))
COMM_USERNAME: str = getenv('COMM_USERNAME')
COMM_PASSWORD: str = getenv('COMM_PASSWORD')
COMM_NAME: str = getenv('COMM_NAME')
COMM_SERVICE: str = getenv('COMM_SERVICE')
