from app.types import uuid, datetime

from ._base import BaseModel

class AccountCredentialsSimple(BaseModel):
    guid: uuid
    name: str
    description: str | None
    email: str
    username: str
    created_at: datetime | None
    modified_at: datetime | None
    deleted_at: datetime | None
    hidden: bool

from .action import ActionSimple
from .group import GroupSimple
from .session import SessionSimple

class AccountCredentialsComplex(BaseModel):
    guid: uuid
    name: str
    description: str | None
    email: str
    username: str
    actions: list[ActionSimple]
    groups: list[GroupSimple]
    sessions: list[SessionSimple]
    created_at: datetime | None
    modified_at: datetime | None
    deleted_at: datetime | None
    hidden: bool