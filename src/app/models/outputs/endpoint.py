from app.types import uuid, datetime
from app.enums import HTTPMethod

from ._base import BaseModel

class EndpointSimple(BaseModel):
    guid: uuid
    url: str
    method: HTTPMethod
    created_at: datetime | None
    modified_at: datetime | None
    deleted_at: datetime | None
    hidden: bool

from .action import ActionSimple

class EndpointComplex(BaseModel):
    guid: uuid
    url: str
    method: HTTPMethod
    actions: list[ActionSimple]
    created_at: datetime | None
    modified_at: datetime | None
    deleted_at: datetime | None
    hidden: bool
