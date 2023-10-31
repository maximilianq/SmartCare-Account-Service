from simpleamqp import AMQPRouter

from .employee import employee_router

notifier_router: AMQPRouter = AMQPRouter()

notifier_router.include_router(employee_router)