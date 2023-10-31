WITH "result_accounts" AS (
    SELECT
        "account"."id",
        "account"."guid",
        "account"."name",
        "account"."description",
        "account"."email",
        "account_credentials"."username",
        "account"."created_at",
        "account"."modified_at",
        "account"."deleted_at",
        "account"."hidden"
    FROM
        "tables"."account"
            JOIN "tables"."account_credentials"
                ON "account"."id" = "account_credentials"."id"
    WHERE
        ({deleted} OR "account"."deleted_at" IS NULL) AND
        ({hidden} OR NOT "account"."hidden")
)
SELECT
    json_agg(
        json_build_object(
            'guid', "account"."guid",
            'name', "account"."name",
            'description', "account"."description",
            'email', "account"."email",
            'username', "account"."username",
            'created_at', "account"."created_at",
            'modified_at', "account"."modified_at",
            'deleted_at', "account"."deleted_at",
            'hidden', "account"."hidden"
        )
    )
FROM
    "result_accounts" AS "account";