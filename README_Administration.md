# DROPBOXY — Administration et Sécurité SQL Server

## 1. Présentation du projet

DropBoxy est une entreprise qui exploite un réseau de points relais et de casiers connectés permettant le dépôt et le retrait de colis.

Dans le cadre de ce projet, nous intervenons sur l'administration et la sécurisation de la base de données SQL Server de l'entreprise.

L'objectif est de mettre en place une gestion des accès adaptée aux différents profils utilisateurs, de contrôler les permissions accordées et de garantir la disponibilité des données grâce à une stratégie de sauvegarde et de restauration.

## 2. Technologies utilisées

- **Système de gestion de base de données :** Microsoft SQL Server
- **Outil d'administration :** SQL Server Management Studio (SSMS)
- **Langage utilisé :** Transact-SQL (T-SQL)
- **Sauvegardes :** sauvegarde complète (FULL) et différentielle (DIFF)

## 3. Fonctionnalités du projet

### 3.1. Gestion des rôles

Quatre rôles ont été créés afin de séparer les autorisations selon les missions des utilisateurs :

- `role_exploitation` : gestion quotidienne des points relais, des casiers, des colis et des retraits.
- `role_technicien` : consultation des points relais, des casiers et des techniciens, ainsi que gestion des incidents.
- `role_service_client` : consultation des informations clients, des colis et des retraits afin d'assurer le suivi des demandes.
- `role_direction` : consultation des données nécessaires au suivi de l'activité et à la réalisation de reportings.

### 3.2. Sécurisation des accès

La sécurité repose sur le principe du moindre privilège : chaque utilisateur dispose uniquement des droits nécessaires à ses missions.

Les permissions sont attribuées aux rôles et non directement aux utilisateurs.

Les principales règles appliquées sont :

- Aucun utilisateur ne possède le rôle `db_owner`.
- Les droits de suppression (`DELETE`) ne sont pas accordés.
- Les informations sensibles, notamment le code de retrait, sont protégées.
- Les accès aux données sont limités selon le profil utilisateur.

### 3.3. Utilisateurs de test

Des utilisateurs de test ont été créés pour vérifier le fonctionnement des rôles et des permissions :

- `test_exploit`
- `test_tech`
- `test_service_client`
- `test_direction`

Ces comptes permettent de réaliser des tests afin de vérifier que les opérations autorisées sont possibles et que les opérations interdites sont correctement bloquées.

### 3.4. Sauvegarde de la base de données

Deux types de sauvegardes sont mis en place :

- **Sauvegarde complète (FULL) :** permet de sauvegarder l'ensemble de la base de données.
- **Sauvegarde différentielle (DIFF) :** permet de sauvegarder les modifications effectuées depuis la dernière sauvegarde complète.

Les fichiers générés sont :

- `DropBoxy_full.bak`
- `DropBoxy_diff.bak`

### 3.5. Restauration de la base de données

Une restauration est réalisée dans une nouvelle base appelée `DropBoxy_Test`, à partir de la sauvegarde complète et de la sauvegarde différentielle.

La restauration utilise les options `NORECOVERY` et `RECOVERY` afin d'appliquer les deux sauvegardes dans le bon ordre.

Des vérifications sont ensuite effectuées pour contrôler l'état de la base restaurée et la présence des données.

### 3.6. Reporting

Des requêtes SQL permettent de consulter et d'analyser les informations de la base de données, notamment :

- le nombre de colis par point relais ;
- le nombre de colis par statut ;
- le nombre d'incidents par statut ;
- la liste des incidents non résolus ;
- l'historique des modifications des colis.

## 4. Organisation du projet

Le projet regroupe les scripts SQL et la documentation technique.

Exemple d'organisation :


```text
DropBoxy/
│
├── Documentation/
│   ├── Dossier technique1 - Projet DropBoxy.pdf
│   └── Dossier technique2 - Administration et Sécurité.pdf
│
├── SQL1_Conception/
│   ├── Curseur_AnalysePointRelais.sql
│   ├── Fonction_Scalaire_CalculerPrixStockage.sql
│   ├── Fonction_Table_RechercherColis.sql
│   ├── Procedure_DepotColis.sql
│   ├── Procedure_RetraitColis.sql
│   ├── Tables.sql
│   ├── Tables_Peuplement.sql
│   ├── Trigger_ControleRetrait.sql
│   └── Trigger_HistoriqueColis.sql
│
├── SQL2_Administration/
│   │
│   ├── Administration_et_securite/
│   │   ├── Permissions.sql
│   │   ├── Roles.sql
│   │   ├── Tests_Securite.sql
│   │   ├── Utilisateurs_Tests.sql
│   │   └── Vue.sql
│   │
│   └── Sauvegarde_et_Restauration/
│       ├── Reporting.sql
│       ├── Restauration_DropBoxy_Test.sql
│       ├── Sauvegarde.sql
│       └── Verification_Restauration.sql
│
├── .gitattributes
├── .gitignore
├── Conception Base de Données.slnx
├── README_Administratio,.md
└── README_Conception.md
```


*Remarque : les noms des fichiers présentés sont indicatifs et doivent correspondre aux noms réellement utilisés dans le dépôt.*

## 5. Guide d'installation et d'utilisation

### Prérequis

- Installer Microsoft SQL Server.
- Installer SQL Server Management Studio (SSMS).
- Disposer des droits nécessaires pour créer des rôles, des utilisateurs et des bases de données, ainsi que pour effectuer des sauvegardes et des restaurations.

### Étapes de lancement

1. Ouvrir SQL Server Management Studio et se connecter à une instance SQL Server.
2. Sélectionner la base de données `DropBoxy`.
3. Exécuter les scripts de création des rôles.
4. Exécuter les scripts de création des utilisateurs de test.
5. Exécuter les scripts d'attribution des permissions aux rôles.
6. Exécuter les scripts de tests pour vérifier les accès autorisés et interdits.
7. Réaliser la sauvegarde complète de la base.
8. Effectuer les modifications nécessaires, puis réaliser la sauvegarde différentielle.
9. Exécuter le script de restauration dans la base `DropBoxy_Test`.
10. Lancer les requêtes de vérification et de reporting.

**Important :** respecter l'ordre d'exécution des scripts afin de garantir la cohérence des opérations.

## 6. Tests effectués

Des tests ont été réalisés afin de vérifier le fonctionnement de la sécurité.

Ils portent notamment sur :

- la consultation des colis par les profils autorisés ;
- la modification des données par les profils habilités ;
- la consultation des incidents par les techniciens ;
- la consultation des informations clients par le service client ;
- la consultation des vues de reporting par la direction ;
- le refus d'accès aux données non autorisées ;
- le blocage de la consultation du code de retrait par le service client ;
- la vérification de la restauration et des données récupérées.

## 7. Difficultés rencontrées

Les principales difficultés ont concerné la définition des permissions adaptées à chaque profil, le respect du principe du moindre privilège et la vérification des droits réellement appliqués aux utilisateurs.

La mise en place de la restauration a également nécessité de respecter l'ordre d'application des sauvegardes complète et différentielle, ainsi que l'utilisation correcte des options `NORECOVERY` et `RECOVERY`.

## 8. Limites et améliorations possibles

Plusieurs améliorations pourraient être envisagées :

- automatiser les sauvegardes avec SQL Server Agent ;
- mettre en place des sauvegardes régulières du journal des transactions ;
- renforcer l'audit des connexions et des opérations réalisées ;
- conserver les sauvegardes sur un emplacement externe ;
- automatiser les tests de restauration ;
- mettre en place des tableaux de bord de reporting ;
- renforcer la protection des données sensibles.

## 9. Membres et répartition des tâches

Le projet a été réalisé en binôme. Les tâches ont été réparties entre les deux membres afin de couvrir les différentes parties de l'administration, de la sécurité, des sauvegardes, de la restauration et du reporting.

### Maimouna Sokhna Thiam :

**Administration et sécurité :**
- Élaboration de la matrice des permissions pour les profils EXPLOITATION et TECHNICIEN.
- Création des rôles `role_exploitation` et `role_technicien`.
- Attribution des permissions nécessaires à ces deux rôles.
- Création des utilisateurs de test correspondants.
- Préparation des scripts de tests pour ces deux profils.

**Sauvegardes :**
- Réalisation de la sauvegarde complète (FULL).
- Vérification de la sauvegarde complète.
- Réalisation de modifications dans la base de données.
- Réalisation de la sauvegarde différentielle (DIFF).
- Vérification de la sauvegarde différentielle.

**Reporting :**
- Création d'une requête sur le nombre de colis par point relais.
- Création d'une requête sur le nombre de casiers disponibles par point relais.

**Documentation :**
- Rédaction des parties concernant les rôles EXPLOITATION et TECHNICIEN.
- Rédaction de la partie concernant les sauvegardes.
- Documentation des requêtes de reporting réalisées.

### Ablan Miya Océane Kouadio :

**Administration et sécurité :**
- Élaboration de la matrice des permissions pour les profils SERVICE_CLIENT et DIRECTION.
- Création des rôles `role_service_client` et `role_direction`.
- Attribution des permissions nécessaires à ces deux rôles.
- Création des utilisateurs de test correspondants.
- Préparation des scripts de tests pour ces deux profils.

**Restauration :**
- Récupération des fichiers de sauvegarde FULL et DIFF réalisés par le membre 1.
- Restauration de la sauvegarde complète dans la base `DropBoxy_Test` avec l'option `NORECOVERY`.
- Application de la sauvegarde différentielle.
- Finalisation de la restauration avec l'option `RECOVERY`.
- Vérification de la présence des tables et des données.
- Vérification de la récupération des modifications effectuées avant la sauvegarde différentielle.

**Reporting :**
- Création d'une requête sur le nombre de colis par statut.
- Création d'une requête sur le nombre d'incidents par point relais.

**Documentation :**
- Rédaction des parties concernant les rôles SERVICE_CLIENT et DIRECTION.
- Rédaction de la partie concernant la restauration.
- Documentation des requêtes de reporting réalisées.

### Travail réalisé en commun

Les deux membres ont également participé à :
- l'intégration des différents scripts SQL ;
- la vérification du fonctionnement des quatre rôles ;
- la validation des opérations autorisées et interdites ;
- la réalisation des tests finaux ;
- la vérification de la cohérence générale du projet.

Cette répartition permet de distinguer les responsabilités de chaque membre tout en assurant une validation commune de la solution.

## 10. Conclusion

Ce projet permet de mettre en pratique les mécanismes d'administration et de sécurité de Microsoft SQL Server.

La création de rôles, l'attribution des permissions, les tests d'accès et la mise en place d'une stratégie de sauvegarde et de restauration contribuent à sécuriser la base de données DropBoxy et à garantir une meilleure disponibilité des informations.
