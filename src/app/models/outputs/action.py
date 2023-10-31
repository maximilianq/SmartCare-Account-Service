from app.types import uuid, datetime

from ._base import BaseModel

class ActionSimple(BaseModel):
    guid: uuid
    name: str
    description: str | None
    created_at: datetime | None
    modified_at: datetime | None
    deleted_at: datetime | None
    hidden: bool

from .account import AccountSimple
from .group import GroupSimple
from .endpoint import EndpointSimple

class ActionComplex(BaseModel):
    guid: uuid
    name: str
    description: str | None
    accounts: list[AccountSimple]
    groups: list[GroupSimple]
    endpoints: list[EndpointSimple]
    created_at: datetime | None
    modified_at: datetime | None
    deleted_at: datetime | None
    hidden: bool

class ActionAccountLink(BaseModel):
    action: ActionSimple
    account: AccountSimple
    created_at: datetime | None
    deleted_at: datetime | None

class ActionGroupLink(BaseModel):
    action: ActionSimple
    group: GroupSimple
    created_at: datetime | None
    deleted_at: datetime | None

class ActionEndpointLink(BaseModel):
    action: ActionSimple
    endpoint: EndpointSimple
    created_at: datetime | None
    deleted_at: datetime | None