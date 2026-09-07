# PosiTraining

Carnet d'entraînement multi-profils : programme (généré selon tes objectifs), suivi de progression, suivi du poids et nutrition. Une seule page web, sans installation ni build.

## Utiliser l'app
1. Ouvre `index.html` dans un navigateur (ordinateur ou téléphone), ou l'URL en ligne (voir plus bas).
2. Sur mobile : menu du navigateur → **Ajouter à l'écran d'accueil**. L'app est installable (icône + écran de démarrage propres) et s'ouvre en plein écran comme une vraie app — sans passer par un app store.

> ⚠️ **iOS : fais un Export AVANT d'ajouter à l'écran d'accueil.** Sur iPhone, l'app ouverte depuis l'icône peut utiliser un stockage local **séparé** de celui de Safari (comportement connu d'iOS, pas un bug de l'app) — au premier lancement depuis l'icône, tu peux te retrouver face à un profil vide alors que tes données sont toujours dans Safari. Si ça arrive : Réglages (⚙︎) → **Exporter mes données** dans Safari, puis **Importer une sauvegarde** dans l'app installée.

## Plusieurs personnes, une seule app
Réglages (⚙︎) → **Qui s'entraîne ?** : chaque personne a son profil, son programme et ses données, complètement séparés.

- **+ Nouveau profil** ouvre un questionnaire (prénom, sexe, âge, poids, taille, objectif, jours d'entraînement par semaine, niveau, limites/douleurs, points faibles à prioriser, points forts à réduire). L'app génère un programme adapté :
  - le **sexe** affine le calcul des besoins caloriques (formule de Mifflin-St Jeor) ;
  - une **limite cochée** (genou, épaule, bas du dos, coude, poignet, cheville) fait automatiquement retirer ou remplacer les exercices à risque, avec le détail affiché à l'écran de validation ;
  - un **point faible** ajoute du volume dessus, un **point fort** en retire.
  - Tout reste ajustable (changer un exercice, l'objectif de poids, les cibles nutrition) avant de valider.
- Les chips affichent les profils existants — touche-en un pour basculer dessus. Aucune connexion n'est nécessaire pour changer de profil.
- **Supprimer ce profil** efface définitivement un profil et ses données (disponible dès qu'il y en a plusieurs).
- Les données de chaque profil restent sur l'appareil ; utilise Export/Import (voir ci-dessous) pour les transférer vers un autre appareil.

## Accueil
L'app s'ouvre toujours sur l'Accueil. La barre en bas de l'écran (accessible au pouce) donne accès à **Accueil / Séance / Poids / Nutrition / Agenda**. L'accueil propose 3 raccourcis :
- **Reprendre le programme** → va directement à la séance du jour.
- **Abdos express** → choisis la durée (10/15/20 min) et si tu veux des **exercices adaptés périnée** (sans pression abdominale — pas de crunch ni de relevé de jambes ; utile en post-partum, en cas de gêne ou de désir de grossesse), puis **C'est parti**. Le bouton et l'écran de réglages sont identiques pour tout le monde, seul ce choix (fait à chaque lancement) change les exercices proposés.
- **Cardio** → dis d'abord ton **objectif** (récupération active, raffermir, perdre de la cellulite, améliorer le cardio, fractionné/HIIT, ou libre) : l'app te propose un type de séance et une durée adaptés (modifiables), avec des repères concrets (inclinaison, vitesse, résistance…). Une fois la séance faite, indique le temps réel, et si tu veux, ton ressenti et une note libre (réglages utilisés…) — c'est enregistré et visible dans l'Agenda.

## Agenda
Un calendrier du mois avec un point sur chaque jour où une séance a été faite (programme, abdos express ou cardio), et la liste détaillée en dessous. Navigue avec les flèches ‹ › pour consulter les mois précédents.

## Pendant la séance
- **Séance / Poids / Nutrition** se change via la barre en bas de l'écran, accessible au pouce sans avoir à remonter.
- **Glisse à gauche/droite** sur la séance pour passer au jour suivant/précédent, sans repasser par les onglets du haut.
- Une **suggestion de charge** apparaît quand tu as atteint le haut de la fourchette de reps la fois précédente.
- Un **échauffement** (deux paliers à 50 % et 75 %) est suggéré sur les mouvements principaux.
- Une série se **coche toute seule** dès que tu saisis le poids ou les reps — plus besoin de taper sur le ✓. Le **minuteur de repos démarre automatiquement** à ce moment-là. Une erreur de saisie ? Le ✓ reste cliquable pour décocher.
- Un réglage de **temps disponible** (30 à 90 min) en haut de la séance masque les derniers exercices si besoin, sans jamais descendre sous 30 minutes.
- Pas de machine dispo, ou muscle trop douloureux ? **⏭ Passer** sur la carte de l'exercice — il ne compte plus dans la progression de la séance et revient normalement la semaine suivante.
- **+ Ajouter un exercice** en bas de la séance pour insérer un mouvement de ton choix (nom, séries, reps, repos) — utile si aucune alternative proposée ne convient. Reste dans ton programme (✕ Retirer pour l'enlever).

## Où sont mes données ?
Les données (charges, poids, séances validées, exercices remplacés) sont enregistrées **dans le navigateur** de l'appareil (localStorage). Il n'y a pas de synchro cloud automatique.

- **Sauvegarde / transfert manuel** : Réglages (⚙︎) → **Exporter mes données** télécharge un fichier `.json`. Sur un autre appareil : Réglages → **Importer une sauvegarde**.
- ⚠️ Fais un export **avant de changer d'appareil ou de réinstaller l'app** — sinon les données restent sur l'ancien.
- L'onglet **Poids** suit aussi le tour de taille, de bras et de hanches (utile pour juger une recomposition au-delà du seul chiffre sur la balance).

## L'app en ligne
Hébergée gratuitement sur GitHub Pages : **https://balenrion.github.io/Positraining/**

## Structure du projet
- `index.html` — toute l'app (HTML + CSS + JavaScript, zéro dépendance externe, aucun appel réseau).

## Feuille de route
- [x] Programme 5-6 jours + séance légère du soir
- [x] Suivi des charges + progression, minuteur de repos
- [x] Fiches technique + alternatives + sélecteur d'exercice
- [x] Suivi du poids avec objectif et rythme
- [x] Bouton « Terminer la séance »
- [x] Onglet nutrition (menus + timing)
- [x] Export / Import des données
- [x] Hébergement (GitHub Pages)
- [x] Profils multi-utilisateurs (sélecteur local) + générateur de programme par questionnaire
- [x] Suggestion de charge, échauffement, minuteur automatique
- [x] Limites/douleurs en cases à cocher (exclusion/remplacement automatique des exercices à risque)
- [x] App installable (PWA)
- [x] Suivi de mesures corporelles (taille, bras, hanches)
- [x] Passer un exercice (par semaine) + ajouter un exercice personnalisé
- [x] Barre de navigation fixe en bas, swipe entre jours, retour tactile sur les actions clés
- [x] Page d'accueil (reprendre le programme, abdos express avec variante périnée-safe, cardio express) + agenda calendrier
