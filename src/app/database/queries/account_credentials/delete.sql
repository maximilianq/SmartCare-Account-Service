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
), "result_account_credentials" AS (
    UPDATE
        "tables"."account_credentials"
    SET
        "id" = "account_credentials"."id"
    FROM
        "result_account" AS "account"
    WHERE
        "account_credentials"."id" = "account"."id"
    RETURNING
        "account_credentials"."username",
        "account_credentials"."password",
        "account_credentials"."salt",
        "account_credentials"."secret"
)
SELECT
    json_build_object(
        'guid', "account"."guid",
        'name', "account"."name",
        'description', "account"."description",
        'email', "account"."email",
        'username', "account_credentials"."username",
        'created_at', "account"."created_at",
        'modified_at', "account"."modified_at",
        'deleted_at', "account"."deleted_at",
        'hidden', "account"."hidden"
    )
FROM
    "result_account" AS "account",
    "result_account_credentials" AS "account_credentials";