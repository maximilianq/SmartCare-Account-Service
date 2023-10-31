CREATE OR REPLACE FUNCTION account_notification_function() RETURNS TRIGGER AS
$$
DECLARE
  "output" JSON;
  "event" TEXT;
BEGIN

    SELECT
        json_build_object(
            'guid', NEW."guid",
            'type', 
                CASE
                    WHEN EXISTS (SELECT * FROM "tables"."account_credentials" WHERE "id" = NEW."id") THEN 'CREDENTIALS'
                    WHEN EXISTS (SELECT * FROM "tables"."account_token" WHERE "id" = NEW."id") THEN 'TOKEN'
                END,
            'name', NEW."name",
            'description', NEW."description",
            'email', NEW."email",
            'created_at', NEW."created_at",
            'modified_at', NEW."modified_at",
            'deleted_at', NEW."deleted_at",
            'hidden', NEW."hidden"
        ),
        CASE
            WHEN NEW."deleted_at" IS NOT NULL THEN 'deleted'
            WHEN NEW."modified_at" IS NOT NULL THEN 'updated'
            WHEN NEW."created_at" IS NOT NULL THEN 'created'
        END
    INTO
        "output", "event";

    PERFORM pg_notify('account_' || "event", output::TEXT);

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER account_notification
AFTER INSERT OR UPDATE ON "tables"."account"
FOR EACH ROW EXECUTE PROCEDURE account_notification_function();

CREATE OR REPLACE FUNCTION account_credentials_notification_function() RETURNS TRIGGER AS
$$
DECLARE
  "output" JSON;
  "event" TEXT;
BEGIN

    SELECT
        json_build_object(
            'guid', "account"."guid",
            'name', "account"."name",
            'description', "account"."description",
            'email', "account"."email",
            'username', NEW."username",
            'created_at', "account"."created_at",
            'modified_at', "account"."modified_at",
            'deleted_at', "account"."deleted_at",
            'hidden', "account"."hidden"
        ),
        CASE
            WHEN "account"."deleted_at" IS NOT NULL THEN 'deleted'
            WHEN "account"."modified_at" IS NOT NULL THEN 'updated'
            WHEN "account"."created_at" IS NOT NULL THEN 'created'
        END
    INTO
        "output", "event"
    FROM
        "tables"."account"
    WHERE
        "id" = NEW."id";

    PERFORM pg_notify('account_credentials_' || "event", output::TEXT);

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER account_credentials_notification
AFTER INSERT OR UPDATE ON "tables"."account_credentials"
FOR EACH ROW EXECUTE PROCEDURE account_credentials_notification_function();

CREATE OR REPLACE FUNCTION account_token_notification_function() RETURNS TRIGGER AS
$$
DECLARE
  "output" JSON;
  "event" TEXT;
BEGIN

    SELECT
        json_build_object(
            'guid', "account"."guid",
            'name', "account"."name",
            'description', "account"."description",
            'email', "account"."email",
            'created_at', "account"."created_at",
            'modified_at', "account"."modified_at",
            'deleted_at', "account"."deleted_at",
            'hidden', "account"."hidden"
        ),
        CASE
            WHEN "account"."deleted_at" IS NOT NULL THEN 'deleted'
            WHEN "account"."modified_at" IS NOT NULL THEN 'updated'
            WHEN "account"."created_at" IS NOT NULL THEN 'created'
        END
    INTO
        "output", "event"
    FROM
        "tables"."account"
    WHERE
        "id" = NEW."id";

    PERFORM pg_notify('account_token_' || "event", output::TEXT);

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER account_token_notification
AFTER INSERT OR UPDATE ON "tables"."account_token"
FOR EACH ROW EXECUTE PROCEDURE account_token_notification_function();

CREATE OR REPLACE FUNCTION group_notification_function() RETURNS TRIGGER AS
$$
DECLARE
  "output" JSON;
  "event" TEXT;
BEGIN

    SELECT
        json_build_object(
            'guid', NEW."guid",
            'name', NEW."name",
            'description', NEW."description",
            'created_at', NEW."created_at",
            'modified_at', NEW."modified_at",
            'deleted_at', NEW."deleted_at",
            'hidden', NEW."hidden"
        ),
        CASE
            WHEN NEW."deleted_at" IS NOT NULL THEN 'deleted'
            WHEN NEW."modified_at" IS NOT NULL THEN 'updated'
            WHEN NEW."created_at" IS NOT NULL THEN 'created'
        END
    INTO
        "output", "event";

    PERFORM pg_notify('group_' || "event", output::TEXT);

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER group_notification
AFTER INSERT OR UPDATE ON "tables"."group"
FOR EACH ROW EXECUTE PROCEDURE group_notification_function();

CREATE OR REPLACE FUNCTION action_notification_function() RETURNS TRIGGER AS
$$
DECLARE
  "output" JSON;
  "event" TEXT;
BEGIN

    SELECT
        json_build_object(
            'guid', NEW."guid",
            'name', NEW."name",
            'description', NEW."description",
            'created_at', NEW."created_at",
            'modified_at', NEW."modified_at",
            'deleted_at', NEW."deleted_at",
            'hidden', NEW."hidden"
        ),
        CASE
            WHEN NEW."deleted_at" IS NOT NULL THEN 'deleted'
            WHEN NEW."modified_at" IS NOT NULL THEN 'updated'
            WHEN NEW."created_at" IS NOT NULL THEN 'created'
        END
    INTO
        "output", "event";

    PERFORM pg_notify('action_' || "event", output::TEXT);

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER action_notification
AFTER INSERT OR UPDATE ON "tables"."action"
FOR EACH ROW EXECUTE PROCEDURE action_notification_function();

CREATE OR REPLACE FUNCTION endpoint_notification_function() RETURNS TRIGGER AS
$$
DECLARE
  "output" JSON;
  "event" TEXT;
BEGIN

    SELECT
        json_build_object(
            'guid', NEW."guid",
            'url', NEW."url",
            'method', NEW."method",
            'created_at', NEW."created_at",
            'modified_at', NEW."modified_at",
            'deleted_at', NEW."deleted_at",
            'hidden', NEW."hidden"
        ),
        CASE
            WHEN NEW."deleted_at" IS NOT NULL THEN 'deleted'
            WHEN NEW."modified_at" IS NOT NULL THEN 'updated'
            WHEN NEW."created_at" IS NOT NULL THEN 'created'
        END
    INTO
        "output", "event";

    PERFORM pg_notify('endpoint_' || "event", output::TEXT);

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER endpoint_notification
AFTER INSERT OR UPDATE ON "tables"."endpoint"
FOR EACH ROW EXECUTE PROCEDURE endpoint_notification_function();

CREATE OR REPLACE FUNCTION session_notification_function() RETURNS TRIGGER AS
$$
DECLARE
  "output" JSON;
  "event" TEXT;
BEGIN

    SELECT
        json_build_object(
            'guid', NEW."guid",
            'client', NEW."client",
            'created_at', NEW."created_at",
            'modified_at', NEW."modified_at",
            'deleted_at', NEW."deleted_at",
            'hidden', NEW."hidden"
        ),
        CASE
            WHEN NEW."deleted_at" IS NOT NULL THEN 'deleted'
            WHEN NEW."modified_at" IS NOT NULL THEN 'updated'
            WHEN NEW."created_at" IS NOT NULL THEN 'created'
        END
    INTO
        "output", "event";

    PERFORM pg_notify('session_' || "event", output::TEXT);

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER session_notification
AFTER INSERT OR UPDATE ON "tables"."session"
FOR EACH ROW EXECUTE PROCEDURE session_notification_function();