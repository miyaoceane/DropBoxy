USE master;
GO
IF SUSER_ID(N'login_service_client_test') IS NULL
    CREATE LOGIN login_service_client_test WITH PASSWORD = N'Svc#DropBoxy2026!', CHECK_POLICY = ON, DEFAULT_DATABASE = DropBoxy;
IF SUSER_ID(N'login_direction_test') IS NULL
    CREATE LOGIN login_direction_test      WITH PASSWORD = N'Dir#DropBoxy2026!', CHECK_POLICY = ON, DEFAULT_DATABASE = DropBoxy;
GO

USE DropBoxy;
GO
IF DATABASE_PRINCIPAL_ID(N'u_service_client_test') IS NULL 
    CREATE USER u_service_client_test FOR LOGIN login_service_client_test;
IF DATABASE_PRINCIPAL_ID(N'u_direction_test')      IS NULL 
    CREATE USER u_direction_test      FOR LOGIN login_direction_test;

IF IS_ROLEMEMBER(N'role_service_client', N'u_service_client_test') = 0 
    ALTER ROLE role_service_client ADD MEMBER u_service_client_test;
IF IS_ROLEMEMBER(N'role_direction',      N'u_direction_test')      = 0 
    ALTER ROLE role_direction      ADD MEMBER u_direction_test;
GO

-- Contrôle1(capture) : membres des rôles, et personne dans db_owner
SELECT r.name AS Role, m.name AS Membre
FROM sys.database_role_members rm
JOIN sys.database_principals r ON r.principal_id = rm.role_principal_id
JOIN sys.database_principals m ON m.principal_id = rm.member_principal_id
WHERE r.name IN (N'role_service_client', N'role_direction', N'db_owner', N'db_datareader', N'db_datawriter')
ORDER BY r.name, m.name;

-- Contrôle2(capture) : permissions réellement accordées à tes deux rôles
SELECT pr.name AS Role, pe.state_desc AS Etat, pe.permission_name AS Permission,
       CASE pe.class WHEN 1 THEN OBJECT_SCHEMA_NAME(pe.major_id) + N'.' + OBJECT_NAME(pe.major_id)
                     ELSE pe.class_desc END AS Objet,
       COL_NAME(pe.major_id, pe.minor_id) AS Colonne
FROM sys.database_permissions pe
JOIN sys.database_principals pr ON pr.principal_id = pe.grantee_principal_id
WHERE pr.name IN (N'role_service_client', N'role_direction')
ORDER BY pr.name, Objet, pe.permission_name;
GO