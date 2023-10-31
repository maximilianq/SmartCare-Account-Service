from app.operations import sign_in_credentials, verify_credentials, sign_in_token, sign_out
from app.models import SignInCredentialsConstrained, VerifyCredentialsConstrained, SignInTokenConstrained

from ._base import Router, Request, Response, Cookie, HTTPException

external_router: Router = Router(tags=['external'])

@external_router.post('/sign-in/credentials')
async def post(request: Request, response: Response, data: SignInCredentialsConstrained):

    session: dict[str, object] = await sign_in_credentials(request.client.host, **data.model_dump())

    if not session:
        raise HTTPException(403, 'Error: The entered username or password is incorrect!')

    response.set_cookie('SYSCARE_TOKEN', session['token'])

@external_router.post('/verify/credentials')
async def post(request: Request, data: VerifyCredentialsConstrained, token: str = Cookie(alias='SYSCARE_TOKEN')):

    session: dict[str, object] = await verify_credentials(client=request.client.host, token=token, **data.model_dump())

    if not session:
        raise HTTPException(403, 'Error: The session is invalid or the entered otp is incorrect!')

@external_router.post('/sign-in/token')
async def post(request: Request, response: Response, data: SignInTokenConstrained):

    session: dict[str, object] = await sign_in_token(request.client.host, **data.model_dump())

    if not session:
        raise HTTPException(403, 'Error: The entered token is incorrect!')

    response.set_cookie('SYSCARE_TOKEN', session['token'])

@external_router.post('/sign-out')
async def post(request: Request, token: str = Cookie(alias='SYSCARE_TOKEN')):

    session: dict[str, object] = await sign_out(token=token)

    if not session:
        raise HTTPException(403, 'Error: The session is invalid!')
