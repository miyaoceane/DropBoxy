USE DropBoxy;
GO
REVERT;                                   -- sécurité
EXECUTE AS USER = N'u_direction_test';    -- tout le reporting est exécuté en Direction

-- 1. Nombre de colis par statut
SELECT Statut, COUNT(*) AS NbColis
FROM dbo.COLIS
GROUP BY Statut
ORDER BY NbColis DESC;

-- 2. Nombre de colis par point relais
SELECT p.IdPoint, p.Nom AS PointRelais, COUNT(c.IdColis) AS NbColis
FROM dbo.POINT_RELAIS p
LEFT JOIN dbo.COLIS c ON c.IdPointDepot = p.IdPoint
GROUP BY p.IdPoint, p.Nom
ORDER BY NbColis DESC;

-- 3. Nombre d'incidents par point relais (les points sans incident affichent 0)
SELECT p.IdPoint, p.Nom AS PointRelais, p.Ville, COUNT(i.IdIncident) AS NbIncidents
FROM dbo.POINT_RELAIS p
LEFT JOIN dbo.INCIDENT i ON i.IdPoint = p.IdPoint
GROUP BY p.IdPoint, p.Nom, p.Ville
ORDER BY NbIncidents DESC, p.Nom;

-- 4. Nombre d'incidents par statut
SELECT Statut, COUNT(*) AS NbIncidents
FROM dbo.INCIDENT
GROUP BY Statut;

-- 5. Liste des incidents non résolus
SELECT IdIncident, TypeIncident, Description, Statut
FROM dbo.INCIDENT
WHERE Statut <> 'RESOLU';

-- 6. Historique des modifications de statut des colis
SELECT IdColis, DateModification, AncienStatut, NouveauStatut
FROM dbo.HISTORIQUE_COLIS
ORDER BY DateModification DESC;

REVERT;                                   -- retour au compte admin
GO
