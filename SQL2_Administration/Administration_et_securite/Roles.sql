USE DropBoxy;
GO

IF DATABASE_PRINCIPAL_ID(N'role_service_client') IS NULL 
  CREATE ROLE role_service_client;
IF DATABASE_PRINCIPAL_ID(N'role_direction') IS NULL 
  CREATE ROLE role_direction;
IF DATABASE_PRINCIPAL_ID(N'role_exploitation') IS NULL 
  CREATE ROLE role_exploitation;
IF DATABASE_PRINCIPAL_ID(N'role_technicien') IS NULL 
  CREATE ROLE role_technicien;

GO

