WITH "result_account" AS (
    UPDATE
        "tables"."account"
    SET
        "deleted_at" = CURRENT_TIMESTAMP
    WHERE
        "account"."guid" = {guid} AND
        "account"."deleted_at" IS NULL
    RETURNING
        "account"."id",
        "account"."guid",
        "account"."name",
        "account"."description",
        "account"."email",
        "account"."created_at",
        "account"."modified_at",
        "account"."deleted_at",
        "account"."hidden"
), "result_account_token" AS (
    SELECT
        "account_token"."token"
    FROM
        "result_account" AS "account"
            JOIN "tables"."account_token"
                ON "account"."id" = "account_token"."id"
)
SELECT
    json_build_object(
        'guid', "account"."guid",
        'name', "account"."name",
        'description', "account"."description",
        'email', "account"."email",
        'token', "account_token"."token",
        'created_at', "account"."created_at",
        'modified_at', "account"."modified_at",
        'deleted_at', "account"."deleted_at",
        'hidden', "account"."hidden"
    )
FROM
    "result_account" AS "account",
    "result_account_token" AS "account_token";