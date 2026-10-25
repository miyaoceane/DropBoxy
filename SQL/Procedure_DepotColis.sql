CREATE OR ALTER  PROCEDURE dbo.DepotColis
	@idClient INT,
	@idPointRelais INT,
	@idCasier INT,
	@dateDepot DATE,
	@poids DECIMAL(6,2),
	@taille INT,
	@statut VARCHAR(20)

AS
BEGIN
	SET NOCOUNT ON;

	BEGIN TRY
	BEGIN TRANSACTION;
		
		IF NOT EXISTS
		(
			SELECT 1
			FROM dbo.CLIENT
			WHERE IdClient = @idClient
		) 
		BEGIN 
			THROW 50001,
				  'Ce client n''existe pas !',
				  1;
		END;

		IF NOT EXISTS 
		(
			SELECT 1 
			FROM dbo.POINT_RELAIS 
			WHERE IdPoint = @idPointRelais
		)
		BEGIN
			THROW 50002,
				  'Le point relais n''existe pas !',
				  1;
		END;

		IF NOT EXISTS 
		(
			SELECT 1 
			FROM dbo.POINT_RELAIS 
			WHERE IdPoint = @idPointRelais AND Statut = 'ACTIF'
		)
		BEGIN
			THROW 50003,
				  'Le point relais est inactif !',
				  1;
		END;

		IF NOT EXISTS 
		(
			SELECT 1
			FROM dbo.CASIER 
			WHERE IdCasier = @idCasier AND IdPoint = @idPointRelais 
		)
		BEGIN
			THROW 50004,
				  'Le casier est incompatible !',
				  1;
		END;

		IF NOT EXISTS 
		(
			SELECT 1
			FROM dbo.CASIER 
			WHERE IdCasier = @idCasier AND IdPoint = @idPointRelais AND @taille <= Taille AND Statut = 'DISPONIBLE'
		)
		BEGIN
			THROW 50005,
				  'Le casier est indisponible !',
				  1;
		END;

			INSERT INTO dbo.COLIS
			(
				IdClient,
				IdPointDepot,
				IdCasier,
				DateDepot,
				Poids,
				Taille,
				Statut
			) 
			VALUES 
			(
				@idClient,
				@idPointRelais,
				@idCasier,
				@dateDepot,
				@Poids,
				@taille,
				@statut
			)

		UPDATE dbo.CASIER
		SET Statut = 'INDISPONIBLE'
		WHERE IdCasier = @idCasier;

		COMMIT TRANSACTION;
		SELECT SCOPE_IDENTITY() AS IdColis;

	END TRY

	BEGIN CATCH
		IF XACT_STATE() <> 0
			ROLLBACK;
		THROW;

	END CATCH;
	
END;
