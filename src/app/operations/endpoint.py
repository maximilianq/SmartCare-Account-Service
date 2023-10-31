from app.types import uuid
from app.enums import HTTPMethod

from simplesql import SQLRouter

endpoint_router: SQLRouter = SQLRouter()

async def endpoint_list(hidden: bool, deleted: bool) -> list[dict[str, object]]:

    groups: list[dict[str, object]] = await endpoint_router.endpoint_list(
        hidden = hidden,
        deleted = deleted
    )
    
    return groups

async def endpoint_read(guid: uuid) -> dict[str, object]:
    
    group: dict[str, object] = await endpoint_router.endpoint_read(
        guid = guid
    )
    
    return group

async def endpoint_create(url: str, method: HTTPMethod, hidden: bool) -> dict[str, object]:
    
    group: dict[str, object] = await endpoint_router.endpoint_create(
        url = url,
        method = method.value,
        hidden = hidden
    )
    
    return group

async def endpoint_update(guid: uuid, changes: set[str], url: str, method: HTTPMethod, hidden: bool) -> dict[str, object]:
    
    group: dict[str, object] = await endpoint_router.endpoint_update(
        guid = guid,
        url = url, url_set = 'url' in changes,
        method = method.value if method else None, method_set = 'method' in changes,
        hidden = hidden, hidden_set = 'hidden' in changes
    )
    
    return group

async def endpoint_delete(guid: uuid) -> dict[str, object]:
    
    group: dict[str, object] = await endpoint_router.endpoint_delete(
        guid = guid
    )
    
    return group