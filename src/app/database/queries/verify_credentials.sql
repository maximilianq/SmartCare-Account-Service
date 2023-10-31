WITH "result_session" AS (
    UPDATE
        "tables"."session"
    SET
        "strong" = TRUE,
        "modified_at" = CURRENT_TIMESTAMP
    FROM
        "tables"."account_credentials"
    WHERE
        "session"."account_id" = "account_credentials"."id" AND
        "session"."client" = {client} AND
        "session"."token" = decode({token}::VARCHAR, 'hex') AND
        verify_totp("account_credentials"."secret", {otp}) AND
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
            JOIN "tables"."account_credentials"
                ON "account"."id" = "account_credentials"."id"
), "json_account" AS (
    SELECT
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
        ) AS "json"
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