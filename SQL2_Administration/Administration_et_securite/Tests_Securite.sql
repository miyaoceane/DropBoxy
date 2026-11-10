USE DropBoxy;
GO

-- ===== SERVICE_CLIENT =====

-- SC1 : AUTORISÉ
EXECUTE AS USER = 'u_service_client_test';
SELECT * FROM CLIENT;
REVERT;

-- SC2 : AUTORISÉ
EXECUTE AS USER = 'u_service_client_test';
SELECT * FROM COLIS;
REVERT;

-- SC3 : AUTORISÉ (sans CodeRetrait)
EXECUTE AS USER = 'u_service_client_test';
SELECT IdRetrait, IdColis, DateRetrait FROM RETRAIT;
REVERT;

-- SC4 : REFUSÉ (colonne CodeRetrait)
EXECUTE AS USER = 'u_service_client_test';
SELECT CodeRetrait FROM RETRAIT;
REVERT;

-- SC5 : REFUSÉ (modification d'un colis)
EXECUTE AS USER = 'u_service_client_test';
UPDATE COLIS SET Statut = 'DEPOSE' WHERE IdColis = -1;
REVERT;

-- SC6 : REFUSÉ (incidents)
EXECUTE AS USER = 'u_service_client_test';
SELECT * FROM INCIDENT;
REVERT;

-- ===== DIRECTION =====

-- DIR1 : AUTORISÉ
EXECUTE AS USER = 'u_direction_test';
SELECT * FROM COLIS;
REVERT;

-- DIR2 : AUTORISÉ
EXECUTE AS USER = 'u_direction_test';
SELECT * FROM V_CLIENT_IDENTITE;
REVERT;

-- DIR3 : AUTORISÉ
EXECUTE AS USER = 'u_direction_test';
SELECT * FROM INCIDENT;
REVERT;

-- DIR4 : REFUSÉ (données perso)
EXECUTE AS USER = 'u_direction_test';
SELECT * FROM CLIENT;
REVERT;

-- DIR5 : REFUSÉ
EXECUTE AS USER = 'u_direction_test';
DELETE FROM INCIDENT WHERE IdIncident = -1;
REVERT;

-- DIR6 : REFUSÉ
EXECUTE AS USER = 'u_direction_test';
UPDATE POINT_RELAIS SET Statut = 'ACTIF' WHERE IdPoint = -1;
REVERT;


-- ===== EXPLOITATION =====
--Test 1 : Exploitation consulte les colis

EXECUTE AS USER = 'test_exploit';

SELECT * FROM COLIS;

REVERT;

--Test 2 : Exploitation modifie un colis

EXECUTE AS USER = 'test_exploit';

UPDATE COLIS
SET Statut = 'DEPOSE'
WHERE IdColis = 1;

REVERT;

--Test 3 : Exploitation tente de consulter les incidents

EXECUTE AS USER = 'test_exploit';

SELECT * FROM INCIDENT;

REVERT;

-- ===== TECHNICIEN =====

--Test 1 : Technicien consulte les incidents

EXECUTE AS USER = 'test_tech';

SELECT * FROM INCIDENT;

REVERT;

--Test 2 : Technicien modifie un incident

EXECUTE AS USER = 'test_tech';

UPDATE INCIDENT
SET Statut = 'RESOLU'
WHERE IdIncident = 4;

REVERT;

--Test 3 : Technicien tente de modifier un colis

EXECUTE AS USER = 'test_tech';

UPDATE COLIS
SET Statut = 'RETIRE'
WHERE IdColis = 1;

REVERT;

--Test 4 : Technicien tente de consulter les clients

EXECUTE AS USER = 'test_tech';

SELECT * FROM CLIENT;

REVERT;

