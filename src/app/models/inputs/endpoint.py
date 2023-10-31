from app.enums import HTTPMethod

from ._base import BaseModel

class EndpointConstrained(BaseModel):
    url: str
    method: HTTPMethod
    hidden: bool = False

class EndpointOptional(BaseModel):
    url: str = None
    method: HTTPMethod = None
    hidden: bool = None