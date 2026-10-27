USE DropBoxy;
GO

DECLARE @DateDebut DATE = '2026-09-01';
DECLARE @DateFin DATE = '2026-10-31';

DECLARE @NomPoint VARCHAR(100);
SELECT * FROM dbo.RechercherColis(NULL, NULL, NULL, DATEADD(DAY,-4,SYSDATETIME()), NULL)
DECLARE @NbIncidents INT;
DECLARE @Niveau VARCHAR(20);

DECLARE CurseurPointsRelais CURSOR LOCAL FAST_FORWARD FOR

SELECT
    P.Nom,
    COUNT(I.IdIncident) AS NbIncidents
FROM POINT_RELAIS P
LEFT JOIN INCIDENT I
    ON P.IdPoint = I.IdPoint
   AND I.DateIncident >= @DateDebut
   AND I.DateIncident < DATEADD(DAY,1,@DateFin)

GROUP BY P.Nom;

OPEN CurseurPointsRelais;

FETCH NEXT
FROM CurseurPointsRelais
INTO @NomPoint,@NbIncidents;

WHILE @@FETCH_STATUS = 0
BEGIN

    IF @NbIncidents = 0
        SET @Niveau = 'NORMAL';

    ELSE IF @NbIncidents BETWEEN 1 AND 3
        SET @Niveau = 'SURVEILLANCE';

    ELSE
        SET @Niveau = 'PRIORITAIRE';

    PRINT 'Point relais : ' + @NomPoint +
          ' | Incidents : ' + CAST(@NbIncidents AS VARCHAR(10)) +
          ' | Niveau : ' + @Niveau;

    FETCH NEXT
    FROM CurseurPointsRelais
    INTO @NomPoint,@NbIncidents;

END;

CLOSE CurseurPointsRelais;
DEALLOCATE CurseurPointsRelais;
GO

--Version sans curseur

DECLARE @DateDebut DATE = '2026-09-01';
DECLARE @DateFin   DATE = '2026-10-31';

SELECT
    P.Nom,
    COUNT(I.IdIncident) AS NbIncidents,
    CASE
        WHEN COUNT(I.IdIncident) = 0 THEN 'NORMAL'
        WHEN COUNT(I.IdIncident) BETWEEN 1 AND 3 THEN 'SURVEILLANCE'
        ELSE 'PRIORITAIRE'
    END AS NiveauSurveillance
FROM POINT_RELAIS P
LEFT JOIN INCIDENT I
    ON P.IdPoint = I.IdPoint
   AND I.DateIncident >= @DateDebut
   AND I.DateIncident <  DATEADD(DAY, 1, @DateFin)
GROUP BY P.IdPoint, P.Nom
ORDER BY P.Nom;
GO