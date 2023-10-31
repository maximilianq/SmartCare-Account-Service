from ._base import BaseModel

class AccountTokenConstrained(BaseModel):
    name: str
    description: str | None
    email: str
    hidden: bool = False

class AccountTokenOptional(BaseModel):
    name: str = None
    description: str | None = None
    email: str = None
    token: bool = None
    hidden: bool = None