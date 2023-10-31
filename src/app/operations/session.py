from app.types import uuid

from simplesql import SQLRouter

session_router: SQLRouter = SQLRouter()

async def session_list(hidden: bool, deleted: bool) -> list[dict[str, object]]:

    groups: list[dict[str, object]] = await session_router.session_list(
        hidden = hidden,
        deleted = deleted
    )
    
    return groups

async def session_read(guid: uuid) -> dict[str, object]:
    
    group: dict[str, object] = await session_router.session_read(
        guid = guid
    )
    
    return group

async def session_create(account_guid: uuid, client: str, hidden: bool) -> dict[str, object]:
    
    session: dict[str, object] = await session_router.session_create(
        account_guid = account_guid,
        client = client,
        hidden = hidden
    )
    
    return session

async def session_update(guid: uuid, changes: set[str], hidden: bool) -> dict[str, object]:
    
    group: dict[str, object] = await session_router.session_update(
        guid = guid,
        hidden = hidden, hidden_set = 'hidden' in changes,
    )
    
    return group

async def session_delete(guid: uuid) -> dict[str, object]:
    
    session: dict[str, object] = await session_router.session_delete(
        guid = guid
    )
    
    return session