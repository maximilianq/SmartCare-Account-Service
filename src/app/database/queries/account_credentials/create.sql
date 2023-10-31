WITH "generated_random" AS (
    SELECT
        gen_random_bytes(32) AS "salt",
        gen_random_bytes(40) AS "secret"
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
), "result_account_credentials" AS (
    INSERT INTO
        "tables"."account_credentials" ("id", "username", "password", "salt", "secret")
    SELECT
        "account"."id",
        {username} AS "username",
        digest("salt" || {password}::VARCHAR::BYTEA || CAST ("account"."id" AS VARCHAR), 'sha512') AS "password",
        "random"."salt",
        "random"."secret"
    FROM
        "generated_random" AS "random",
        "result_account" AS "account"
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