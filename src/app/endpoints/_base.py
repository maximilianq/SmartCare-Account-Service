from fastapi import APIRouter as Router, Request, Response, Depends, Cookie, HTTPException

from .account import account_router
from .account_credentials import account_credentials_router
from .account_token import account_token_router
from .action import action_router
from .endpoint import endpoint_router
from .group import group_router
from .session import session_router

from ._external import external_router

api_router: Router = Router(prefix='/api')

api_router.include_router(account_router)
api_router.include_router(account_credentials_router)
api_router.include_router(account_token_router)
api_router.include_router(action_router)
api_router.include_router(endpoint_router)
api_router.include_router(group_router)
api_router.include_router(session_router)

app_router: Router = Router()

app_router.include_router(api_router)
app_router.include_router(external_router)