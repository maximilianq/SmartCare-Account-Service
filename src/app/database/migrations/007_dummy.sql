INSERT INTO
    "tables"."account"
VALUES
    (DEFAULT, DEFAULT, 'Admin', 'Root administrator of the SmartCare platform.', 'admin@smartcare.de', DEFAULT, NULL, NULL, DEFAULT),
    (DEFAULT, DEFAULT, 'SmartCare GmbH', 'Developer and Maintainer of SmartCare.', 'info@smartcare.de', DEFAULT, NULL, NULL, DEFAULT);

INSERT INTO
    "tables"."account_credentials"
VALUES
    (1, 'admin', decode('0B128FF3B3EB22119E605E61C2F615A68F2F25F96DBB0C77ACA00AF041A165DE2E2CFC5C4BB7B7ED98EC10BF7436E6EA50D6BE4A54889A7896D9B21DC95A1FB6', 'hex'), decode('CF060AF3B7F7B666AC7922CD5E704A8440D8270167264F629E54FFB85FCD753D', 'hex'), decode('89D1747E45D5C7452045EBD266D6E91C069823E375A78045C465CE8E7AE067A2D3396BBDED08A662', 'hex'));

INSERT INTO
    "tables"."account_token"
VALUES
    (2, decode('2F0BC74616AB696292FE290461DC6BE3E725B34F22807F8B3BE48B78C63A61F194A2BF3F6D42F9E98798ECBCF23942BDE0921577386ABFB9555D456BE03AC401', 'hex'));

INSERT INTO
    "tables"."group"
VALUES
    (DEFAULT, DEFAULT, 'Administrators', 'All administrators of the SmartCare platform.', DEFAULT, NULL, NULL, DEFAULT);

INSERT INTO
    "tables"."action"
VALUES
    (DEFAULT, DEFAULT, 'All', 'All actions of the SmartCare platform.', DEFAULT, NULL, NULL, DEFAULT);

INSERT INTO
    "tables"."endpoint"
VALUES
    (DEFAULT, DEFAULT, '/api/account', 'GET', DEFAULT, NULL, NULL, DEFAULT),
    (DEFAULT, DEFAULT, '/api/account/{guid:uuid}', 'GET', DEFAULT, NULL, NULL, DEFAULT),
    (DEFAULT, DEFAULT, '/api/account/{account_guid:uuid}/group/{group_guid:uuid}', 'POST', DEFAULT, NULL, NULL, DEFAULT),
    (DEFAULT, DEFAULT, '/api/account/{account_guid:uuid}/group/{group_guid:uuid}', 'DELETE', DEFAULT, NULL, NULL, DEFAULT),
    (DEFAULT, DEFAULT, '/api/account/{account_guid:uuid}/action/{action_guid:uuid}', 'POST', DEFAULT, NULL, NULL, DEFAULT),
    (DEFAULT, DEFAULT, '/api/account/{account_guid:uuid}/action/{action_guid:uuid}', 'DELETE', DEFAULT, NULL, NULL, DEFAULT),
    (DEFAULT, DEFAULT, '/api/account/credentials', 'GET', DEFAULT, NULL, NULL, DEFAULT),
    (DEFAULT, DEFAULT, '/api/account/credentials', 'POST', DEFAULT, NULL, NULL, DEFAULT),
    (DEFAULT, DEFAULT, '/api/account/credentials/{guid:uuid}', 'GET', DEFAULT, NULL, NULL, DEFAULT),
    (DEFAULT, DEFAULT, '/api/account/credentials/{guid:uuid}', 'PATCH', DEFAULT, NULL, NULL, DEFAULT),
    (DEFAULT, DEFAULT, '/api/account/credentials/{guid:uuid}', 'DELETE', DEFAULT, NULL, NULL, DEFAULT),
    (DEFAULT, DEFAULT, '/api/account/token', 'GET', DEFAULT, NULL, NULL, DEFAULT),
    (DEFAULT, DEFAULT, '/api/account/token', 'POST', DEFAULT, NULL, NULL, DEFAULT),
    (DEFAULT, DEFAULT, '/api/account/token/{guid:uuid}', 'GET', DEFAULT, NULL, NULL, DEFAULT),
    (DEFAULT, DEFAULT, '/api/account/token/{guid:uuid}', 'PATCH', DEFAULT, NULL, NULL, DEFAULT),
    (DEFAULT, DEFAULT, '/api/account/token/{guid:uuid}', 'DELETE', DEFAULT, NULL, NULL, DEFAULT),
    (DEFAULT, DEFAULT, '/api/action', 'GET', DEFAULT, NULL, NULL, DEFAULT),
    (DEFAULT, DEFAULT, '/api/action', 'POST', DEFAULT, NULL, NULL, DEFAULT),
    (DEFAULT, DEFAULT, '/api/action/{guid:uuid}', 'GET', DEFAULT, NULL, NULL, DEFAULT),
    (DEFAULT, DEFAULT, '/api/action/{guid:uuid}', 'PATCH', DEFAULT, NULL, NULL, DEFAULT),
    (DEFAULT, DEFAULT, '/api/action/{guid:uuid}', 'DELETE', DEFAULT, NULL, NULL, DEFAULT),
    (DEFAULT, DEFAULT, '/api/action/{action_guid:uuid}/account/{account_guid:uuid}', 'POST', DEFAULT, NULL, NULL, DEFAULT),
    (DEFAULT, DEFAULT, '/api/action/{action_guid:uuid}/account/{account_guid:uuid}', 'DELETE', DEFAULT, NULL, NULL, DEFAULT),
    (DEFAULT, DEFAULT, '/api/action/{action_guid:uuid}/group/{group_guid:uuid}', 'POST', DEFAULT, NULL, NULL, DEFAULT),
    (DEFAULT, DEFAULT, '/api/action/{action_guid:uuid}/group/{group_guid:uuid}', 'DELETE', DEFAULT, NULL, NULL, DEFAULT),
    (DEFAULT, DEFAULT, '/api/action/{action_guid:uuid}/endpoint/{endpoint_guid:uuid}', 'POST', DEFAULT, NULL, NULL, DEFAULT),
    (DEFAULT, DEFAULT, '/api/action/{action_guid:uuid}/endpoint/{endpoint_guid:uuid}', 'DELETE', DEFAULT, NULL, NULL, DEFAULT),
    (DEFAULT, DEFAULT, '/api/endpoint', 'GET', DEFAULT, NULL, NULL, DEFAULT),
    (DEFAULT, DEFAULT, '/api/endpoint', 'POST', DEFAULT, NULL, NULL, DEFAULT),
    (DEFAULT, DEFAULT, '/api/endpoint/{guid:uuid}', 'GET', DEFAULT, NULL, NULL, DEFAULT),
    (DEFAULT, DEFAULT, '/api/endpoint/{guid:uuid}', 'PATCH', DEFAULT, NULL, NULL, DEFAULT),
    (DEFAULT, DEFAULT, '/api/endpoint/{guid:uuid}', 'DELETE', DEFAULT, NULL, NULL, DEFAULT),
    (DEFAULT, DEFAULT, '/api/endpoint/{endpoint_guid:uuid}/action/{action_guid:uuid}', 'POST', DEFAULT, NULL, NULL, DEFAULT),
    (DEFAULT, DEFAULT, '/api/endpoint/{endpoint_guid:uuid}/action/{action_guid:uuid}', 'DELETE', DEFAULT, NULL, NULL, DEFAULT),
    (DEFAULT, DEFAULT, '/api/group', 'GET', DEFAULT, NULL, NULL, DEFAULT),
    (DEFAULT, DEFAULT, '/api/group', 'POST', DEFAULT, NULL, NULL, DEFAULT),
    (DEFAULT, DEFAULT, '/api/group/{guid:uuid}', 'GET', DEFAULT, NULL, NULL, DEFAULT),
    (DEFAULT, DEFAULT, '/api/group/{guid:uuid}', 'PATCH', DEFAULT, NULL, NULL, DEFAULT),
    (DEFAULT, DEFAULT, '/api/group/{guid:uuid}', 'DELETE', DEFAULT, NULL, NULL, DEFAULT),
    (DEFAULT, DEFAULT, '/api/group/{group_guid:uuid}/account/{account_guid:uuid}', 'POST', DEFAULT, NULL, NULL, DEFAULT),
    (DEFAULT, DEFAULT, '/api/group/{group_guid:uuid}/account/{account_guid:uuid}', 'DELETE', DEFAULT, NULL, NULL, DEFAULT),
    (DEFAULT, DEFAULT, '/api/group/{group_guid:uuid}/action/{action_guid:uuid}', 'POST', DEFAULT, NULL, NULL, DEFAULT),
    (DEFAULT, DEFAULT, '/api/group/{group_guid:uuid}/action/{action_guid:uuid}', 'DELETE', DEFAULT, NULL, NULL, DEFAULT),
    (DEFAULT, DEFAULT, '/api/session', 'GET', DEFAULT, NULL, NULL, DEFAULT),
    (DEFAULT, DEFAULT, '/api/session/{guid:uuid}', 'GET', DEFAULT, NULL, NULL, DEFAULT),
    (DEFAULT, DEFAULT, '/api/session', 'POST', DEFAULT, NULL, NULL, DEFAULT),
    (DEFAULT, DEFAULT, '/api/session/{guid:uuid}', 'PATCH', DEFAULT, NULL, NULL, DEFAULT),
    (DEFAULT, DEFAULT, '/api/session/{guid:uuid}', 'DELETE', DEFAULT, NULL, NULL, DEFAULT);

INSERT INTO
    "relations"."group_account"
VALUES
    (1, 1, 1, DEFAULT, NULL),
    (2, 1, 2, DEFAULT, NULL);

INSERT INTO
    "relations"."action_group"
VALUES
    (1, 1, 1, DEFAULT, NULL);

INSERT INTO
    "relations"."action_endpoint"
VALUES
    (DEFAULT, 1, 1, DEFAULT, NULL),
    (DEFAULT, 1, 2, DEFAULT, NULL),
    (DEFAULT, 1, 3, DEFAULT, NULL),
    (DEFAULT, 1, 4, DEFAULT, NULL),
    (DEFAULT, 1, 5, DEFAULT, NULL),
    (DEFAULT, 1, 6, DEFAULT, NULL),
    (DEFAULT, 1, 7, DEFAULT, NULL),
    (DEFAULT, 1, 8, DEFAULT, NULL),
    (DEFAULT, 1, 9, DEFAULT, NULL),
    (DEFAULT, 1, 10, DEFAULT, NULL),
    (DEFAULT, 1, 11, DEFAULT, NULL),
    (DEFAULT, 1, 12, DEFAULT, NULL),
    (DEFAULT, 1, 13, DEFAULT, NULL),
    (DEFAULT, 1, 14, DEFAULT, NULL),
    (DEFAULT, 1, 15, DEFAULT, NULL),
    (DEFAULT, 1, 16, DEFAULT, NULL),
    (DEFAULT, 1, 17, DEFAULT, NULL),
    (DEFAULT, 1, 18, DEFAULT, NULL),
    (DEFAULT, 1, 19, DEFAULT, NULL),
    (DEFAULT, 1, 20, DEFAULT, NULL),
    (DEFAULT, 1, 21, DEFAULT, NULL),
    (DEFAULT, 1, 22, DEFAULT, NULL),
    (DEFAULT, 1, 23, DEFAULT, NULL),
    (DEFAULT, 1, 24, DEFAULT, NULL),
    (DEFAULT, 1, 25, DEFAULT, NULL),
    (DEFAULT, 1, 26, DEFAULT, NULL),
    (DEFAULT, 1, 27, DEFAULT, NULL),
    (DEFAULT, 1, 28, DEFAULT, NULL),
    (DEFAULT, 1, 29, DEFAULT, NULL),
    (DEFAULT, 1, 30, DEFAULT, NULL),
    (DEFAULT, 1, 31, DEFAULT, NULL),
    (DEFAULT, 1, 32, DEFAULT, NULL),
    (DEFAULT, 1, 33, DEFAULT, NULL),
    (DEFAULT, 1, 34, DEFAULT, NULL),
    (DEFAULT, 1, 35, DEFAULT, NULL),
    (DEFAULT, 1, 36, DEFAULT, NULL),
    (DEFAULT, 1, 37, DEFAULT, NULL),
    (DEFAULT, 1, 38, DEFAULT, NULL),
    (DEFAULT, 1, 39, DEFAULT, NULL),
    (DEFAULT, 1, 40, DEFAULT, NULL),
    (DEFAULT, 1, 41, DEFAULT, NULL),
    (DEFAULT, 1, 42, DEFAULT, NULL),
    (DEFAULT, 1, 43, DEFAULT, NULL),
    (DEFAULT, 1, 44, DEFAULT, NULL),
    (DEFAULT, 1, 45, DEFAULT, NULL),
    (DEFAULT, 1, 46, DEFAULT, NULL),
    (DEFAULT, 1, 47, DEFAULT, NULL),
    (DEFAULT, 1, 48, DEFAULT, NULL);