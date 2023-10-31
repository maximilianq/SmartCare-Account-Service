WITH "result_group" AS (
    SELECT
        "group"."id",
        "group"."guid",
        "group"."name",
        "group"."description",
        "group"."created_at",
        "group"."modified_at",
        "group"."deleted_at",
        "group"."hidden"
    FROM
        "tables"."group"
    WHERE
        "group"."guid" = {guid}
), "result_accounts" AS (
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
        "result_group"
            JOIN "relations"."group_account"
                ON "result_group"."id" = "group_account"."group_id"
                AND "group_account"."deleted_at" IS NULL
            JOIN "tables"."account"
                ON "group_account"."account_id" = "account"."id"
                AND "account"."deleted_at" IS NULL
                AND NOT "account"."hidden"
            LEFT JOIN "tables"."account_credentials"
                ON "account"."id" = "account_credentials"."id"
            LEFT JOIN "tables"."account_token"
                ON "account"."id" = "account_token"."id"
    WHERE
        ("account_credentials"."id" IS NOT NULL OR "account_token"."id" IS NOT NULL)
), "result_actions" AS (
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
        "result_group"
            JOIN "relations"."action_group"
                ON "result_group"."id" = "action_group"."group_id"
                AND "action_group"."deleted_at" IS NULL
            JOIN "tables"."action"
                ON "action_group"."action_id" = "action"."id"
                AND "action"."deleted_at" IS NULL
                AND NOT "action"."hidden"
), "json_accounts" AS (
    SELECT
        json_agg(
            json_build_object(
                'guid', "account"."guid",
                'type', 'CREDENTIALS',
                'name', "account"."name",
                'description', "account"."description",
                'email', "account"."email",
                'created_at', "account"."created_at",
                'modified_at', "account"."modified_at",
                'deleted_at', "account"."deleted_at",
                'hidden', "account"."hidden"
            )
        ) AS "json"
    FROM
        "result_accounts" AS "account"
), "json_actions" AS (
    SELECT
        json_agg(
            json_build_object(
                'guid', "action"."guid",
                'name', "action"."name",
                'description', "action"."description",
                'created_at', "action"."created_at",
                'modified_at', "action"."modified_at",
                'deleted_at', "action"."deleted_at",
                'hidden', "action"."hidden"
            )
        ) AS "json"
    FROM
        "result_actions" AS "action"
)
SELECT
    json_build_object(
        'guid', "group"."guid",
        'name', "group"."name",
        'description', "group"."description",
        'accounts', COALESCE("json_accounts"."json", '[]'::json),
        'actions', COALESCE("json_actions"."json", '[]'::json),
        'created_at', "group"."created_at",
        'modified_at', "group"."modified_at",
        'deleted_at', "group"."deleted_at",
        'hidden', "group"."hidden"
    )
FROM
    "result_group" AS "group",
    "json_accounts",
    "json_actions";