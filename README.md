# PosiTraining

Carnet d'entraînement multi-profils : programme (généré selon tes objectifs), suivi de progression, suivi du poids et nutrition. Une seule page web, sans installation ni build.

## Utiliser l'app
1. Ouvre `index.html` dans un navigateur (ordinateur ou téléphone), ou l'URL en ligne (voir plus bas).
2. Sur mobile : menu du navigateur → **Ajouter à l'écran d'accueil**. Tu obtiens une icône et l'app s'ouvre en plein écran.

## Plusieurs personnes, une seule app
Réglages (⚙︎) → **Qui s'entraîne ?** : chaque personne a son profil, son programme et ses données, complètement séparés.

- **+ Nouveau profil** ouvre un questionnaire (prénom, âge, poids, taille, objectif, jours d'entraînement par semaine, niveau, limites/blessures éventuelles). L'app génère un programme adapté, que tu peux ajuster (changer un exercice, l'objectif de poids, les cibles nutrition) avant de valider.
- Les chips affichent les profils existants — touche-en un pour basculer dessus. Aucune connexion n'est nécessaire pour changer de profil.
- **Supprimer ce profil** efface définitivement un profil et ses données (disponible dès qu'il y en a plusieurs).
- Chaque profil peut, indépendamment, se connecter à son propre compte cloud (voir plus bas) pour synchroniser ses données entre ses propres appareils.

## Où sont mes données ?
Les données (charges, poids, séances validées, exercices remplacés) sont enregistrées **dans le navigateur** de l'appareil (localStorage), et synchronisées automatiquement dans le cloud si tu es connecté (voir ci-dessous).

- **Sauvegarde / transfert manuel** : Réglages (⚙︎) → **Exporter mes données** télécharge un fichier `.json`. Sur un autre appareil ou un nouveau compte : Réglages → **Importer une sauvegarde**. Reste le filet de secours hors ligne, même avec la synchro cloud activée.
- ⚠️ Sans compte connecté, fais un export **avant de changer d'appareil** — sinon les données restent sur l'ancien.

## L'app en ligne
Hébergée gratuitement sur GitHub Pages : **https://balenrion.github.io/Positraining/**

## Synchro cloud multi-appareils (Supabase)
Connecte-toi via Réglages (⚙︎) → **Compte cloud** avec ton email — tu reçois un lien de connexion (pas de mot de passe). Une fois connecté sur plusieurs appareils avec le même email, les données **de ce profil** se synchronisent automatiquement (dernière modification gagne). Chaque profil a sa propre connexion : toi et ta femme pouvez chacun vous connecter avec votre email, sans interférer avec les données de l'autre.

Mise en place côté projet Supabase (déjà fait pour cette instance, à refaire si tu changes de projet) :
1. Crée un projet sur [supabase.com](https://supabase.com).
2. Exécute `supabase-schema.sql` dans le SQL Editor (crée la table `state` + les règles RLS).
3. Dans **Authentication → URL Configuration**, mets l'URL de l'app (Site URL + Redirect URLs) : `https://balenrion.github.io/Positraining/`.
4. Renseigne `SUPABASE_URL` et `SUPABASE_ANON_KEY` (clé *publishable*, publique par design) en haut du bloc « Synchro cloud » dans `index.html`.

## Structure du projet
- `index.html` — toute l'app (HTML + CSS + JavaScript, zéro dépendance externe côté build ; charge le client Supabase via CDN pour la synchro).
- `supabase-schema.sql` — schéma SQL de la table `state` + RLS, à exécuter une fois dans le projet Supabase.

## Feuille de route
- [x] Programme 5-6 jours + séance légère du soir
- [x] Suivi des charges + progression, minuteur de repos
- [x] Fiches technique + alternatives + sélecteur d'exercice
- [x] Suivi du poids avec objectif et rythme
- [x] Bouton « Terminer la séance »
- [x] Onglet nutrition (menus + timing)
- [x] Export / Import des données
- [x] Hébergement (GitHub Pages)
- [x] Synchro cloud (Supabase, magic link)
- [x] Profils multi-utilisateurs (sélecteur local) + générateur de programme par questionnaire
- [ ] Comptes / login plus riches (ex. mot de passe en option)
