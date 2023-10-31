from ._base import BaseModel

class GroupConstrained(BaseModel):
    name: str
    description: str | None
    hidden: bool = False

class GroupOptional(BaseModel):
    name: str = None
    description: str | None = None
    hidden: bool = None