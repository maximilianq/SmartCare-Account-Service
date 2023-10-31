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
        "action"."guid" = {guid}
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
        "result_action"
            JOIN "relations"."action_account"
                ON "result_action"."id" = "action_account"."action_id"
                AND "action_account"."deleted_at" IS NULL
            JOIN "tables"."account"
                ON "action_account"."account_id" = "account"."id"
                AND "account"."deleted_at" IS NULL
                AND NOT "account"."hidden"
            LEFT JOIN "tables"."account_credentials"
                ON "account"."id" = "account_credentials"."id"
            LEFT JOIN "tables"."account_token"
                ON "account"."id" = "account_token"."id"
    WHERE
        ("account_credentials"."id" IS NOT NULL OR "account_token"."id" IS NOT NULL)
), "result_groups" AS (
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
        "result_action"
            JOIN "relations"."action_group"
                ON "result_action"."id" = "action_group"."action_id"
                AND "action_group"."deleted_at" IS NULL
            JOIN "tables"."group"
                ON "action_group"."group_id" = "group"."id"
                AND "group"."deleted_at" IS NULL
                AND NOT "group"."hidden"
), "result_endpoints" AS (
    SELECT
        "endpoint"."id",
        "endpoint"."guid",
        "endpoint"."url",
        "endpoint"."method",
        "endpoint"."created_at",
        "endpoint"."modified_at",
        "endpoint"."deleted_at",
        "endpoint"."hidden"
    FROM
        "result_action"
            JOIN "relations"."action_endpoint"
                ON "result_action"."id" = "action_endpoint"."action_id"
                AND "action_endpoint"."deleted_at" IS NULL
            JOIN "tables"."endpoint"
                ON "action_endpoint"."endpoint_id" = "endpoint"."id"
                AND "endpoint"."deleted_at" IS NULL
                AND NOT "endpoint"."hidden"
), "json_accounts" AS (
    SELECT
        json_agg(
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
            )
        ) AS "json"
    FROM
        "result_accounts" AS "account"
), "json_groups" AS (
    SELECT
        json_agg(
            json_build_object(
                'guid', "group"."guid",
                'name', "group"."name",
                'description', "group"."description",
                'created_at', "group"."created_at",
                'modified_at', "group"."modified_at",
                'deleted_at', "group"."deleted_at",
                'hidden', "group"."hidden"
            )
        ) AS "json"
    FROM
        "result_groups" AS "group"
), "json_endpoints" AS (
    SELECT
        json_agg(
            json_build_object(
                'guid', "endpoint"."guid",
                'url', "endpoint"."url",
                'method', "endpoint"."method",
                'created_at', "endpoint"."created_at",
                'modified_at', "endpoint"."modified_at",
                'deleted_at', "endpoint"."deleted_at",
                'hidden', "endpoint"."hidden"
            )
        ) AS "json"
    FROM
        "result_endpoints" AS "endpoint"
)
SELECT
    json_build_object(
        'guid', "action"."guid",
        'name', "action"."name",
        'description', "action"."description",
        'accounts', COALESCE("json_accounts"."json", '[]'::json),
        'groups', COALESCE("json_groups"."json", '[]'::json),
        'endpoints', COALESCE("json_endpoints"."json", '[]'::json),
        'created_at', "action"."created_at",
        'modified_at', "action"."modified_at",
        'deleted_at', "action"."deleted_at",
        'hidden', "action"."hidden"
    )
FROM
    "result_action" AS "action",
    "json_accounts",
    "json_groups",
    "json_endpoints";