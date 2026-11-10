USE DropBoxy_Test;
GO

-- PRÉSENCE DES TABLES
SELECT name AS [Table] FROM sys.tables ORDER BY name;

-- PRÉSENCE DES DONNÉES (lignes par table)
SELECT t.name AS [Table], SUM(p.row_count) AS NbLignes
FROM sys.tables t
JOIN sys.dm_db_partition_stats p ON p.object_id = t.object_id AND p.index_id IN (0, 1)
GROUP BY t.name
ORDER BY t.name;
GO