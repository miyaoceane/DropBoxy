USE DropBoxy;
GO

CREATE OR ALTER TRIGGER trg_ControleRetrait
ON dbo.RETRAIT
INSTEAD OF INSERT
AS
BEGIN

    IF EXISTS
    (
        SELECT 1
        FROM inserted i
        INNER JOIN dbo.COLIS c
            ON c.IdColis = i.IdColis
        WHERE c.Statut <> 'DEPOSE'
    )
    BEGIN
        THROW 50030,
        'Retrait interdit : le statut du colis ne permet pas le retrait.',
        1;
    END;

    INSERT INTO dbo.RETRAIT
    (
        IdColis,
        DateRetrait,
        CodeRetrait
    )
    SELECT
        IdColis,
        DateRetrait,
        CodeRetrait
    FROM inserted;

END;
GO