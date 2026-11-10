-- SERVICE CLIENT 
GRANT SELECT ON OBJECT::dbo.CLIENT TO role_service_client;                   
GRANT SELECT ON OBJECT::dbo.COLIS  TO role_service_client;                    
-- Droit par colonne : CodeRetrait (secret de retrait) volontairement exclu
GRANT SELECT ON OBJECT::dbo.RETRAIT (IdRetrait, IdColis, DateRetrait) TO role_service_client;

-- DIRECTION 
GRANT SELECT ON OBJECT::dbo.POINT_RELAIS          TO role_direction;
GRANT SELECT ON OBJECT::dbo.CASIER                TO role_direction;
GRANT SELECT ON OBJECT::dbo.COLIS                 TO role_direction;
GRANT SELECT ON OBJECT::dbo.INCIDENT              TO role_direction;
GRANT SELECT ON OBJECT::dbo.RETRAIT (IdRetrait, IdColis, DateRetrait) TO role_direction; -- sans CodeRetrait
GRANT SELECT ON OBJECT::dbo.V_CLIENT_IDENTITE     TO role_direction;
GRANT SELECT ON OBJECT::dbo.V_TECHNICIEN_REPORTING TO role_direction;
GO