WITH "result_accounts" AS (
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
            LEFT JOIN "tables"."account_credentials"
                ON "account"."id" = "account_credentials"."id"
            LEFT JOIN "tables"."account_token"
                ON "account"."id" = "account_token"."id"
    WHERE
        ("account_credentials"."id" IS NOT NULL OR "account_token"."id" IS NOT NULL) AND
        ({deleted} OR "account"."deleted_at" IS NULL) AND
        ({hidden} OR NOT "account"."hidden")
)
SELECT
    json_agg(
        json_build_object(
            'guid', "account"."guid",
            'type', "account"."type",
            'name', "account"."name",
            'description', "account"."description",
            'email', "account"."email",
            'created_at', "account"."created_at",
            'modified_at', "account"."modified_at",
            'deleted_at', "account"."deleted_at",
            'hidden', "account"."hidden"
        )
    )
FROM
    "result_accounts" AS "account";