-- Sauvegarde complète

BACKUP DATABASE DropBoxy
TO DISK = 'C:\Backup\DropBoxy_full.bak'
WITH INIT;
GO

-- Vérification de la sauvegarde

RESTORE VERIFYONLY
FROM DISK = 'C:\Backup\DropBoxy_full.bak';
GO

-- Sauvegarde différentielle

BACKUP DATABASE DropBoxy
TO DISK = 'C:\Backup\DropBoxy_diff.bak'
WITH DIFFERENTIAL;
GO

-- Vérification de la sauvegarde différentielle

RESTORE VERIFYONLY
FROM DISK = 'C:\Backup\DropBoxy_diff.bak';
GO
