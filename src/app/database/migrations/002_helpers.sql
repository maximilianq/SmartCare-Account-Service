CREATE OR REPLACE FUNCTION verify_totp(secret BYTEA, code VARCHAR)
  RETURNS BOOLEAN
AS $$
    from pyotp import TOTP
    from base64 import b32encode
    totp: TOTP = TOTP(b32encode(secret))
    return totp.verify(code)
$$ LANGUAGE plpython3u;

CREATE OR REPLACE FUNCTION share_totp(secret BYTEA, username VARCHAR, issuer VARCHAR)
  RETURNS VARCHAR
AS $$
    from pyotp import TOTP
    from base64 import b32encode
    totp: TOTP = TOTP(b32encode(secret))
    return totp.provisioning_uri(name=username, issuer_name=issuer)
$$ LANGUAGE plpython3u;