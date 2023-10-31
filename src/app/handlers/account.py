from simpleamqp import AMQPRouter

from app.operations import account_list, account_read

account_router: AMQPRouter = AMQPRouter()

@account_router.handle('account', 'created')
async def handle(data: dict[str, object]):
    return b"data of a new account!"
