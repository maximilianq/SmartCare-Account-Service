from simpleamqp import AMQPRouter

employee_router: AMQPRouter = AMQPRouter()

@employee_router.listen('employee', 'created')
async def listen(data: dict[str, object]):
    print(data)