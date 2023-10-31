WITH "result_endpoint" AS (
    UPDATE
        "tables"."endpoint"
    SET
        "url" = CASE WHEN {url_set} THEN {url} ELSE "url" END,
        "method" = CASE WHEN {method_set} THEN {method} ELSE "method" END,
        "modified_at" = CURRENT_TIMESTAMP,
        "hidden" = CASE WHEN {hidden_set} THEN {hidden} ELSE "hidden" END
    WHERE
        "endpoint"."guid" = {guid} AND
        "endpoint"."deleted_at" IS NULL
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