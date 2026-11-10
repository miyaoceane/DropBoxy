---Le prix de stockage sera fixer en fonction du poids et de la durée de stockage 
---0,50 euros par kilo et 0,10 euros par heure 

CREATE OR ALTER FUNCTION CalculerPrixStockage
(
@poids DECIMAL(10,2),
@durreeStockage INT
)
RETURNS DECIMAL(10,2)
AS
BEGIN
	RETURN (@poids * 0.5) + (@durreeStockage * 0.10);

END
GO


