WITH "result_endpoints" AS (
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
        ({deleted} OR "endpoint"."deleted_at" IS NULL) AND
        ({hidden} OR NOT "endpoint"."hidden")
)
SELECT
    json_agg(json_build_object(
        'guid', "endpoint"."guid",
        'url', "endpoint"."url",
        'method', "endpoint"."method",
        'created_at', "endpoint"."created_at",
        'modified_at', "endpoint"."modified_at",
        'deleted_at', "endpoint"."deleted_at",
        'hidden', "endpoint"."hidden"
    ))
FROM
    "result_endpoints" AS "endpoint"