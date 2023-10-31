WITH "result_account" AS (
    SELECT
        "account"."id",
        "account"."guid",
        CASE
            WHEN "account_credentials"."id" IS NOT NULL THEN 'CREDENTIALS'
            WHEN "account_token"."id" IS NOT NULL THEN 'TOKEN'
        END AS "type",
        "account"."name",
        "account"."email",
        "account_credentials"."username",
        "account"."description",
        "account"."created_at",
        "account"."modified_at",
        "account"."deleted_at",
        "account"."hidden"
    FROM
        "tables"."session"
            JOIN "tables"."account"
                ON "session"."account_id" = "account"."id"
                AND "account"."deleted_at" IS NULL
                AND NOT "account"."hidden"
            LEFT JOIN "tables"."account_credentials"
                ON "account"."id" = "account_credentials"."id"
            LEFT JOIN "tables"."account_token"
                ON "account"."id" = "account_token"."id"
    WHERE
        "session"."client" = {client} AND
        "session"."token" = decode({token}, 'hex') AND
        "session"."deleted_at" IS NULL AND
        nOT "session"."hidden"
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
        "result_account"
            JOIN "relations"."group_account"
                ON "result_account"."id" = "group_account"."account_id"
                AND "group_account"."deleted_at" IS NULL
            JOIN "tables"."group"
                ON "group_account"."group_id" = "group"."id"
                AND "group"."deleted_at" IS NULL
                AND NOT "group"."hidden"
), "result_action" AS (
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
        "result_account"
            LEFT JOIN "relations"."action_account"
                ON "result_account"."id" = "action_account"."account_id"
                AND "action_account"."deleted_at" IS NULL
            LEFT JOIN "relations"."group_account"
                ON "result_account"."id" = "group_account"."account_id"
                AND "group_account"."deleted_at" IS NULL
            LEFT JOIN "tables"."group"
                ON "group_account"."group_id" = "group"."id"
                AND "group"."deleted_at" IS NULL
                AND NOT "group"."hidden"
            LEFT JOIN "relations"."action_group"
                ON "group"."id" = "action_group"."group_id"
                AND "action_group"."deleted_at" IS NULL
            JOIN "tables"."action"
                ON ("action_account"."action_id" = "action"."id" OR "action_group"."action_id" = "action"."id")
                AND "action"."deleted_at" IS NULL
                AND NOT "action"."hidden"
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
)
SELECT
    CASE
        WHEN EXISTS (
            SELECT
                *
            FROM
                "result_endpoints" AS "endpoint"
            WHERE
                "endpoint"."url" = {url} AND
                "endpoint"."method" = {method}
        )
        THEN
            CASE
                WHEN "account"."type" = 'CREDENTIALS' THEN
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
                    )
                WHEN "account"."type" = 'TOKEN' THEN
                    json_build_object(
                        'guid', "account"."guid",
                        'type', 'TOKEN',
                        'name', "account"."name",
                        'description', "account"."description",
                        'email', "account"."email",
                        'created_at', "account"."created_at",
                        'modified_at', "account"."modified_at",
                        'deleted_at', "account"."deleted_at",
                        'hidden', "account"."hidden"
                    )
            END
        ELSE 
            NULL
    END
FROM
    "result_account" AS "account";