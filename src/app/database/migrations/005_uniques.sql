CREATE UNIQUE INDEX "account_email_unique"
ON "tables"."account"("email")
WHERE "deleted_at" IS NULL;

CREATE OR REPLACE FUNCTION account_credentials_username_unique_function() RETURNS TRIGGER AS
$$
BEGIN
    PERFORM
        *
    FROM
        "tables"."account" JOIN "tables"."account_credentials" ON "account"."id" = "account_credentials"."id"
    WHERE
        "account_credentials"."id" <> NEW."id" AND "account_credentials"."username" = NEW."username" AND "account"."deleted_at" IS NULL;
    
    IF found THEN
        RAISE unique_violation USING MESSAGE = ('duplicate key value violates unique constraint "account_credentials_username_unique"'), DETAIL = ('Key (username)=(' || NEW.username || ') already exists.');
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER account_credentials_username_unique
BEFORE INSERT OR UPDATE ON "tables"."account_credentials"
FOR EACH ROW EXECUTE PROCEDURE account_credentials_username_unique_function();

CREATE OR REPLACE FUNCTION account_token_token_unique_function() RETURNS TRIGGER AS
$$
BEGIN
    PERFORM
        *
    FROM
        "tables"."account" JOIN "tables"."account_token" ON "account"."id" = "account_token"."id"
    WHERE
        "account_token"."id" <> NEW."id" AND "account_token"."token" = NEW."token" AND "account"."deleted_at" IS NULL;
    
    IF found THEN
        RAISE unique_violation USING MESSAGE = ('duplicate key value violates unique constraint "account_token_token_unique"'), DETAIL = ('Key (token)=(' || NEW.token || ') already exists.');
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER account_token_token_unique
BEFORE INSERT OR UPDATE ON "tables"."account_token"
FOR EACH ROW EXECUTE PROCEDURE account_token_token_unique_function();

CREATE UNIQUE INDEX "group_account_unique"
ON "relations"."group_account"("group_id", "account_id")
WHERE "deleted_at" IS NULL;

CREATE UNIQUE INDEX "endpoint_url_method_unique"
ON "tables"."endpoint"("url", "method")
WHERE "deleted_at" IS NULL;

CREATE UNIQUE INDEX "action_endpoint_unique"
ON "relations"."action_endpoint"("action_id", "endpoint_id")
WHERE "deleted_at" IS NULL;

CREATE UNIQUE INDEX "action_account_unique"
ON "relations"."action_account"("action_id", "account_id")
WHERE "deleted_at" IS NULL;

CREATE UNIQUE INDEX "action_group_unique"
ON "relations"."action_group"("action_id", "group_id")
WHERE "deleted_at" IS NULL;

CREATE UNIQUE INDEX "session_access_unique"
ON "tables"."session"("token")
WHERE "deleted_at" IS NULL;