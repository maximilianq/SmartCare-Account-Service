WITH "result_action" AS (
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
        "action"."guid" = {action_guid} AND
        "action"."deleted_at" IS NULL AND
        NOT "action"."hidden"
), "result_group" AS (
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
        "group"."guid" = {group_guid} AND
        "group"."deleted_at" IS NULL AND
        NOT "group"."hidden"
), "result_link" AS (
    INSERT INTO
        "relations"."action_group" ("action_id", "group_id")
    SELECT
        "action"."id",
        "group"."id"
    FROM
        "result_action" AS "action",
        "result_group" AS "group"
    RETURNING
        "action_group"."id",
        "action_group"."created_at",
        "action_group"."deleted_at"
), "json_action" AS (
    SELECT
        json_build_object(
            'guid', "action"."guid",
            'name', "action"."name",
            'description', "action"."description",
            'created_at', "action"."created_at",
            'modified_at', "action"."modified_at",
            'deleted_at', "action"."deleted_at",
            'hidden', "action"."hidden"
        ) AS "json"
    FROM
        "result_action" AS "action"
), "json_group" AS (
    SELECT
        json_build_object(
            'guid', "group"."guid",
            'name', "group"."name",
            'description', "group"."description",
            'created_at', "group"."created_at",
            'modified_at', "group"."modified_at",
            'deleted_at', "group"."deleted_at",
            'hidden', "group"."hidden"
        ) AS "json"
    FROM
        "result_group" AS "group"
)
SELECT
    json_build_object(
        'action', "json_action"."json",
        'group', "json_group"."json",
        'created_at', "link"."created_at",
        'deleted_at', "link"."deleted_at"
    )
FROM
    "result_link" AS "link",
    "json_action",
    "json_group";