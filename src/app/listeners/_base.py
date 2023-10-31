from app.database import SQLRouter as Router

from .account import account_router

router: Router = Router()

router.include_router(account_router)