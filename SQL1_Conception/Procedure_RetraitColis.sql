USE DropBoxy;
GO

CREATE OR ALTER PROCEDURE RetraitColis
(
    @IdColis INT,
    @CodeRetrait VARCHAR(50)
)
AS
BEGIN

    SET NOCOUNT ON;

    BEGIN TRY

        BEGIN TRANSACTION;

        -- Vérifie que le colis existe
        IF NOT EXISTS
        (
            SELECT 1
            FROM COLIS
            WHERE IdColis = @IdColis
        )
        BEGIN
            THROW 50010,
            'Le colis est introuvable.',
            1;
        END;

        -- Vérifie le statut
        IF EXISTS
        (
            SELECT 1
            FROM COLIS
            WHERE IdColis = @IdColis
            AND Statut = 'RETIRE'
        )
        BEGIN
            THROW 50011,
            'Le colis a déjà été retiré.',
            1;
        END;

        -- Vérifie le code de retrait
        IF NOT EXISTS
        (
            SELECT 1
            FROM COLIS
            WHERE IdColis = @IdColis
            AND CodeRetrait = @CodeRetrait
        )
        BEGIN
            THROW 50012,
            'Code de retrait incorrect.',
            1;
        END;

        INSERT INTO RETRAIT
        (
            IdColis,
            CodeRetrait
        )
        VALUES
        (
            @IdColis,
            @CodeRetrait
        );

        UPDATE COLIS
        SET Statut = 'RETIRE'
        WHERE IdColis = @IdColis;

        UPDATE CASIER
        SET Statut = 'DISPONIBLE'
        WHERE IdCasier =
        (
            SELECT IdCasier
            FROM COLIS
            WHERE IdColis = @IdColis
        );

        COMMIT TRANSACTION;

        PRINT 'Retrait effectué avec succès.';

    END TRY

    BEGIN CATCH

        IF XACT_STATE() <> 0
            ROLLBACK TRANSACTION;

        THROW;

    END CATCH

END;
GO