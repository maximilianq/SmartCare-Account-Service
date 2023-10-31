from app.types import uuid
from app.operations import session_list, session_read, session_create, session_update, session_delete
from app.models import SessionSimple, SessionInitial, SessionComplex, SessionConstrained, SessionOptional
from app.middlewares import authenticate

from ._base import Router, Request, Depends, HTTPException

session_router: Router = Router(prefix='/session', dependencies=[Depends(authenticate)], tags=['session'])

@session_router.get('', response_model=list[SessionSimple], response_model_exclude_unset=True)
async def get(request: Request, hidden: bool = False, deleted: bool = False):

    sessions: list[dict[str, object]] = await session_list(hidden, deleted)

    return sessions

@session_router.get('/{guid:uuid}', response_model=SessionComplex, response_model_exclude_unset=True)
async def get(request: Request, guid: uuid):

    session: dict[str, object] = await session_read(guid)

    if not session:
        raise HTTPException(404, 'Error: The requested entity could not be found!')

    return session

@session_router.post('', response_model=SessionInitial, response_model_exclude_unset=True)
async def post(request: Request, data: SessionConstrained):

    session: dict[str, object] = await session_create(**data.model_dump())

    if not session:
        raise HTTPException(404, 'Error: The requested entity could not be created!')

    return session

@session_router.patch('/{guid:uuid}', response_model=SessionSimple, response_model_exclude_unset=True)
async def patch(request: Request, guid: uuid):

    session: dict[str, object] = await session_update(guid=guid)

    if not session:
        raise HTTPException(404, 'Error: The requested entity could not be updated!')

    return session

@session_router.delete('/{guid:uuid}', response_model=SessionSimple, response_model_exclude_unset=True)
async def delete(request: Request, guid: uuid):

    session: dict[str, object] = await session_delete(guid=guid)

    if not session:
        raise HTTPException(404, 'Error: The requested entity could not be deleted!')

    return session