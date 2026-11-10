USE DropBoxy;
GO

CREATE OR ALTER FUNCTION dbo.RechercherColis
(
    @idPoint INT = NULL,
    @statut VARCHAR(30) = NULL,
    @taille INT = NULL,
    @dateMin DATETIME2 = NULL,
    @dateMax DATETIME2 = NULL
)
RETURNS TABLE
AS
RETURN
(
    SELECT
        IdColis,
        IdClient,
        IdPointDepot,
        IdCasier,
        DateDepot,
        Poids,
        Taille,
        Statut,
        CodeRetrait
    FROM dbo.COLIS
    WHERE
        (@idPoint IS NULL OR IdPointDepot = @idPoint)
        AND (@statut IS NULL OR Statut = @statut)
        AND (@taille IS NULL OR Taille = @taille)
        AND (@dateMin IS NULL OR DateDepot >= @dateMin)
        AND (@dateMax IS NULL OR DateDepot <= @dateMax)
);
GO


