WITH "result_session" AS (
    UPDATE
        "tables"."session"
    SET
        "deleted_at" = CURRENT_TIMESTAMP
    WHERE
        "session"."token" = decode({token}::VARCHAR, 'hex') AND
        "session"."deleted_at" IS NULL
    RETURNING
        "session"."id",
        "session"."guid",
        "session"."client",
        "session"."account_id",
        "session"."token",
        "session"."strong",
        "session"."created_at",
        "session"."modified_at",
        "session"."deleted_at",
        "session"."hidden"
), "result_account" AS (
    SELECT
        "account"."id",
        "account"."guid",
        CASE
            WHEN "account_credentials"."id" IS NOT NULL THEN 'CREDENTIALS'
            WHEN "account_token"."id" IS NOT NULL THEN 'TOKEN'
        END AS "type",
        "account"."name",
        "account"."description",
        "account"."email",
        "account_credentials"."username",
        "account"."created_at",
        "account"."modified_at",
        "account"."deleted_at",
        "account"."hidden"
    FROM
        "result_session"
            JOIN "tables"."account"
                ON "result_session"."account_id" = "account"."id"
                AND "account"."deleted_at" IS NULL
                AND NOT "account"."hidden"
            LEFT JOIN "tables"."account_credentials"
                ON "account"."id" = "account_credentials"."id"
            LEFT JOIN "tables"."account_token"
                ON "account"."id" = "account_token"."id"
    WHERE
        ("account_credentials"."id" IS NOT NULL OR "account_token"."id" IS NOT NULL)
), "json_account" AS (
    SELECT
        CASE
            WHEN "account"."type" = 'CREDENTIALS' THEN
                json_build_object(
                    'guid', "account"."guid",
                    'type', 'CREDENTIALS',
                    'name', "account"."name",
                    'description', "account"."description",
                    'email', "account"."email",
                    'username', "account"."username",
                    'created_at', "account"."created_at",
                    'modified_at', "account"."modified_at",
                    'deleted_at', "account"."deleted_at",
                    'hidden', "account"."hidden"
                )
            WHEN "account"."type" = 'TOKEN' THEN
                json_build_object(
                    'guid', "account"."guid",
                    'type', 'TOKEN',
                    'name', "account"."name",
                    'description', "account"."description",
                    'email', "account"."email",
                    'created_at', "account"."created_at",
                    'modified_at', "account"."modified_at",
                    'deleted_at', "account"."deleted_at",
                    'hidden', "account"."hidden"
                )
        END AS "json"
    FROM
        "result_account" AS "account"
)
SELECT
    json_build_object(
        'guid', "session"."guid",
        'account', "json_account"."json",
        'client', "session"."client",
        'strong', "session"."strong",
        'created_at', "session"."created_at",
        'modified_at', "session"."modified_at",
        'deleted_at', "session"."deleted_at",
        'hidden', "session"."hidden"
    )
FROM
    "result_session" AS "session",
    "json_account";