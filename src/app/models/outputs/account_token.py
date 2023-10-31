from app.types import uuid, datetime

from ._base import BaseModel

class AccountTokenSimple(BaseModel):
    guid: uuid
    name: str
    description: str | None
    email: str
    created_at: datetime | None
    modified_at: datetime | None
    deleted_at: datetime | None
    hidden: bool

class AccountTokenInitial(BaseModel):
    guid: uuid
    name: str
    description: str | None
    email: str
    token: str = None
    created_at: datetime | None
    modified_at: datetime | None
    deleted_at: datetime | None
    hidden: bool

from .action import ActionSimple
from .group import GroupSimple
from .session import SessionSimple

class AccountTokenComplex(BaseModel):
    guid: uuid
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