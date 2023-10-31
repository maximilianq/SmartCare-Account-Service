from app.types import uuid

from ._base import BaseModel

class SessionConstrained(BaseModel):
    account_guid: uuid
    strong: bool = False
    client: str
    hidden: bool = False

class SessionOptional(BaseModel):
    strong: bool = False
    hidden: bool = None