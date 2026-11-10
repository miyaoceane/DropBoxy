USE DropBoxy;
GO
REVERT;   -- au cas où on serait encore sous une autre identité
GO

-- la liste des tests
DECLARE @t TABLE (
    Id          INT IDENTITY(1,1),
    Test        NVARCHAR(10),
    Profil      NVARCHAR(20),
    Utilisateur SYSNAME,
    Operation   NVARCHAR(100),
    Attendu     NVARCHAR(20),   -- AUTORISÉ ou REFUSÉ
    Cmd         NVARCHAR(MAX),  -- la requête à tester
    Obtenu      NVARCHAR(30),   -- rempli plus bas
    Code        INT,
    Message     NVARCHAR(400)
);

INSERT INTO @t (Test, Profil, Utilisateur, Operation, Attendu, Cmd) VALUES
-- SERVICE_CLIENT
(N'SC1',  N'SERVICE_CLIENT', N'u_service_client_test', N'SELECT sur CLIENT',                  N'AUTORISÉ',
    N'DECLARE @n INT; SELECT @n = COUNT(*) FROM dbo.CLIENT'),
(N'SC2',  N'SERVICE_CLIENT', N'u_service_client_test', N'SELECT sur COLIS',                   N'AUTORISÉ',
    N'DECLARE @n INT; SELECT @n = COUNT(*) FROM dbo.COLIS'),
(N'SC3',  N'SERVICE_CLIENT', N'u_service_client_test', N'SELECT RETRAIT (sans CodeRetrait)',  N'AUTORISÉ',
    N'DECLARE @n INT; SELECT @n = COUNT(*) FROM (SELECT IdRetrait, IdColis, DateRetrait FROM dbo.RETRAIT) AS x'),
(N'SC4',  N'SERVICE_CLIENT', N'u_service_client_test', N'SELECT colonne CodeRetrait',         N'REFUSÉ',
    N'DECLARE @n INT; SELECT @n = COUNT(CodeRetrait) FROM dbo.RETRAIT'),
(N'SC5',  N'SERVICE_CLIENT', N'u_service_client_test', N'UPDATE sur COLIS',                   N'REFUSÉ',
    N'UPDATE dbo.COLIS SET Statut = Statut WHERE IdColis = -1'),
(N'SC6',  N'SERVICE_CLIENT', N'u_service_client_test', N'SELECT sur INCIDENT',                N'REFUSÉ',
    N'DECLARE @n INT; SELECT @n = COUNT(*) FROM dbo.INCIDENT'),
-- DIRECTION
(N'DIR1', N'DIRECTION',      N'u_direction_test',      N'SELECT sur COLIS',                   N'AUTORISÉ',
    N'DECLARE @n INT; SELECT @n = COUNT(*) FROM dbo.COLIS'),
(N'DIR2', N'DIRECTION',      N'u_direction_test',      N'SELECT sur V_CLIENT_IDENTITE (vue)', N'AUTORISÉ',
    N'DECLARE @n INT; SELECT @n = COUNT(*) FROM dbo.V_CLIENT_IDENTITE'),
(N'DIR3', N'DIRECTION',      N'u_direction_test',      N'SELECT sur INCIDENT',                N'AUTORISÉ',
    N'DECLARE @n INT; SELECT @n = COUNT(*) FROM dbo.INCIDENT'),
(N'DIR4', N'DIRECTION',      N'u_direction_test',      N'SELECT sur CLIENT (données perso)',  N'REFUSÉ',
    N'DECLARE @n INT; SELECT @n = COUNT(*) FROM dbo.CLIENT'),
(N'DIR5', N'DIRECTION',      N'u_direction_test',      N'DELETE sur INCIDENT',                N'REFUSÉ',
    N'DELETE FROM dbo.INCIDENT WHERE IdIncident = -1'),
(N'DIR6', N'DIRECTION',      N'u_direction_test',      N'UPDATE sur POINT_RELAIS',            N'REFUSÉ',
    N'UPDATE dbo.POINT_RELAIS SET Statut = Statut WHERE IdPoint = -1');


-- exécuter chaque test
DECLARE @i INT = 1, @max INT, @u SYSNAME, @cmd NVARCHAR(MAX),
        @obt NVARCHAR(30), @code INT, @msg NVARCHAR(400);
SELECT @max = MAX(Id) FROM @t;

WHILE @i <= @max
BEGIN
    -- On récupère l'utilisateur et la commande, entourée d'un ROLLBACK
    SELECT @u = Utilisateur,
           @cmd = N'BEGIN TRANSACTION; ' + Cmd + N'; ROLLBACK TRANSACTION;'
    FROM @t WHERE Id = @i;

    SET @obt = NULL; SET @code = NULL; SET @msg = NULL;

    EXECUTE AS USER = @u;
    BEGIN TRY
        EXEC sys.sp_executesql @cmd;
        SET @obt = N'AUTORISÉ';
    END TRY
    BEGIN CATCH
        SET @obt  = CASE WHEN ERROR_NUMBER() IN (229, 230, 262) THEN N'REFUSÉ' ELSE N'ERREUR AUTRE' END;
        SET @code = ERROR_NUMBER();
        SET @msg  = LEFT(ERROR_MESSAGE(), 400);
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
    END CATCH;
    REVERT;

    UPDATE @t SET Obtenu = @obt, Code = @code, Message = @msg WHERE Id = @i;
    SET @i += 1;
END;

-- le tableau final
SELECT Test, Profil, Operation, Attendu, Obtenu, Code,
       LEFT(Message, 140) AS Message,
       CASE WHEN Attendu = Obtenu THEN N'✔ conforme' ELSE N'✘ ANOMALIE' END AS Verdict
FROM @t
ORDER BY Id;
GO