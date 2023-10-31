from ._base import Router

account_router: Router = Router()

@account_router.listen('account_credentials', 'created')
def handle(data: dict):
    pass

@account_router.listen('account_credentials_updated')
def handle(data: dict):
    pass

@account_router.listen('account_credentials_deleted')
def handle(data: dict):
    pass

@account_router.listen('account_created')
def handle(data: dict):
    pass

@account_router.listen('account_updated')
def handle(data: dict):
    pass

@account_router.listen('account_deleted')
def handle(data: dict):
    pass