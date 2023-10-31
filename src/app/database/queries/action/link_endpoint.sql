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
), "result_endpoint" AS (
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
        "endpoint"."guid" = {endpoint_guid} AND
        "endpoint"."deleted_at" IS NULL AND
        NOT "endpoint"."hidden"
), "result_link" AS (
    INSERT INTO
        "relations"."action_endpoint" ("action_id", "endpoint_id")
    SELECT
        "action"."id",
        "endpoint"."id"
    FROM
        "result_action" AS "action",
        "result_endpoint" AS "endpoint"
    RETURNING
        "action_endpoint"."id",
        "action_endpoint"."created_at",
        "action_endpoint"."deleted_at"
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
), "json_endpoint" AS (
    SELECT
        json_build_object(
            'guid', "endpoint"."guid",
            'url', "endpoint"."url",
            'method', "endpoint"."method",
            'created_at', "endpoint"."created_at",
            'modified_at', "endpoint"."modified_at",
            'deleted_at', "endpoint"."deleted_at",
            'hidden', "endpoint"."hidden"
        ) AS "json"
    FROM
        "result_endpoint" AS "endpoint"
)
SELECT
    json_build_object(
        'action', "json_action"."json",
        'endpoint', "json_endpoint"."json",
        'created_at', "link"."created_at",
        'deleted_at', "link"."deleted_at"
    )
FROM
    "result_link" AS "link",
    "json_action",
    "json_endpoint";