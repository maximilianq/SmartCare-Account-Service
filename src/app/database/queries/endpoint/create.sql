WITH "result_endpoint" AS (
    INSERT INTO
        "tables"."endpoint" ("url", "method", "hidden")
    SELECT
        {url} AS "url",
        {method} AS "method",
        {hidden} AS "hidden"
    RETURNING
        "endpoint"."id",
        "endpoint"."guid",
        "endpoint"."url",
        "endpoint"."method",
        "endpoint"."created_at",
        "endpoint"."modified_at",
        "endpoint"."deleted_at",
        "endpoint"."hidden"
)
SELECT
    json_build_object(
        'guid', "endpoint"."guid",
        'url', "endpoint"."url",
        'method', "endpoint"."method",
        'created_at', "endpoint"."created_at",
        'modified_at', "endpoint"."modified_at",
        'deleted_at', "endpoint"."deleted_at",
        'hidden', "endpoint"."hidden"
    )
FROM
    "result_endpoint" AS "endpoint";