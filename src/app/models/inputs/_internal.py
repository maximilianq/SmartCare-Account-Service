from app.enums import HTTPMethod

from ._base import BaseModel

class AuthenticateConstrained(BaseModel):
    client: str
    token: str
    url: str
    method: HTTPMethod