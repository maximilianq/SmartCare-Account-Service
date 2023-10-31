from enum import Enum

class HTTPMethod(Enum):
    GET: str = 'GET'
    POST: str = 'POST'
    PATCH: str = 'PATCH'
    DELETE: str = 'DELETE'