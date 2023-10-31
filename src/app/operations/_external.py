from app.enums import HTTPMethod

from simplesql import SQLRouter

external_router: SQLRouter = SQLRouter()

async def sign_in_credentials(client: str, username: str, password: str) -> dict[str, object]:
    
    session: dict[str, object] = await external_router.sign_in_credentials(
        client = client,
        username = username,
        password = password
    )
    
    return session

async def verify_credentials(client: str, token: str, otp: str) -> dict[str, object]:
    
    session: dict[str, object] = await external_router.verify_credentials(
        client = client,
        token = token,
        otp = otp
    )
    
    return session

async def sign_in_token(client: str, token: str) -> dict[str, object]:
    
    session: dict[str, object] = await external_router.sign_in_token(
        client = client,
        token = token
    )
    
    return session

async def sign_out(token: str) -> dict[str, object]:
    
    session: dict[str, object] = await external_router.sign_out(
        token = token
    )
    
    return session