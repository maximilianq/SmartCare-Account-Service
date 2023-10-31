WITH "result_group" AS (
    UPDATE
        "tables"."group"
    SET
        "name" = CASE WHEN {name_set} THEN {name} ELSE "name" END,
        "description" = CASE WHEN {description_set} THEN {description} ELSE "description" END,
        "modified_at" = CURRENT_TIMESTAMP,
        "hidden" = CASE WHEN {hidden_set} THEN {hidden} ELSE "hidden" END
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