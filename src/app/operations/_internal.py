from app.enums import HTTPMethod

from simplesql import SQLRouter

internal_router: SQLRouter = SQLRouter()

async def authorize(client: str, token: str, url: str, method: HTTPMethod) -> list[dict[str, object]]:

    account: dict[str, object] = await internal_router.authorize(
        client = client,
        token = token,
        url = url,
        method = method.value
    )

    return account