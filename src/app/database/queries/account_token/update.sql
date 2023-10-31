WITH "generated_random" AS (
    SELECT
        gen_random_bytes(32) AS "token"
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
), "result_account_token" AS (
    UPDATE
        "tables"."account_token"
    SET
        "token" = CASE WHEN {token_set} THEN "random"."token" ELSE "account_token"."token" END
    FROM
        "result_account" AS "account",
        "generated_random" AS "random"
    WHERE
        "account_token"."id" = "account"."id"
    RETURNING
        "account_token"."token"
)
SELECT
    CASE WHEN {token_set} THEN
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
    ELSE
        json_build_object(
            'guid', "account"."guid",
            'name', "account"."name",
            'description', "account"."description",
            'email', "account"."email",
            'created_at', "account"."created_at",
            'modified_at', "account"."modified_at",
            'deleted_at', "account"."deleted_at",
            'hidden', "account"."hidden"
        )
    END
FROM
    "result_account" AS "account",
    "result_account_token" AS "account_token";