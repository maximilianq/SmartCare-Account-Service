from app.types import uuid, datetime
from app.enums import AccountType

from ._base import BaseModel

class AccountSimple(BaseModel):
    guid: uuid
    type: AccountType
    name: str
    description: str | None
    email: str
    created_at: datetime | None
    modified_at: datetime | None
    deleted_at: datetime | None
    hidden: bool

from .action import ActionSimple
from .group import GroupSimple
from .session import SessionSimple

class AccountComplex(BaseModel):
    guid: uuid
    type: AccountType
    name: str
    description: str | None
    email: str
    actions: list[ActionSimple]
    groups: list[GroupSimple]
    sessions: list[SessionSimple]
    created_at: datetime | None
    modified_at: datetime | None
    deleted_at: datetime | None
    hidden: bool