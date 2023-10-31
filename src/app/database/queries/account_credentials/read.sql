WITH "result_account" AS (
    SELECT
        "account"."id",
        "account"."guid",
        "account"."name",
        "account"."description",
        "account"."email",
        "account_credentials"."username",
        "account"."created_at",
        "account"."modified_at",
        "account"."deleted_at",
        "account"."hidden"
    FROM
        "tables"."account"
            JOIN "tables"."account_credentials"
                ON "account"."id" = "account_credentials"."id"
    WHERE
        "account"."guid" = {guid}
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
), "result_sessions" AS (
    SELECT
        "session"."id",
        "session"."guid",
        "session"."client",
        "session"."created_at",
        "session"."modified_at",
        "session"."deleted_at",
        "session"."hidden"
    FROM
        "result_account"
            JOIN "tables"."session"
                ON "result_account"."id" = "session"."account_id"
                AND "session"."deleted_at" IS NULL
                AND NOT "session"."hidden"
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
        "result_account"
            JOIN "relations"."action_account"
                ON "result_account"."id" = "action_account"."account_id"
                    AND "action_account"."deleted_at" IS NULL
            JOIN "tables"."action"
                ON "action_account"."action_id" = "action"."id"
                    AND ("action"."deleted_at" IS NULL
                    AND NOT "action"."hidden")
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
), "json_sessions" AS (
    SELECT
        json_agg(
            json_build_object(
                'guid', "session"."guid",
                'client', "session"."client",
                'created_at', "session"."created_at",
                'modified_at', "session"."modified_at",
                'deleted_at', "session"."deleted_at",
                'hidden', "session"."hidden"
            )
        ) AS "json"
    FROM
        "result_sessions" AS "session"
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
        'guid', "account"."guid",
        'name', "account"."name",
        'description', "account"."description",
        'email', "account"."email",
        'username', "account"."username",
        'groups', COALESCE("json_groups"."json", '[]'::json),
        'sessions', COALESCE("json_sessions"."json", '[]'::json),
        'actions', COALESCE("json_actions"."json", '[]'::json),
        'created_at', "account"."created_at",
        'modified_at', "account"."modified_at",
        'deleted_at', "account"."deleted_at",
        'hidden', "account"."hidden"
    )
FROM
    "result_account" AS "account",
    "json_groups",
    "json_sessions",
    "json_actions";