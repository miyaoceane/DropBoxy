----------------------- POINT_RELAIS ------------------------------

INSERT INTO dbo.POINT_RELAIS
    (Nom, Adresse, Ville, CodePostal, Statut)
VALUES
    ('Relais Centre', '12 rue Nationale', 'Lille', '59000', 'ACTIF'),
    ('Relais Gare', '5 rue de la Gare', 'Valenciennes', '59300', 'ACTIF'),
    ('Relais Nord', '20 rue de Paris', 'Douai', '59500', 'ACTIF'),
    ('Relais Sud', '8 avenue Faidherbe', 'Cambrai', '59400', 'INACTIF'),
    ('Relais Express', '15 rue Victor Hugo', 'Lens', '62300', 'ACTIF');


----------------------- CLIENT ------------------------------


INSERT INTO dbo.CLIENT
    (Nom, Prenom, Email, Telephone)
VALUES
    ('Dupont', 'Marie', 'marie.dupont@example.com', '0612345678'),
    ('Martin', 'Lucas', 'lucas.martin@example.com', '0623456789'),
    ('Bernard', 'Sarah', 'sarah.bernard@example.com', '0634567890'),
    ('Petit', 'Thomas', 'thomas.petit@example.com', '0645678901'),
    ('Robert', 'Emma', 'emma.robert@example.com', '0656789012');


----------------------- TECHNICIEN ------------------------------

INSERT INTO dbo.TECHNICIEN
    (Nom, Prenom, Specialite, Email)
VALUES
    ('Moreau', 'Paul', 'Maintenance casiers', 'paul.moreau@example.com'),
    ('Leroy', 'Julie', 'Reseaux', 'julie.leroy@example.com'),
    ('Simon', 'Antoine', 'Electronique', 'antoine.simon@example.com'),
    ('Laurent', 'Camille', 'Systemes connectes', 'camille.laurent@example.com'),
    ('Michel', 'Nicolas', 'Maintenance generale', 'nicolas.michel@example.com');

----------------------- CASIER ------------------------------


INSERT INTO dbo.CASIER (IdPoint, Numero, Taille, Statut)
VALUES
-- Point relais 1
(1, 101, 10, 'DISPONIBLE'),
(1, 102, 30, 'DISPONIBLE'),
(1, 103, 60, 'DISPONIBLE'),

-- Point relais 2
(2, 201, 10, 'DISPONIBLE'),
(2, 202, 30, 'DISPONIBLE'),
(2, 203, 60, 'DISPONIBLE'),

-- Point relais 3
(3, 301, 10, 'DISPONIBLE'),
(3, 302, 30, 'DISPONIBLE'),
(3, 303, 60, 'DISPONIBLE'),

-- Point relais 4
(4, 401, 10, 'DISPONIBLE'),
(4, 402, 30, 'DISPONIBLE'),
(4, 403, 60, 'DISPONIBLE'),

-- Point relais 5
(5, 501, 10, 'DISPONIBLE'),
(5, 502, 30, 'DISPONIBLE'),
(5, 503, 60, 'DISPONIBLE');

----------------------- INCIDENT ------------------------------

INSERT INTO dbo.INCIDENT
    (IdPoint, IdCasier, IdTechnicien, DateIncident,
     TypeIncident, Description, Statut, DateResolution)
VALUES
    (1, 1, 1, '2026-10-20',
     'Blocage porte', 'Porte du casier bloquee', 'RESOLU', '2026-10-21'),

    (1, 2, 2, '2026-10-21',
     'Probleme reseau', 'Connexion intermittente', 'EN_COURS', NULL),

    (2, 3, 3, '2026-10-22',
     'Panne electronique', 'Ecran du casier eteint', 'RESOLU', '2026-10-23'),

    (3, 4, 4, '2026-10-23',
     'Capteur defectueux', 'Capteur de fermeture a verifier', 'OUVERT', NULL),

    (5, 5, 5, '2026-10-24',
     'Probleme alimentation', 'Alimentation electrique instable', 'EN_COURS', NULL);


