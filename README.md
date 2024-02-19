# Modules Bicep pour déployer ModernRecrut sur Azure :

Ce dépôt contient des modules Bicep permettant de créer des ressources Azure pour héberger l'application ModernRecrut (https://github.com/Akrem30/ModernRecrut). 

Il contient trois modules :

-AppServices : ce module crée les plans de service et les App Services nécessaires pour chaque microservice de ModernRecrut.

-SqlDb : ce module crée un serveur et des bases de données SQL Azure qui seront utilisées par les API Postulation et Offres Emplois.

-Storage : ce module crée un compte de stockage et un conteneur qui sera utilisé par l'API Document pour sauvegarder les documents téléchargés par les utilisateurs.

## Prérequis : 

-Un abonnement Azure actif

-Azure CLI installé

-L'extension bicep installée pour Azure CLI

