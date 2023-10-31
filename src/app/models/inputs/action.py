from ._base import BaseModel

class ActionConstrained(BaseModel):
    name: str
    description: str | None
    hidden: bool = False

class ActionOptional(BaseModel):
    name: str = None
    description: str | None = None
    hidden: bool = None