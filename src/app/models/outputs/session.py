from app.types import uuid, datetime

from ._base import BaseModel

class SessionSimple(BaseModel):
    guid: uuid
    client: str
    strong: bool
    created_at: datetime | None
    modified_at: datetime | None
    deleted_at: datetime | None
    hidden: bool

class SessionInitial(BaseModel):
    guid: uuid
    client: str
    token: str
    strong: bool
    created_at: datetime | None
    modified_at: datetime | None
    deleted_at: datetime | None
    hidden: bool

from .account import AccountSimple

class SessionComplex(BaseModel):
    guid: uuid
    account: AccountSimple
    client: str
    strong: bool
    created_at: datetime | None
    modified_at: datetime | None
    deleted_at: datetime | None
    hidden: bool