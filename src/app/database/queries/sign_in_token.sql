WITH "result_account" AS (
    SELECT
        "account"."id",
        "account"."guid",
        "account"."name",
        "account"."description",
        "account"."email",
        "account"."created_at",
        "account"."modified_at",
        "account"."deleted_at",
        "account"."hidden"
    FROM
        "tables"."account"
            JOIN "tables"."account_token"
                ON "account"."id" = "account_token"."id"
    WHERE
        "account_token"."token" = decode({token}::VARCHAR, 'hex') AND
        "account"."deleted_at" IS NULL AND
        NOT "account"."hidden"
), "result_session" AS (
    INSERT INTO
        "tables"."session" ("account_id", "client", "token", "strong")
    SELECT
        "account"."id",
        {client} AS "client",
        gen_random_bytes(64) AS "token",
        TRUE
    FROM
        "result_account" AS "account"
    RETURNING
        "session"."id",
        "session"."guid",
        "session"."client",
        "session"."token",
        "session"."strong",
        "session"."created_at",
        "session"."modified_at",
        "session"."deleted_at",
        "session"."hidden"
), "json_account" AS (
    SELECT
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
        ) AS "json"
    FROM
        "result_account" AS "account"
)
SELECT
    json_build_object(
        'guid', "session"."guid",
        'account', "json_account"."json",
        'client', "session"."client",
        'token', UPPER(encode("session"."token", 'hex')),
        'strong', "session"."strong",
        'created_at', "session"."created_at",
        'modified_at', "session"."modified_at",
        'deleted_at', "session"."deleted_at",
        'hidden', "session"."hidden"
    )
FROM
    "result_session" AS "session",
    "json_account";