WITH "result_action" AS (
    UPDATE
        "tables"."action"
    SET
        "name" = CASE WHEN {name_set} THEN {name} ELSE "name" END,
        "description" = CASE WHEN {description_set} THEN {description} ELSE "description" END,
        "modified_at" = CURRENT_TIMESTAMP,
        "hidden" = CASE WHEN {hidden_set} THEN {hidden} ELSE "hidden" END
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