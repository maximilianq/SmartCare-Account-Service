from app.types import uuid

from simplesql import SQLRouter

account_token_router: SQLRouter = SQLRouter()

async def account_token_list(hidden: bool, deleted: bool) -> list[dict[str, object]]:

    accounts: list[dict[str, object]] = await account_token_router.account_token_list(
        hidden = hidden,
        deleted = deleted
    )

    return accounts

async def account_token_read(guid: uuid) -> dict[str, object]:

    account: dict[str, object] = await account_token_router.account_token_read(
        guid = guid
    )

    return account

async def account_token_create(name: str, description: str, email: str, hidden: bool) -> dict[str, object]:
    
    account: dict[str, object] = await account_token_router.account_token_create(
        name = name,
        description = description,
        email = email,
        hidden = hidden
    )
    
    return account

async def account_token_update(guid: uuid, changes: set[str], name: str, description: str, email: str, token: bool, hidden: bool) -> dict[str, object]:
    
    account: dict[str, object] = await account_token_router.account_token_update(
        guid = guid,
        name = name, name_set = 'name' in changes,
        description = description, description_set = 'description' in changes,
        email = email, email_set = 'email' in changes,
        token_set = ('token' in changes) and token,
        hidden = hidden, hidden_set = 'hidden' in changes
    )
    
    return account

async def account_token_delete(guid: uuid) -> dict[str, object]:
    
    account: dict[str, object] = await account_token_router.account_token_delete(
        guid = guid
    )
    
    return account