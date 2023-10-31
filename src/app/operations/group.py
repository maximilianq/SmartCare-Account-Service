from app.types import uuid

from simplesql import SQLRouter

group_router: SQLRouter = SQLRouter()

async def group_list(hidden: bool, deleted: bool) -> list[dict[str, object]]:

    groups: list[dict[str, object]] = await group_router.group_list(
        hidden = hidden,
        deleted = deleted
    )
    
    return groups

async def group_read(guid: uuid) -> dict[str, object]:
    
    group: dict[str, object] = await group_router.group_read(
        guid = guid
    )
    
    return group

async def group_create(name: str, description: str, hidden: bool) -> dict[str, object]:
    
    group: dict[str, object] = await group_router.group_create(
        name = name,
        description = description,
        hidden = hidden
    )
    
    return group

async def group_update(guid: uuid, changes: set[str], name: str, description: str, hidden: bool) -> dict[str, object]:
    
    group: dict[str, object] = await group_router.group_update(
        guid = guid,
        name = name, name_set = 'name' in changes,
        description = description, description_set = 'description' in changes,
        hidden = hidden, hidden_set = 'hidden' in changes
    )
    
    return group

async def group_delete(guid: uuid) -> dict[str, object]:
    
    group: dict[str, object] = group_router.group_delete(
        guid = guid
    )
    
    return group

async def group_link_account(group_guid: uuid, account_guid: uuid) -> dict[str, object]:
    
    group_account: dict[str, object] = await group_router.group_link_account(
        group_guid = group_guid,
        account_guid = account_guid
    )
    
    return group_account

async def group_unlink_account(group_guid: uuid, account_guid: uuid) -> dict[str, object]:
    
    group_account: dict[str, object] = await group_router.group_unlink_account(
        group_guid = group_guid,
        account_guid = account_guid
    )
    
    return group_account