-- ÉTAPE 1 : contenu des fichiers reçus (BackupType 1 = FULL, 5 = DIFF)
RESTORE HEADERONLY FROM DISK = 'C:\Backup\DropBoxy_full.bak';
RESTORE HEADERONLY FROM DISK = 'C:\Backup\DropBoxy_diff.bak';
GO

-- ÉTAPE 2 : noms logiques des fichiers (colonne LogicalName : type D = données, type L = journal)
RESTORE FILELISTONLY FROM DISK = 'C:\Backup\DropBoxy_full.bak';
GO

-- ÉTAPE 3 : dossier où ranger les fichiers (recopie le dossier de master.mdf)
USE master;
GO
SELECT name, physical_name FROM sys.database_files;
GO

-- ÉTAPE 4 : restauration de la FULL en NORECOVERY (la base reste en RESTORING)
RESTORE DATABASE DropBoxy_Test
FROM DISK = 'C:\Backup\DropBoxy_full.bak'
WITH
    MOVE 'DropBoxy'     
    TO 'C:\Program Files\Microsoft SQL Server\MSSQL17.SQLEXPRESS\MSSQL\DATA\DropBoxy_Test.mdf',
    MOVE 'DropBoxy_log' 
    TO 'C:\Program Files\Microsoft SQL Server\MSSQL17.SQLEXPRESS\MSSQL\DATA\DropBoxy_Test_log.ldf',
    NORECOVERY;
GO

-- ÉTAPE 5 : état intermédiaire (DropBoxy_Test doit être en RESTORING)
SELECT name, state_desc FROM sys.databases;
GO

-- ÉTAPE 6 : application de la DIFF en RECOVERY (fin de la restauration)
RESTORE DATABASE DropBoxy_Test
FROM DISK = 'C:\Backup\DropBoxy_diff.bak'
WITH RECOVERY;
GO

-- ÉTAPE 7 : état final (DropBoxy_Test doit être ONLINE)
SELECT name, state_desc FROM sys.databases;
GO

-- ÉTAPE 8 : vérifications de DropBoxy_Test
USE DropBoxy_Test;
GO

-- Données présentes
SELECT COUNT(*) AS NbClients FROM dbo.CLIENT;
SELECT COUNT(*) AS NbColis   FROM dbo.COLIS;

-- Modification faite avant la DIFF : client ajouté après la FULL
SELECT * FROM dbo.CLIENT WHERE Nom = 'TEST_DIFF';
GO
