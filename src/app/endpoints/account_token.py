from app.types import uuid
from app.operations import account_token_list, account_token_read, account_token_create, account_token_update, account_token_delete
from app.models import AccountTokenSimple, AccountTokenInitial, AccountTokenComplex, AccountTokenConstrained, AccountTokenOptional
from app.middlewares import authenticate

from ._base import Router, Request, Depends, HTTPException

account_token_router: Router = Router(prefix='/account/token', dependencies=[Depends(authenticate)], tags=['account_token'])

@account_token_router.get('', response_model=list[AccountTokenSimple], response_model_exclude_unset=True)
async def get(request: Request, hidden: bool = False, deleted: bool = False):

    accounts: list[dict[str, object]] = await account_token_list(hidden, deleted)

    return accounts

@account_token_router.get('/{guid:uuid}', response_model=AccountTokenComplex, response_model_exclude_unset=True)
async def get(request: Request, guid: uuid):

    account: dict[str, object] = await account_token_read(guid)

    if not account:
        raise HTTPException(404, 'Error: The requested entity could not be found!')

    return account

@account_token_router.post('', response_model=AccountTokenInitial, response_model_exclude_unset=True)
async def post(request: Request, data: AccountTokenConstrained):

    account: dict[str, object] = await account_token_create(**data.model_dump())

    if not account:
        raise HTTPException(404, 'Error: The requested entity could not be created!')

    return account

@account_token_router.patch('/{guid:uuid}', response_model=AccountTokenInitial, response_model_exclude_unset=True)
async def patch(request: Request, guid: uuid, data: AccountTokenOptional):

    account: dict[str, object] = await account_token_update(guid=guid, changes=data.model_fields_set, **data.model_dump())

    if not account:
        raise HTTPException(404, 'Error: The requested entity could not be updated!')

    return account

@account_token_router.delete('/{guid:uuid}', response_model=AccountTokenSimple, response_model_exclude_unset=True)
async def delete(request: Request, guid: uuid):

    account: dict[str, object] = await account_token_delete(guid=guid)

    if not account:
        raise HTTPException(404, 'Error: The requested entity could not be deleted!')

    return account