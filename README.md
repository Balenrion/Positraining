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
  - un **point faible** ajoute du volume dessus, un **point fort** en retire ;
  - le **confort périnée** (sans pression abdominale — post-partum, gêne, désir de grossesse) remplace ou retire automatiquement les exercices d'abdos à risque (crunch, relevé de jambes, rotations chargées), comme pour l'abdos express.
  - Tout reste ajustable (changer un exercice, l'objectif de poids, les cibles nutrition) avant de valider.
- Les chips affichent les profils existants — touche-en un pour basculer dessus. Aucune connexion n'est nécessaire pour changer de profil.
- **Supprimer ce profil** efface définitivement un profil et ses données (disponible dès qu'il y en a plusieurs).
- Les données de chaque profil restent sur l'appareil ; utilise Export/Import (voir ci-dessous) pour les transférer vers un autre appareil.

## Accueil
L'app s'ouvre toujours sur l'Accueil. La barre en bas de l'écran (accessible au pouce) donne accès à **Accueil / Séance / Poids / Nutrition / Agenda**. L'accueil propose 4 raccourcis :
- **Reprendre le programme** → va directement à la séance du jour.
- **Programme focus** → un **second programme complet**, indépendant du programme classique, ciblé sur les groupes musculaires de ton choix (ex. cuisses/abdos/fessiers pour un objectif raffermissement). Au premier tap : choisis un nom, les **groupes musculaires ciblés** (au moins un), le nombre de jours/semaine, le niveau, l'objectif, la **durée de séance visée** (30/45/60 min — le nombre d'exercices s'ajuste automatiquement pour l'atteindre), et les mêmes options que le programme classique (**limites/douleurs**, **confort périnée**). Une fois généré, la séance qui suit est en tout point identique au programme classique (saisie des charges, minuteur, fiche technique, ⇄ Changer, suivi de progression propre à ce programme) — un lien **↩ Revenir au programme classique** en haut de la séance permet de rebasculer, et **⚙ Reconfigurer** permet de refaire la configuration (groupes, durée…) à tout moment — les séries déjà enregistrées pour ce programme sont alors remises à zéro. Les deux programmes cohabitent dans le même profil, avec leur propre historique de charges. Pour s'entraîner à deux avec les mêmes exercices, deux cas : si l'autre personne a son profil **sur le même téléphone**, la config propose de **copier directement** son programme ; si elle est **sur un autre téléphone**, utilise **📤 Partager** (dans la séance focus) pour générer un petit fichier à lui envoyer par le moyen de ton choix (AirDrop, Messages…), qu'elle importe ensuite avec **📥 Importer un programme reçu** dans sa propre configuration. Chacun garde sa propre progression. C'est une copie ponctuelle, pas une synchronisation : si l'un des deux programmes change ensuite, il faut recopier/réimporter.
- **Abdos express** → choisis la durée (10/15/20 min), la **difficulté** (Facile / Modéré / Intense — Modéré par défaut, ajuste le repos entre séries et le nombre de séries) et si tu veux des **exercices adaptés périnée** (sans pression abdominale — pas de crunch ni de relevé de jambes ; utile en post-partum, en cas de gêne ou de désir de grossesse), puis **C'est parti**. Le bouton et l'écran de réglages sont identiques pour tout le monde, seul ce choix (fait à chaque lancement) change les exercices proposés. La séance qui suit est une **vraie séance**, comme dans le programme classique : saisie des reps (poids de corps, pas de champ kg inutile), minuteur de repos automatique, fiche technique, chrono sur les mouvements tenus, vote de ressenti — et la progression se suit d'une fois sur l'autre comme n'importe quel exercice du programme. **⇄ Changer** propose un autre mouvement dans le même esprit (reste dans les exercices adaptés périnée si cette option est activée) et **⏭ Passer** retire l'exercice de la séance du jour, exactement comme dans le programme classique.
- **Cardio** → dis d'abord ton **objectif** (récupération active, raffermir, perdre de la cellulite, améliorer le cardio, fractionné/HIIT, ou libre) : l'app te propose un type de séance et une durée adaptés (modifiables), avec des repères concrets (inclinaison, vitesse, résistance…). Une fois la séance faite, indique le temps réel, et si tu veux, ton ressenti et une note libre (réglages utilisés…) — c'est enregistré et visible dans l'Agenda.

## Agenda
Un calendrier du mois avec un point coloré sur chaque jour où une séance a été faite — **une couleur par type** (vert = programme, orange = abdos express, bleu = cardio ; plusieurs points si plusieurs types le même jour), pour distinguer d'un coup d'œil le parcours classique des séances à part. La liste détaillée en dessous reprend le même code couleur (liseré coloré). Navigue avec les flèches ‹ › pour consulter les mois précédents.

## Pendant la séance
- **Séance / Poids / Nutrition** se change via la barre en bas de l'écran, accessible au pouce sans avoir à remonter.
- **Glisse à gauche/droite** sur la séance pour passer au jour suivant/précédent, sans repasser par les onglets du haut.
- Le **sélecteur de semaine** en haut grise les semaines déjà passées, pour repérer d'un coup d'œil où tu en es (tu peux toujours cliquer dessus pour consulter l'historique).
- Une **suggestion de charge** apparaît quand tu as atteint le haut de la fourchette de reps la fois précédente.
- Sous chaque exercice, indique ton **ressenti** (😌 Facile / 👍 Ok / 😓 Trop dur) — optionnel. La prochaine fois, ça affine la suggestion de charge : "Trop dur" bloque toute augmentation même si les reps étaient bonnes, "Facile" pousse un peu plus fort (+5 kg au lieu de +2,5).
- Un **échauffement** (deux paliers à 50 % et 75 %) est suggéré sur les mouvements principaux.
- **Fiche ▸** ouvre la fiche technique de l'exercice : muscles ciblés, étapes clés, **2 vraies photos** (départ/fin du mouvement) sur la machine concernée, puis un lien vers une démo vidéo — y compris sur les exercices de remplacement proposés par **⇄ Changer**, pas seulement ceux du programme par défaut.
- Saisis le poids et les reps, puis touche le **✓** pour valider la série — le **minuteur de repos démarre à ce moment-là** (maintenant ancré en haut de l'écran, pas en bas). Touche à nouveau pour décocher en cas d'erreur.
- Sur les exercices chronométrés (gainage, planche…), un bouton **⏱ Chrono** lance directement le minuteur de maintien — pas besoin de sortir de l'app pour chronométrer. Le champ de saisie affiche alors **« sec »** plutôt que « reps », pour rester cohérent avec ce que tu mesures réellement.
- Un réglage de **temps disponible** (30 à 90 min) en haut de la séance masque les derniers exercices si besoin, sans jamais descendre sous 30 minutes.
- Pas de machine dispo, ou muscle trop douloureux ? **⏭ Passer** sur la carte de l'exercice — il ne compte plus dans la progression de la séance et revient normalement la semaine suivante.
- **+ Ajouter un exercice** en bas de la séance pour insérer un mouvement de ton choix : **choisis-le dans la liste** (groupée par muscle) plutôt que de taper un nom libre — séries/reps/repos se préremplissent, modifiables ensuite. Sur un exercice au poids de corps (gainage, crunch, relevé de jambes…), le champ kg n'apparaît même pas. Utile si aucune alternative proposée ne convient. Reste dans ton programme (✕ Retirer pour l'enlever).
- **Terminer la séance** déclenche une petite pop-up de félicitations animée (confettis 🎉) — touche le fond ou attends 2 secondes pour la fermer.

## Où sont mes données ?
Les données (charges, poids, séances validées, exercices remplacés) sont enregistrées **dans le navigateur** de l'appareil (localStorage). Il n'y a pas de synchro cloud automatique.

- **Sauvegarde / transfert manuel** : Réglages (⚙︎) → **Exporter mes données** télécharge un fichier `.json`. Sur un autre appareil : Réglages → **Importer une sauvegarde**.
- ⚠️ Fais un export **avant de changer d'appareil ou de réinstaller l'app** — sinon les données restent sur l'ancien.
- L'onglet **Poids** suit aussi le tour de taille, de bras et de hanches (utile pour juger une recomposition au-delà du seul chiffre sur la balance).

## L'app en ligne
Hébergée gratuitement sur GitHub Pages : **https://balenrion.github.io/Positraining/**

## Structure du projet
- `index.html` — toute l'app (HTML + CSS + JavaScript, zéro dépendance externe, aucun appel réseau).
- `img/exercises/` — photos des exercices (2 par mouvement, départ/fin) affichées dans la fiche technique. Source : [free-exercise-db](https://github.com/yuhonas/free-exercise-db), domaine public (Unlicense).

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
- [x] Bouton chrono dédié sur les exercices chronométrés (gainage, planche…)
- [x] Pop-up de félicitations animée à la validation d'une séance
- [x] Vote de ressenti par exercice (facile/ok/trop dur) qui affine la suggestion de charge
- [x] Sélecteur d'exercice (au lieu d'un champ libre) pour garder une base cohérente et analysable
- [x] Abdos express : vraie séance (poids/reps, minuteur, chrono, ressenti) au lieu d'une simple checklist
- [x] Abdos express : niveau de difficulté (repos/séries calibrés sur des recommandations d'entraînement)
- [x] Abdos express : changer/passer un exercice, comme dans le programme classique
- [x] Détection des exercices au poids de corps (pas de champ kg inutile)
- [x] Correction d'un bug où le minuteur de repos pouvait disparaître en plein décompte
- [x] Correction d'un bug où le minuteur de repos pouvait se décrocher pendant le défilement (iOS)
- [x] Vraies photos du mouvement dans la fiche technique de chaque exercice
- [x] Correction d'un bug où faire défiler un panneau (fiche, abdos express…) faisait défiler l'écran derrière
- [x] Le sélecteur de semaine disparaît proprement derrière le minuteur de repos épinglé, au lieu d'une tranche coupée
- [x] Confort périnée disponible dès la création du profil (programme classique), pas seulement en abdos express
- [x] Programme focus : un second programme complet, ciblé sur les groupes musculaires de ton choix, accessible depuis l'Accueil
- [x] Programme focus : durée de séance visée (30/45/60 min) et possibilité de reconfigurer le programme
- [x] Programme focus : possibilité de copier le programme d'un autre profil du foyer pour s'entraîner ensemble
- [x] Programme focus : partage par fichier entre deux téléphones différents (pas seulement même appareil)
