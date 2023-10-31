WITH "result_groups" AS (
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
        "tables"."group"
    WHERE
        ({deleted} OR "group"."deleted_at" IS NULL) AND
        ({hidden} OR NOT "group"."hidden")
)
SELECT
    json_agg(json_build_object(
        'guid', "group"."guid",
        'name', "group"."name",
        'description', "group"."description",
        'created_at', "group"."created_at",
        'modified_at', "group"."modified_at",
        'deleted_at', "group"."deleted_at",
        'hidden', "group"."hidden"
    ))
FROM
    "result_groups" AS "group"