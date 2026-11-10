CREATE OR ALTER TRIGGER dbo.HistoriqueColis
ON dbo.COLIS
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO dbo.HISTORIQUE_COLIS 
    (
        IdColis, 
        AncienStatut, 
        NouveauStatut
    )
    SELECT i.IdColis, d.Statut, i.Statut
    FROM inserted i
    JOIN deleted d 
    ON i.IdColis = d.IdColis
    WHERE i.Statut <> d.Statut;
END;
GO
