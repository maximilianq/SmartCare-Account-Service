from app.types import uuid

from simplesql import SQLRouter

account_router: SQLRouter = SQLRouter()

async def account_list(hidden: bool, deleted: bool) -> list[dict[str, object]]:

    accounts: list[dict[str, object]] = await account_router.account_list(
        hidden = hidden,
        deleted = deleted
    )
    
    return accounts

async def account_read(guid: uuid) -> dict[str, object]:
    
    account: dict[str, object] = await account_router.account_read(
        guid = guid
    )
    
    return account