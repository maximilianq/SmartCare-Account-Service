from ._base import BaseModel

class AccountCredentialsConstrained(BaseModel):
    name: str
    description: str | None
    email: str
    username: str
    password: str
    hidden: bool = False

class AccountCredentialsOptional(BaseModel):
    name: str = None
    description: str | None = None
    email: str = None
    username: str = None
    password: str = None
    hidden: bool = None