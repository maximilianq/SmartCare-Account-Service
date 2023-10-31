from app.types import uuid
from app.operations import group_list, group_read, group_create, group_update, group_delete, group_link_account, action_link_group, group_unlink_account, action_unlink_group
from app.models import GroupSimple, GroupComplex, GroupAccountLink, ActionGroupLink, GroupConstrained, GroupOptional
from app.middlewares import authenticate

from ._base import Router, Request, Depends, HTTPException

group_router: Router = Router(prefix='/group', dependencies=[Depends(authenticate)], tags=['group'])

@group_router.get('', response_model=list[GroupSimple], response_model_exclude_unset=True)
async def get(request: Request, hidden: bool = False, deleted: bool = False):

    groups: list[dict[str, object]] = await group_list(hidden, deleted)

    return groups

@group_router.get('/{guid:uuid}', response_model=GroupComplex, response_model_exclude_unset=True)
async def get(request: Request, guid: uuid):

    group: dict[str, object] = await group_read(guid)

    if not group:
        raise HTTPException(404, 'Error: The requested entity could not be found!')

    return group

@group_router.post('', response_model=GroupSimple, response_model_exclude_unset=True)
async def post(request: Request, data: GroupConstrained):

    group: dict[str, object] = await group_create(**data.model_dump())

    if not group:
        raise HTTPException(404, 'Error: The requested entity could not be created!')

    return group

@group_router.patch('/{guid:uuid}', response_model=GroupSimple, response_model_exclude_unset=True)
async def patch(request: Request, guid: uuid, data: GroupOptional):

    group: dict[str, object] = await group_update(guid=guid, changes=data.model_fields_set, **data.model_dump())

    if not group:
        raise HTTPException(404, 'Error: The requested entity could not be updated!')

    return group

@group_router.delete('/{guid:uuid}', response_model=GroupSimple, response_model_exclude_unset=True)
async def delete(request: Request, guid: uuid):

    group: dict[str, object] = await group_delete(guid=guid)

    if not group:
        raise HTTPException(404, 'Error: The requested entity could not be deleted!')

    return group

@group_router.post('/{group_guid:uuid}/account/{account_guid:uuid}', response_model=GroupAccountLink, response_model_exclude_unset=True)
async def post(request: Request, group_guid: uuid, account_guid: uuid):

    group_account: dict[str, object] = await group_link_account(group_guid, account_guid)

    if not group_account:
        raise HTTPException(404, 'Error: The requested entity could not be created!')

    return group_account

@group_router.post('/{group_guid:uuid}/action/{action_guid:uuid}', response_model=ActionGroupLink, response_model_exclude_unset=True)
async def post(request: Request, group_guid: uuid, action_guid: uuid):

    action_group: dict[str, object] = await action_link_group(action_guid, group_guid)

    if not action_group:
        raise HTTPException(404, 'Error: The requested entity could not be created!')

    return action_group

@group_router.delete('/{group_guid:uuid}/account/{account_guid:uuid}', response_model=GroupAccountLink, response_model_exclude_unset=True)
async def post(request: Request, group_guid: uuid, account_guid: uuid):

    group_account: dict[str, object] = await group_unlink_account(group_guid, account_guid)

    if not group_account:
        raise HTTPException(404, 'Error: The requested entity could not be created!')

    return group_account

@group_router.delete('/{group_guid:uuid}/action/{action_guid:uuid}', response_model=ActionGroupLink, response_model_exclude_unset=True)
async def delete(request: Request, group_guid: uuid, action_guid: uuid):

    action_group: dict[str, object] = await action_unlink_group(action_guid, group_guid)

    if not action_group:
        raise HTTPException(404, 'Error: The requested entity could not be created!')

    return action_group