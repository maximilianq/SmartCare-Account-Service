WITH "result_sessions" AS (
    SELECT
        "session"."id",
        "session"."guid",
        "session"."client",
        "session"."strong",
        "session"."created_at",
        "session"."modified_at",
        "session"."deleted_at",
        "session"."hidden"
    FROM
        "tables"."session"
    WHERE
        ({deleted} OR "session"."deleted_at" IS NULL) AND
        ({hidden} OR NOT "session"."hidden")
)
SELECT
    json_agg(json_build_object(
        'guid', "session"."guid",
        'client', "session"."client",
        'strong', "session"."strong",
        'created_at', "session"."created_at",
        'modified_at', "session"."modified_at",
        'deleted_at', "session"."deleted_at",
        'hidden', "session"."hidden"
    ))
FROM
    "result_sessions" AS "session"