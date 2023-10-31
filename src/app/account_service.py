from fastapi import FastAPI
from uvicorn import run

from simplesql import SQLClient
from simpleamqp import AMQPClient

from logging import getLogger, Logger

from app.endpoints import app_router
from app.operations import sql_router
from app.notifiers import notifier_router
from app.handlers import handler_router

from .settings import (
    LOG_LEVEL,
    API_PORT,
    DB_HOST,
    DB_PORT,
    DB_USERNAME,
    DB_PASSWORD, 
    DB_NAME,
    DB_QUERIES,
    COMM_HOST,
    COMM_PORT,
    COMM_USERNAME,
    COMM_PASSWORD, 
    COMM_NAME,
    COMM_SERVICE
)

class AccountService:

    def __init__(self) -> None:

        self.logger: Logger = getLogger('uvicorn.error')

        self.sql: SQLClient = SQLClient(DB_HOST, DB_PORT, DB_USERNAME, DB_PASSWORD, DB_NAME, self.logger)

        self.sql.include_queries(DB_QUERIES)

        self.sql.register_events(
            'account_created', 'account_updated', 'account_deleted',
            'account_credentials_created', 'account_credentials_updated', 'account_credentials_deleted',
            'account_token_created', 'account_token_updated', 'account_token_deleted',
            'group_created', 'group_updated', 'group_deleted',
            'action_created', 'action_updated', 'action_deleted',
            'endpoint_created', 'endpoint_updated', 'endpoint_deleted',
            'session_created', 'session_updated', 'session_deleted'
        )

        self.sql.include_router(sql_router)

        #self.amqp: AMQPClient = AMQPClient(COMM_HOST, COMM_PORT, COMM_USERNAME, COMM_PASSWORD, COMM_NAME, COMM_SERVICE, self.logger)

        #self.amqp.include_router(notifier_router)
        #self.amqp.include_router(handler_router)

        self.app: FastAPI = FastAPI(swagger_ui_parameters={"defaultModelsExpandDepth": -1})

        self.app.include_router(app_router)

        self.app.add_event_handler('startup', self.startup)
        self.app.add_event_handler('shutdown', self.shutdown)

    async def startup(self):
        await self.sql.start()
        #await self.amqp.start()

    async def shutdown(self):
        await self.sql.stop()
        #await self.amqp.stop()

    def start(self) -> None:
        run(self.app, host='0.0.0.0', port=API_PORT, log_level=LOG_LEVEL.lower())

def main():
    account_service: AccountService = AccountService()
    account_service.start()

if __name__ == '__main__':
    main()