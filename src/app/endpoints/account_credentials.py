from app.types import uuid
from app.operations import account_credentials_list, account_credentials_read, account_credentials_create, account_credentials_update, account_credentials_delete
from app.models import AccountCredentialsSimple, AccountCredentialsComplex, AccountCredentialsConstrained, AccountCredentialsOptional
from app.middlewares import authenticate

from ._base import Router, Request, Depends, HTTPException

account_credentials_router: Router = Router(prefix='/account/credentials', dependencies=[Depends(authenticate)], tags=['account_credentials'])

@account_credentials_router.get('', response_model=list[AccountCredentialsSimple], response_model_exclude_unset=True)
async def get(request: Request, hidden: bool = False, deleted: bool = False):

    accounts: list[dict[str, object]] = await account_credentials_list(hidden, deleted)

    return accounts

@account_credentials_router.get('/{guid:uuid}', response_model=AccountCredentialsComplex, response_model_exclude_unset=True)
async def get(request: Request, guid: uuid):

    account: dict[str, object] = await account_credentials_read(guid)

    if not account:
        raise HTTPException(404, 'Error: The requested entity could not be found!')

    return account

@account_credentials_router.post('', response_model=AccountCredentialsSimple, response_model_exclude_unset=True)
async def post(request: Request, data: AccountCredentialsConstrained):

    account: dict[str, object] = await account_credentials_create(**data.model_dump())

    if not account:
        raise HTTPException(404, 'Error: The requested entity could not be created!')

    return account

@account_credentials_router.patch('/{guid:uuid}', response_model=AccountCredentialsSimple, response_model_exclude_unset=True)
async def patch(request: Request, guid: uuid, data: AccountCredentialsOptional):

    account: dict[str, object] = await account_credentials_update(guid=guid, changes=data.model_fields_set, **data.model_dump())

    if not account:
        raise HTTPException(404, 'Error: The requested entity could not be updated!')

    return account

@account_credentials_router.delete('/{guid:uuid}', response_model=AccountCredentialsSimple, response_model_exclude_unset=True)
async def delete(request: Request, guid: uuid):

    account: dict[str, object] = await account_credentials_delete(guid=guid)

    if not account:
        raise HTTPException(404, 'Error: The requested entity could not be deleted!')

    return account