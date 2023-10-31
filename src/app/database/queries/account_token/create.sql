WITH "generated_random" AS (
    SELECT
        gen_random_bytes(64) AS "token"
), "result_account" AS (
    INSERT INTO
        "tables"."account" ("name", "description", "email", "hidden")
    SELECT
        {name} AS "name",
        {description} AS "description",
        {email} AS "email",
        {hidden} AS "hidden"
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
    INSERT INTO
        "tables"."account_token" ("id", "token")
    SELECT
        "account"."id",
        "random"."token"
    FROM
        "generated_random" AS "random",
        "result_account" AS "account"
    RETURNING
        "account_token"."token"
)
SELECT
    json_build_object(
        'guid', "account"."guid",
        'name', "account"."name",
        'description', "account"."description",
        'email', "account"."email",
        'token', UPPER(encode("account_token"."token", 'hex')),
        'created_at', "account"."created_at",
        'modified_at', "account"."modified_at",
        'deleted_at', "account"."deleted_at",
        'hidden', "account"."hidden"
    )
FROM
    "result_account" AS "account",
    "result_account_token" AS "account_token";