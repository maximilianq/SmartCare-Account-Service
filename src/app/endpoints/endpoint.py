from app.types import uuid
from app.operations import endpoint_list, endpoint_read, endpoint_create, endpoint_update, endpoint_delete, action_link_endpoint, action_unlink_endpoint
from app.models import EndpointSimple, EndpointComplex, EndpointConstrained, EndpointOptional, ActionEndpointLink
from app.middlewares import authenticate

from ._base import Router, Request, Depends, HTTPException

endpoint_router: Router = Router(prefix='/endpoint', dependencies=[Depends(authenticate)], tags=['endpoint'])

@endpoint_router.get('', response_model=list[EndpointSimple], response_model_exclude_unset=True)
async def get(request: Request, hidden: bool = False, deleted: bool = False):

    endpoints: list[dict[str, object]] = await endpoint_list(hidden, deleted)

    return endpoints

@endpoint_router.get('/{guid:uuid}', response_model=EndpointComplex, response_model_exclude_unset=True)
async def get(request: Request, guid: uuid):

    endpoint: dict[str, object] = await endpoint_read(guid)

    if not endpoint:
        raise HTTPException(404, 'Error: The requested entity could not be found!')

    return endpoint

@endpoint_router.post('', response_model=EndpointSimple, response_model_exclude_unset=True)
async def post(request: Request, data: EndpointConstrained):

    endpoint: dict[str, object] = await endpoint_create(**data.model_dump())

    if not endpoint:
        raise HTTPException(404, 'Error: The requested entity could not be created!')

    return endpoint

@endpoint_router.patch('/{guid:uuid}', response_model=EndpointSimple, response_model_exclude_unset=True)
async def patch(request: Request, guid: uuid, data: EndpointOptional):

    endpoint: dict[str, object] = await endpoint_update(guid=guid, changes=data.model_fields_set, **data.model_dump())

    if not endpoint:
        raise HTTPException(404, 'Error: The requested entity could not be updated!')

    return endpoint

@endpoint_router.delete('/{guid:uuid}', response_model=EndpointSimple, response_model_exclude_unset=True)
async def delete(request: Request, guid: uuid):

    endpoint: dict[str, object] = await endpoint_delete(guid=guid)

    if not endpoint:
        raise HTTPException(404, 'Error: The requested entity could not be deleted!')

    return endpoint

@endpoint_router.post('/{endpoint_guid:uuid}/action/{action_guid:uuid}', response_model=ActionEndpointLink, response_model_exclude_unset=True)
async def post(request: Request, endpoint_guid: uuid, action_guid: uuid):

    action_endpoint: dict[str, object] = await action_link_endpoint(action_guid, endpoint_guid)

    if not action_endpoint:
        raise HTTPException(404, 'Error: The requested entity could not be created!')

    return action_endpoint

@endpoint_router.delete('/{endpoint_guid:uuid}/action/{action_guid:uuid}', response_model=ActionEndpointLink, response_model_exclude_unset=True)
async def delete(request: Request, endpoint_guid: uuid, action_guid: uuid):

    action_endpoint: dict[str, object] = await action_unlink_endpoint(action_guid, endpoint_guid)

    if not action_endpoint:
        raise HTTPException(404, 'Error: The requested entity could not be created!')

    return action_endpoint