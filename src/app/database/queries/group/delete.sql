WITH "result_group" AS (
    UPDATE
        "tables"."group"
    SET
        "deleted_at" = CURRENT_TIMESTAMP
    WHERE
        "group"."guid" = {guid} AND
        "group"."deleted_at" IS NULL
    RETURNING
        "group"."id",
        "group"."guid",
        "group"."name",
        "group"."description",
        "group"."created_at",
        "group"."modified_at",
        "group"."deleted_at",
        "group"."hidden"
)
SELECT
    json_build_object(
        'guid', "group"."guid",
        'name', "group"."name",
        'description', "group"."description",
        'created_at', "group"."created_at",
        'modified_at', "group"."modified_at",
        'deleted_at', "group"."deleted_at",
        'hidden', "group"."hidden"
    )
FROM
    "result_group" AS "group";