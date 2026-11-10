-- SERVICE CLIENT 
GRANT SELECT
ON OBJECT::dbo.CLIENT
TO role_service_client; 

GRANT SELECT 
ON OBJECT::dbo.COLIS  
TO role_service_client;                    
-- Droit par colonne : CodeRetrait (secret de retrait) volontairement exclu
GRANT SELECT 
ON OBJECT::dbo.RETRAIT (IdRetrait, IdColis, DateRetrait) 
TO role_service_client;

-- DIRECTION 
GRANT SELECT 
ON OBJECT::dbo.POINT_RELAIS         
TO role_direction;

GRANT SELECT  
ON OBJECT::dbo.CASIER                
TO role_direction;

GRANT SELECT 
ON OBJECT::dbo.COLIS                 
TO role_direction;

GRANT SELECT 
ON OBJECT::dbo.INCIDENT              
TO role_direction;

GRANT SELECT 
ON OBJECT::dbo.RETRAIT (IdRetrait, IdColis, DateRetrait) 
TO role_direction; -- sans CodeRetrait

GRANT SELECT 
ON OBJECT::dbo.V_CLIENT_IDENTITE     
TO role_direction;

GRANT SELECT 
ON OBJECT::dbo.V_TECHNICIEN_REPORTING 
TO role_direction;

-- EXPLOITATION
GRANT SELECT, INSERT, UPDATE
ON POINT_RELAIS
TO role_exploitation;

GRANT SELECT, INSERT, UPDATE
ON CASIER
TO role_exploitation;

GRANT SELECT
ON CLIENT
TO role_exploitation;

GRANT SELECT, INSERT, UPDATE
ON COLIS
TO role_exploitation;

GRANT SELECT, INSERT, UPDATE
ON RETRAIT
TO role_exploitation;

GRANT SELECT
ON HISTORIQUE_COLIS
TO role_exploitation;

-- TECHNICIEN
GRANT SELECT
ON POINT_RELAIS
TO role_technicien;

GRANT SELECT
ON CASIER
TO role_technicien;

GRANT SELECT
ON TECHNICIEN
TO role_technicien;

GRANT SELECT, INSERT, UPDATE
ON INCIDENT
TO role_technicien;
GO
