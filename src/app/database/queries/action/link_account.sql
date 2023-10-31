WITH "result_action" AS (
    SELECT
        "action"."id",
        "action"."guid",
        "action"."name",
        "action"."description",
        "action"."created_at",
        "action"."modified_at",
        "action"."deleted_at",
        "action"."hidden"
    FROM
        "tables"."action"
    WHERE
        "action"."guid" = {action_guid} AND
        "action"."deleted_at" IS NULL AND
        NOT "action"."hidden"
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
        "account"."created_at",
        "account"."modified_at",
        "account"."deleted_at",
        "account"."hidden"
    FROM
        "tables"."account"
            LEFT JOIN "tables"."account_credentials"
                ON "account"."id" = "account_credentials"."id"
            LEFT JOIN "tables"."account_token"
                ON "account"."id" = "account_token"."id"
    WHERE
        ("account_credentials"."id" IS NOT NULL OR "account_token"."id" IS NOT NULL) AND
        "account"."guid" = {account_guid} AND
        "account"."deleted_at" IS NULL AND
        NOT "account"."hidden"
), "result_link" AS (
    INSERT INTO
        "relations"."action_account" ("action_id", "account_id")
    SELECT
        "action"."id",
        "account"."id"
    FROM
        "result_action" AS "action",
        "result_account" AS "account"
    RETURNING
        "action_account"."id",
        "action_account"."created_at",
        "action_account"."deleted_at"
), "json_action" AS (
    SELECT
        json_build_object(
            'guid', "action"."guid",
            'name', "action"."name",
            'description', "action"."description",
            'created_at', "action"."created_at",
            'modified_at', "action"."modified_at",
            'deleted_at', "action"."deleted_at",
            'hidden', "action"."hidden"
        ) AS "json"
    FROM
        "result_action" AS "action"
), "json_account" AS (
    SELECT
        json_build_object(
            'guid', "account"."guid",
            'type', "account"."type",
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
        'action', "json_action"."json",
        'account', "json_account"."json",
        'created_at', "link"."created_at",
        'deleted_at', "link"."deleted_at"
    )
FROM
    "result_link" AS "link",
    "json_action",
    "json_account";