CREATE LOGIN test_service_client
WITH PASSWORD='Service123!';

CREATE LOGIN test_direction
WITH PASSWORD='Direction123!';

CREATE LOGIN test_exploit
WITH PASSWORD='Exploit123!';

CREATE LOGIN test_tech
WITH PASSWORD='Tech123!';
GO

USE DropBoxy;
GO

CREATE USER test_service_client
FOR LOGIN test_service_client;

CREATE USER test_direction
FOR LOGIN test_direction;

CREATE USER test_exploit
FOR LOGIN test_exploit;

CREATE USER test_tech
FOR LOGIN test_tech;
GO

ALTER ROLE role_service_client
ADD MEMBER test_service_client;

ALTER ROLE role_direction
ADD MEMBER test_direction;

ALTER ROLE role_exploitation
ADD MEMBER test_exploit;

ALTER ROLE role_technicien
ADD MEMBER test_tech;
GO



