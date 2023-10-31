WITH "result_action" AS (
    UPDATE
        "tables"."action"
    SET
        "deleted_at" = CURRENT_TIMESTAMP
    WHERE
        "action"."guid" = {guid} AND
        "action"."deleted_at" IS NULL
    RETURNING
        "action"."id",
        "action"."guid",
        "action"."name",
        "action"."description",
        "action"."created_at",
        "action"."modified_at",
        "action"."deleted_at",
        "action"."hidden"
)
SELECT
    json_build_object(
        'guid', "action"."guid",
        'name', "action"."name",
        'description', "action"."description",
        'created_at', "action"."created_at",
        'modified_at', "action"."modified_at",
        'deleted_at', "action"."deleted_at",
        'hidden', "action"."hidden"
    )
FROM
    "result_action" AS "action";