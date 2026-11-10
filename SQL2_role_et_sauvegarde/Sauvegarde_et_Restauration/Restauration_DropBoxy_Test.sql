USE master;
GO

-- 5.0 Relance possible : supprime UNIQUEMENT la copie de test si elle existe déjà
IF DB_ID(N'DropBoxy_Test') IS NOT NULL
BEGIN
    IF (SELECT state FROM sys.databases WHERE name = N'DropBoxy_Test') = 0
        ALTER DATABASE DropBoxy_Test SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE DropBoxy_Test;
END
GO

-- 5.1 TÂCHE 7 : restauration de la FULL en NORECOVERY
DECLARE @DataLogique sysname       = N'DropBoxy',      -- <-- LogicalName type D lu au script 4.2
        @LogLogique  sysname       = N'DropBoxy_log',  -- <-- LogicalName type L lu au script 4.2
        @Dossier     nvarchar(260) = CAST(SERVERPROPERTY('InstanceDefaultDataPath') AS nvarchar(260)),
        @sql         nvarchar(max);

IF @Dossier IS NULL   -- anciennes versions : on prend le dossier de la base master
    SELECT @Dossier = LEFT(physical_name, LEN(physical_name) - CHARINDEX(N'\', REVERSE(physical_name)) + 1)
    FROM sys.master_files WHERE database_id = 1 AND file_id = 1;

SET @sql = N'RESTORE DATABASE DropBoxy_Test
FROM DISK = N''C:\Backup\DropBoxy_full.bak''
WITH NORECOVERY,
     MOVE N''' + @DataLogique + N''' TO N''' + @Dossier + N'DropBoxy_Test.mdf'',
     MOVE N''' + @LogLogique  + N''' TO N''' + @Dossier + N'DropBoxy_Test_log.ldf'',
     STATS = 10;';

PRINT @sql;                      -- commande générée, à copier dans le dossier
EXEC sys.sp_executesql @sql;
GO

-- 5.2 État intermédiaire : DropBoxy_Test doit être en RESTORING
SELECT name, state_desc FROM sys.databases WHERE name = N'DropBoxy_Test';
GO

-- 5.2bis (facultatif, bonne capture) : base pas encore accessible
-- Erreur attendue : Msg 927 "Database 'DropBoxy_Test' cannot be opened. It is in the middle of a restore."
-- SELECT TOP (1) * FROM DropBoxy_Test.dbo.CLIENT;

-- 5.3 TÂCHES 8 et 9 : application de la DIFF et fin de restauration (RECOVERY)
RESTORE DATABASE DropBoxy_Test
FROM DISK = N'C:\Backup\DropBoxy_diff.bak'
WITH RECOVERY, STATS = 10;
GO

-- 5.4 État final : DropBoxy_Test doit être ONLINE
SELECT name, state_desc, create_date FROM sys.databases WHERE name LIKE N'DropBoxy%';
GO