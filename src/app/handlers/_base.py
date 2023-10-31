from simpleamqp import AMQPRouter

from .account import account_router

handler_router: AMQPRouter = AMQPRouter()

handler_router.include_router(account_router)
