from app.types import uuid

from simplesql import SQLRouter

account_credentials_router: SQLRouter = SQLRouter()

async def account_credentials_list(hidden: bool, deleted: bool) -> list[dict[str, object]]:
    
    accounts: list[dict[str, object]] = await account_credentials_router.account_credentials_list(
        hidden = hidden,
        deleted = deleted
    )

    return accounts

async def account_credentials_read(guid: uuid) -> dict[str, object]:
    
    account: dict[str, object] = await account_credentials_router.account_credentials_read(
        guid = guid
    )
    
    return account

async def account_credentials_create(name: str, description: str, email: str, username: str, password: str, hidden: bool) -> dict[str, object]:
    
    account: dict[str, object] = await account_credentials_router.account_credentials_create(
        name = name,
        description = description,
        email = email,
        username = username,
        password = password,
        hidden = hidden
    )
    
    return account

async def account_credentials_update(guid: uuid, changes: set[str], name: str, description: str, email: str, username: str, password: str, hidden: bool) -> dict[str, object]:
    
    account: dict[str, object] = await account_credentials_router.account_credentials_update(
        guid = guid,
        name = name, name_set = 'name' in changes,
        description = description, description_set = 'description' in changes,
        email = email, email_set = 'email' in changes,
        username = username, username_set = 'username' in changes,
        password = password, password_set = 'password' in changes,
        hidden = hidden, hidden_set = 'hidden' in changes
    )
    
    print('print', account)

    return account

async def account_credentials_delete(guid: uuid) -> dict[str, object]:
    
    account: dict[str, object] = await account_credentials_router.account_credentials_delete(
        guid = guid
    )
    
    return account