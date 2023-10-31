from simplesql import SQLRouter

from ._external import external_router
from ._internal import internal_router
from .account_credentials import account_credentials_router
from .account_token import account_token_router
from .account import account_router
from .action import action_router
from .endpoint import endpoint_router
from .group import group_router
from .session import session_router

sql_router: SQLRouter = SQLRouter()

sql_router.include_router(external_router)
sql_router.include_router(internal_router)
sql_router.include_router(account_credentials_router)
sql_router.include_router(account_token_router)
sql_router.include_router(account_router)
sql_router.include_router(action_router)
sql_router.include_router(endpoint_router)
sql_router.include_router(group_router)
sql_router.include_router(session_router)