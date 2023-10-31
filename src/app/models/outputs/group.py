from app.types import uuid, datetime

from ._base import BaseModel

class GroupSimple(BaseModel):
    guid: uuid
    name: str
    description: str | None
    created_at: datetime | None
    modified_at: datetime | None
    deleted_at: datetime | None
    hidden: bool

from .account import AccountSimple
from .action  import ActionSimple

class GroupComplex(BaseModel):
    guid: uuid
    name: str
    description: str | None
    accounts: list[AccountSimple]
    actions: list[ActionSimple]
    created_at: datetime | None
    modified_at: datetime | None
    deleted_at: datetime | None
    hidden: bool

class GroupAccountLink(BaseModel):
    group: GroupSimple
    account: AccountSimple
    created_at: datetime | None
    deleted_at: datetime | None