from ._base import BaseModel

class SignInCredentialsConstrained(BaseModel):
    username: str
    password: str

class VerifyCredentialsConstrained(BaseModel):
    otp: str

class SignInTokenConstrained(BaseModel):
    token: str