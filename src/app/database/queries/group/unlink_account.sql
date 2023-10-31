WITH "result_group" AS (
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
        "group"."guid" = {group_guid}
), "result_account" AS (
    SELECT
        "account"."id",
        "account"."guid",
        CASE
            WHEN "account_credentials"."id" IS NOT NULL THEN 'CREDENTIALS'
            WHEN "account_token"."id" IS NOT NULL THEN 'TOKEN'
        END AS "type",
        "account"."name",
        "account"."description",
        "account"."email",
        "account"."created_at",
        "account"."modified_at",
        "account"."deleted_at",
        "account"."hidden"
    FROM
        "tables"."account"
            LEFT JOIN "tables"."account_credentials" ON "account"."id" = "account_credentials"."id"
            LEFT JOIN "tables"."account_token" ON "account"."id" = "account_token"."id"
    WHERE
        ("account_credentials"."id" IS NOT NULL OR "account_token"."id" IS NOT NULL) AND
        "account"."guid" = {account_guid}
), "result_link" AS (
    UPDATE
        "relations"."group_account"
    SET
        "deleted_at" = CURRENT_TIMESTAMP
    FROM
        "result_group" AS "group",
        "result_account" AS "account"
    WHERE
        "group_account"."group_id" = "group"."id" AND
        "group_account"."account_id" = "account"."id" AND
        "group_account"."deleted_at" IS NULL
    RETURNING
        "group_account"."id",
        "group_account"."created_at",
        "group_account"."deleted_at"
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
), "json_account" AS (
    SELECT
        json_build_object(
            'guid', "account"."guid",
            'type', "type",
            'name', "account"."name",
            'description', "account"."description",
            'email', "account"."email",
            'created_at', "account"."created_at",
            'modified_at', "account"."modified_at",
            'deleted_at', "account"."deleted_at",
            'hidden', "account"."hidden"
        ) AS "json"
    FROM
        "result_account" AS "account"
)
SELECT
    json_build_object(
        'group', "json_group"."json",
        'account', "json_account"."json",
        'created_at', "link"."created_at",
        'deleted_at', "link"."deleted_at"
    )
FROM
    "result_link" AS "link",
    "json_group", "json_account";