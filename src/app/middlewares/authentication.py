from app.operations import authorize
from app.enums import HTTPMethod

from ._base import Request, Cookie, HTTPException

from logging import Logger, getLogger

logger: Logger = getLogger('uvicorn.error')

async def authenticate(request: Request, token: str = Cookie(alias='SYSCARE_TOKEN')):

    client: str = request.client.host
    url: str = request.scope['route'].path
    method: str = HTTPMethod(request.method)

    account: dict[str, object] = await authorize(client, token, url, method)

    if not account:
        raise HTTPException(403, 'access to requested recource is not authorized.')
    
    logger.debug(f'Authenticated as user {account["guid"]}.')

    request.account = account["guid"]
    