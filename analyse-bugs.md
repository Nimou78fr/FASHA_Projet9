ID	           Problème	          /     Composant probable	/    Impact	   /     Fréquence	/    Priorité

BUG-01	Erreur avec 100 commandes /	UpdateAccountCA.trigger /	  Vente bloquée	 /    Fréquente	 /   Critique

BUG-02	Une seule commande calculée avec Data Loader /	Logique de NetAmount__c	 /  Montants incorrects	/  Fréquente  /	Critique

BUG-03	Total des commandes mal affiché	LWC Orders et contrôleur Apex	Mauvaise information	Fréquente	Haute

BUG-04	Traitement hebdomadaire très long	UpdateAccounts ou UpdateAllAccounts	Ralentissement	Hebdomadaire	Haute

BUG-05	Code désorganisé	Triggers et classes Apex	Maintenance difficile	Permanente	Moyenne

BUG-06	Tests insuffisants	Classes de test	Régression possible	À chaque déploiement	Haute

BUG-07	Absence de déploiement automatique fiable	Workflow .yml	Erreurs de déploiement	À chaque livraison	Haute



# Analyse des bugs de l’application Salesforce Fasha

## Sources analysées

- Notes de cadrage
- Retours utilisateurs
- Code source du dépôt GitHub

## Méthode de priorisation

La priorisation repose sur :

- l’impact sur les utilisateurs ;
- la fréquence du problème ;
- le blocage éventuel du processus de vente ;
- le risque lié aux données financières ;
- les dépendances avec les autres composants.

Analyse des bugs de l’application Salesforce Fasha
Sources analysées
Notes de cadrage
Retours utilisateurs
Code source du dépôt GitHub
Méthode de priorisation
La priorisation repose sur :

l’impact sur les utilisateurs ;
la fréquence du problème ;
le blocage éventuel du processus de vente ;
le risque lié aux données financières ;
les dépendances avec les autres composants.