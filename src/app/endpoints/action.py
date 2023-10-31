from app.types import uuid
from app.operations import action_list, action_read, action_create, action_update, action_delete, action_link_account, action_link_group, action_link_endpoint, action_unlink_account, action_unlink_group, action_unlink_endpoint
from app.models import ActionSimple, ActionComplex, ActionAccountLink, ActionGroupLink, ActionEndpointLink, ActionConstrained, ActionOptional
from app.middlewares import authenticate

from ._base import Router, Request, Depends, HTTPException

action_router: Router = Router(prefix='/action', dependencies=[Depends(authenticate)], tags=['action'])

@action_router.get('', response_model=list[ActionSimple], response_model_exclude_unset=True)
async def get(request: Request, hidden: bool = False, deleted: bool = False):

    actions: list[dict[str, object]] = await action_list(hidden, deleted)

    return actions

@action_router.get('/{guid:uuid}', response_model=ActionComplex, response_model_exclude_unset=True)
async def get(request: Request, guid: uuid):

    action: dict[str, object] = await action_read(guid)

    if not action:
        raise HTTPException(404, 'Error: The requested entity could not be found!')

    return action

@action_router.post('', response_model=ActionSimple, response_model_exclude_unset=True)
async def post(request: Request, data: ActionConstrained):

    action: dict[str, object] = await action_create(**data.model_dump())

    if not action:
        raise HTTPException(404, 'Error: The requested entity could not be created!')

    return action

@action_router.patch('/{guid:uuid}', response_model=ActionSimple, response_model_exclude_unset=True)
async def patch(request: Request, guid: uuid, data: ActionOptional):

    action: dict[str, object] = await action_update(guid=guid, changes=data.model_fields_set, **data.model_dump())

    if not action:
        raise HTTPException(404, 'Error: The requested entity could not be updated!')

    return action

@action_router.delete('/{guid:uuid}', response_model=ActionSimple, response_model_exclude_unset=True)
async def delete(request: Request, guid: uuid):

    action: dict[str, object] = await action_delete(guid=guid)

    if not action:
        raise HTTPException(404, 'Error: The requested entity could not be deleted!')

    return action

@action_router.post('/{action_guid:uuid}/account/{account_guid:uuid}', response_model=ActionAccountLink, response_model_exclude_unset=True)
async def post(request: Request, action_guid: uuid, account_guid: uuid):

    action_account: dict[str, object] = await action_link_account(action_guid, account_guid)

    if not action_account:
        raise HTTPException(404, 'Error: The requested entity could not be created!')

    return action_account

@action_router.post('/{action_guid:uuid}/group/{group_guid:uuid}', response_model=ActionGroupLink, response_model_exclude_unset=True)
async def post(request: Request, action_guid: uuid, group_guid: uuid):

    action_group: dict[str, object] = await action_link_group(action_guid, group_guid)

    if not action_group:
        raise HTTPException(404, 'Error: The requested entity could not be created!')

    return action_group

@action_router.post('/{action_guid:uuid}/endpoint/{endpoint_guid:uuid}', response_model=ActionEndpointLink, response_model_exclude_unset=True)
async def post(request: Request, action_guid: uuid, endpoint_guid: uuid):

    action_endpoint: dict[str, object] = await action_link_endpoint(action_guid, endpoint_guid)

    if not action_endpoint:
        raise HTTPException(404, 'Error: The requested entity could not be created!')

    return action_endpoint

@action_router.delete('/{action_guid:uuid}/account/{account_guid:uuid}', response_model=ActionAccountLink, response_model_exclude_unset=True)
async def post(request: Request, action_guid: uuid, account_guid: uuid):

    action_account: dict[str, object] = await action_unlink_account(action_guid, account_guid)

    if not action_account:
        raise HTTPException(404, 'Error: The requested entity could not be created!')

    return action_account

@action_router.delete('/{action_guid:uuid}/group/{group_guid:uuid}', response_model=ActionGroupLink, response_model_exclude_unset=True)
async def post(request: Request, action_guid: uuid, group_guid: uuid):

    action_group: dict[str, object] = await action_unlink_group(action_guid, group_guid)

    if not action_group:
        raise HTTPException(404, 'Error: The requested entity could not be created!')

    return action_group

@action_router.delete('/{action_guid:uuid}/endpoint/{endpoint_guid:uuid}', response_model=ActionEndpointLink, response_model_exclude_unset=True)
async def post(request: Request, action_guid: uuid, endpoint_guid: uuid):

    action_endpoint: dict[str, object] = await action_unlink_endpoint(action_guid, endpoint_guid)

    if not action_endpoint:
        raise HTTPException(404, 'Error: The requested entity could not be created!')

    return action_endpoint