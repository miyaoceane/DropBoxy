CREATE LOGIN test_service_client
WITH PASSWORD='Service123!';

CREATE LOGIN test_direction
WITH PASSWORD='Direction123!';
GO

USE DropBoxy;
GO

CREATE USER test_service_client
FOR LOGIN test_service_client;

CREATE USER test_direction
FOR LOGIN test_direction;
GO

ALTER ROLE role_service_client
ADD MEMBER test_service_client;

ALTER ROLE role_direction
ADD MEMBER test_direction;
GO
