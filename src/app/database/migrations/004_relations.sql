CREATE TABLE "relations"."group_account"(
    "id"            BIGSERIAL PRIMARY KEY,
    "group_id"      BIGINT NOT NULL REFERENCES "tables"."group"("id"),
    "account_id"    BIGINT NOT NULL REFERENCES "tables"."account"("id"),
    "created_at"    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    "deleted_at"    TIMESTAMP
);

CREATE TABLE "relations"."action_endpoint"(
    "id"            BIGSERIAL PRIMARY KEY,
    "action_id"     BIGINT NOT NULL REFERENCES "tables"."action"("id"),
    "endpoint_id"   BIGINT NOT NULL REFERENCES "tables"."endpoint"("id"),
    "created_at"    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    "deleted_at"    TIMESTAMP
);

CREATE TABLE "relations"."action_account"(
    "id"            BIGSERIAL PRIMARY KEY,
    "action_id"     BIGINT NOT NULL REFERENCES "tables"."action"("id"),
    "account_id"    BIGINT NOT NULL REFERENCES "tables"."account"("id"),
    "created_at"    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    "deleted_at"    TIMESTAMP
);

CREATE TABLE "relations"."action_group"(
    "id"            BIGSERIAL PRIMARY KEY,
    "action_id"     BIGINT NOT NULL REFERENCES "tables"."action"("id"),
    "group_id"      BIGINT NOT NULL REFERENCES "tables"."group"("id"),
    "created_at"    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    "deleted_at"    TIMESTAMP
);