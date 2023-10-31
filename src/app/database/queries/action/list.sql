WITH "result_actions" AS (
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
        ({deleted} OR "action"."deleted_at" IS NULL) AND
        ({hidden} OR NOT "action"."hidden")
)
SELECT
    json_agg(json_build_object(
        'guid', "action"."guid",
        'name', "action"."name",
        'description', "action"."description",
        'created_at', "action"."created_at",
        'modified_at', "action"."modified_at",
        'deleted_at', "action"."deleted_at",
        'hidden', "action"."hidden"
    ))
FROM
    "result_actions" AS "action"