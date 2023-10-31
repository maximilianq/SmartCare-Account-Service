WITH "result_endpoint" AS (
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
        "tables"."endpoint"
    WHERE
        "endpoint"."guid" = {guid}
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
        "result_endpoint"
            JOIN "relations"."action_endpoint"
                ON "result_endpoint"."id" = "action_endpoint"."endpoint_id"
                AND "action_endpoint"."deleted_at" IS NULL
            JOIN "tables"."action"
                ON "action_endpoint"."action_id" = "action"."id"
                AND "action"."deleted_at" IS NULL
                AND NOT "action"."hidden"
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
        'guid', "endpoint"."guid",
        'url', "endpoint"."url",
        'method', "endpoint"."method",
        'actions', COALESCE("json_actions"."json", '[]'::json),
        'created_at', "endpoint"."created_at",
        'modified_at', "endpoint"."modified_at",
        'deleted_at', "endpoint"."deleted_at",
        'hidden', "endpoint"."hidden"
    )
FROM
    "result_endpoint" AS "endpoint",
    "json_actions";