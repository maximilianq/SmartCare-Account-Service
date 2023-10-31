WITH "generated_random" AS (
    SELECT
        gen_random_bytes(32) AS "salt",
        gen_random_bytes(40) AS "secret"
), "result_account" AS (
    UPDATE
        "tables"."account"
    SET
        "name" = CASE WHEN {name_set} THEN {name} ELSE "name" END,
        "description" = CASE WHEN {description_set} THEN {description} ELSE "description" END,
        "email" = CASE WHEN {email_set} THEN {email} ELSE "email" END,
        "modified_at" = CURRENT_TIMESTAMP,
        "hidden" = CASE WHEN {hidden_set} THEN {hidden} ELSE "hidden" END
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
        "username" = CASE WHEN {username_set} THEN {username} ELSE "username" END,
        "password" = CASE WHEN {password_set} THEN digest("random"."salt" || {password}::VARCHAR::BYTEA || CAST ("account"."id" AS VARCHAR), 'sha512') ELSE "password" END,
        "salt" = CASE WHEN {password_set} THEN "random"."salt" ELSE "account_credentials"."salt" END,
        "secret" = CASE WHEN {secret_set} THEN "random"."secret" ELSE "account_credentials"."secret" END
    FROM
        "result_account" AS "account",
        "generated_random" AS "random"
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