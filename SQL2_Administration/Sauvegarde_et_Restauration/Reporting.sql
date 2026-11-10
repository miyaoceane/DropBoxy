USE DropBoxy;
GO

-- Nombre de colis par statut
SELECT Statut, COUNT(*) AS NbColis
FROM dbo.COLIS
GROUP BY Statut
ORDER BY NbColis DESC;

--  Nombre d'incidents par point relais (les points sans incident apparaissent avec 0)
SELECT p.IdPoint, p.Nom AS PointRelais, p.Ville, COUNT(i.IdIncident) AS NbIncidents
FROM dbo.POINT_RELAIS p
LEFT JOIN dbo.INCIDENT i ON i.IdPoint = p.IdPoint
GROUP BY p.IdPoint, p.Nom, p.Ville
ORDER BY NbIncidents DESC, p.Nom;
GO

--Preuve : la Direction peut exécuter ces extractions avec son propre compte
EXECUTE AS USER = N'u_direction_test';
    SELECT Statut, COUNT(*) AS NbColis FROM dbo.COLIS GROUP BY Statut ORDER BY NbColis DESC;
    SELECT p.IdPoint, p.Nom AS PointRelais, p.Ville, COUNT(i.IdIncident) AS NbIncidents
    FROM dbo.POINT_RELAIS p LEFT JOIN dbo.INCIDENT i ON i.IdPoint = p.IdPoint
    GROUP BY p.IdPoint, p.Nom, p.Ville ORDER BY NbIncidents DESC, p.Nom;
REVERT;
GO
