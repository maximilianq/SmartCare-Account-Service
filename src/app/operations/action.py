from app.types import uuid

from simplesql import SQLRouter

action_router: SQLRouter = SQLRouter()

async def action_list(hidden: bool, deleted: bool) -> list[dict[str, object]]:

    actions: list[dict[str, object]] = await action_router.action_list(
        hidden = hidden,
        deleted = deleted
    )
    
    return actions

async def action_read(guid: uuid) -> dict[str, object]:
    
    action: dict[str, object] = await action_router.action_read(
        guid = guid
    )
    
    return action

async def action_create(name: str, description: str, hidden: bool) -> dict[str, object]:
    
    action: dict[str, object] = await action_router.action_create(
        name = name,
        description = description,
        hidden = hidden
    )
    
    return action

async def action_update(guid: uuid, changes: set[str], name: str, description: str, hidden: bool) -> dict[str, object]:
    
    action: dict[str, object] = await action_router.action_update(
        guid = guid,
        name = name, name_set = 'name' in changes,
        description = description, description_set = 'description' in changes,
        hidden = hidden, hidden_set = 'hidden' in changes
    )
    
    return action

async def action_delete(guid: uuid) -> dict[str, object]:
    
    action: dict[str, object] = await action_router.action_delete(
        guid = guid
    )
    
    return action

async def action_link_account(action_guid: uuid, account_guid: uuid) -> dict[str, object]:
    
    action_account: dict[str, object] = await action_router.action_link_account(
        action_guid = action_guid,
        account_guid = account_guid
    )
    
    return action_account

async def action_link_group(action_guid: uuid, group_guid: uuid) -> dict[str, object]:
    
    action_group: dict[str, object] = await action_router.action_link_group(
        action_guid = action_guid,
        group_guid = group_guid
    )
    
    return action_group

async def action_link_endpoint(action_guid: uuid, endpoint_guid: uuid) -> dict[str, object]:
    
    action_endpoint: dict[str, object] = await action_router.action_link_endpoint(
        action_guid = action_guid,
        endpoint_guid = endpoint_guid
    )
    
    return action_endpoint

async def action_unlink_account(action_guid: uuid, account_guid: uuid) -> dict[str, object]:
    
    action_account: dict[str, object] = await action_router.action_unlink_account(
        action_guid = action_guid,
        account_guid = account_guid
    )
    
    return action_account

async def action_unlink_group(action_guid: uuid, group_guid: uuid) -> dict[str, object]:
    
    action_group: dict[str, object] = await action_router.action_unlink_group(
        action_guid = action_guid,
        group_guid = group_guid
    )
    
    return action_group

async def action_unlink_endpoint(action_guid: uuid, endpoint_guid: uuid) -> dict[str, object]:
    
    action_endpoint: dict[str, object] = await action_router.action_unlink_endpoint(
        action_guid = action_guid,
        endpoint_guid = endpoint_guid
    )
    
    return action_endpoint