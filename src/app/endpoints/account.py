from app.types import uuid
from app.operations import account_list, account_read, group_link_account, action_link_account, group_unlink_account, action_unlink_account
from app.models import AccountSimple, GroupAccountLink, ActionAccountLink, AccountComplex
from app.middlewares import authenticate

from ._base import Router, Request, Depends, HTTPException

account_router: Router = Router(prefix='/account', dependencies=[Depends(authenticate)], tags=['account'])

@account_router.get('', response_model=list[AccountSimple], response_model_exclude_unset=True)
async def get(request: Request, hidden: bool = False, deleted: bool = False):

    accounts: list[dict[str, object]] = await account_list(hidden, deleted)

    return accounts

@account_router.get('/{guid:uuid}', response_model=AccountComplex, response_model_exclude_unset=True)
async def get(request: Request, guid: uuid):

    account: dict[str, object] = await account_read(guid)

    if not account:
        raise HTTPException(404, 'Error: The requested entity could not be found!')

    return account

@account_router.post('/{account_guid:uuid}/group/{group_guid:uuid}', response_model=GroupAccountLink, response_model_exclude_unset=True)
async def post(request: Request, group_guid: uuid, account_guid: uuid):

    group_account: dict[str, object] = await group_link_account(group_guid, account_guid)

    if not group_account:
        raise HTTPException(404, 'Error: The requested entity could not be created!')

    return group_account

@account_router.post('/{account_guid:uuid}/action/{action_guid:uuid}', response_model=ActionAccountLink, response_model_exclude_unset=True)
async def post(request: Request, account_guid: uuid, action_guid: uuid):

    action_account: dict[str, object] = await action_link_account(action_guid, account_guid)

    if not action_account:
        raise HTTPException(404, 'Error: The requested entity could not be created!')

    return action_account

@account_router.delete('/{account_guid:uuid}/group/{group_guid:uuid}', response_model=GroupAccountLink, response_model_exclude_unset=True)
async def post(request: Request, group_guid: uuid, account_guid: uuid):

    group_account: dict[str, object] = await group_unlink_account(group_guid, account_guid)

    if not group_account:
        raise HTTPException(404, 'Error: The requested entity could not be created!')

    return group_account

@account_router.delete('/{account_guid:uuid}/action/{action_guid:uuid}', response_model=ActionAccountLink, response_model_exclude_unset=True)
async def delete(request: Request, account_guid: uuid, action_guid: uuid):

    action_account: dict[str, object] = await action_unlink_account(action_guid, account_guid)

    if not action_account:
        raise HTTPException(404, 'Error: The requested entity could not be created!')

    return action_account