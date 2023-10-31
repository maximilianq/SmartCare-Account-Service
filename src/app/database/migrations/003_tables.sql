CREATE TABLE "tables"."account"(
    "id"            BIGSERIAL PRIMARY KEY,
    "guid"          UUID UNIQUE NOT NULL DEFAULT gen_random_uuid(),
    "name"          VARCHAR(64) NOT NULL,
    "description"   VARCHAR(512),
    "email"         VARCHAR(256),
    "created_at"    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    "modified_at"   TIMESTAMP,
    "deleted_at"    TIMESTAMP,
    "hidden"        BOOLEAN NOT NULL DEFAULT FALSE
);

CREATE TABLE "tables"."account_credentials"(
    "id"            BIGINT PRIMARY KEY REFERENCES "tables"."account"("id"),
    "username"      VARCHAR(64) NOT NULL,
    "password"      BYTEA NOT NULL,
    "salt"          BYTEA NOT NULL,
    "secret"        BYTEA NOT NULL
);

CREATE TABLE "tables"."account_token"(
    "id"            BIGINT PRIMARY KEY REFERENCES "tables"."account"("id"),
    "token"         BYTEA NOT NULL
);

CREATE TABLE "tables"."group"(
    "id"            BIGSERIAL PRIMARY KEY,
    "guid"          UUID UNIQUE NOT NULL DEFAULT gen_random_uuid(),
    "name"          VARCHAR(64) NOT NULL,
    "description"   VARCHAR(512),
    "created_at"    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    "modified_at"   TIMESTAMP,
    "deleted_at"    TIMESTAMP,
    "hidden"        BOOLEAN NOT NULL DEFAULT FALSE
);

CREATE TABLE "tables"."action"(
    "id"            BIGSERIAL PRIMARY KEY,
    "guid"          UUID UNIQUE NOT NULL DEFAULT gen_random_uuid(),
    "name"          VARCHAR(64) NOT NULL,
    "description"   VARCHAR(512),
    "created_at"    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    "modified_at"   TIMESTAMP,
    "deleted_at"    TIMESTAMP,
    "hidden"        BOOLEAN NOT NULL DEFAULT FALSE
);

CREATE TABLE "tables"."endpoint"(
    "id"            BIGSERIAL PRIMARY KEY,
    "guid"          UUID UNIQUE NOT NULL DEFAULT gen_random_uuid(),
    "url"           VARCHAR(2048) NOT NULL,
    "method"        HTTP_METHOD NOT NULL,
    "created_at"    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    "modified_at"   TIMESTAMP,
    "deleted_at"    TIMESTAMP,
    "hidden"        BOOLEAN NOT NULL DEFAULT FALSE
);

CREATE TABLE "tables"."session"(
    "id"            BIGSERIAL PRIMARY KEY,
    "guid"          UUID UNIQUE NOT NULL DEFAULT gen_random_uuid(),
    "account_id"    BIGINT NOT NULL REFERENCES "tables"."account"("id"),
    "client"        INET NOT NULL,
    "token"         BYTEA NOT NULL,
    "strong"        BOOLEAN NOT NULL DEFAULT FALSE,
    "created_at"    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    "modified_at"   TIMESTAMP,
    "deleted_at"    TIMESTAMP,
    "hidden"        BOOLEAN NOT NULL DEFAULT FALSE
);