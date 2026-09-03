# Contexte projet — PosiTraining

App web de suivi d'entraînement (prise de masse) pour un utilisateur unique. Tout tient dans `index.html`.

## Stack & contraintes
- **Un seul fichier** : `index.html` (HTML + CSS + JS vanilla, aucune dépendance, aucun build).
- **Mobile-first**, thème sombre « athlétique », police Oswald pour les chiffres. UI **en français**.
- Pas de framework. Garder ce format autonome sauf décision explicite de migrer.

## Données & persistance (important)
- État global unique dans l'objet JS `state` : `{week, day, view, weights[], swaps{}, done{}, logs{}, updatedAt, ...}`.
- Persistance en cascade dans `writeNow/readVal/delVal` : `window.storage` (runtime artefact Claude) → sinon `localStorage` → sinon mémoire. Sauvegarde debouncée + `flush()` sur `pagehide`/`visibilitychange`.
- Clé de stockage : `positraining_v1`. **Ne pas changer le format sans migration** (sinon perte des données utilisateur).
- Export/Import JSON déjà en place dans les Réglages (⚙︎) → c'est aussi le format de sauvegarde.
- Les logs sont indexés par `exId__wSEMAINE` ; un exercice remplacé (swap) prend un id suffixé (`exId~slug`) pour garder un historique distinct.
- `state.updatedAt` (timestamp ms) est mis à jour à chaque `flush()` ; sert de base à la fusion last-write-wins avec le cloud (voir ci-dessous).

## Synchro cloud (Supabase) — en place
- Client `@supabase/supabase-js` chargé via CDN (`<script src="...supabase-js@2.45.4/dist/umd/supabase.js">`), pas de build.
- Constantes `SUPABASE_URL` / `SUPABASE_ANON_KEY` en dur dans `index.html` (clé publishable, publique par design).
- Table `state` (une ligne par utilisateur, `user_id` = `auth.users.id`, colonnes `data jsonb`, `updated_at timestamptz`) + RLS (chacun ne lit/écrit que sa ligne). Schéma dans `supabase-schema.sql`.
- Auth par magic link (`signInWithOtp`, pas de mot de passe). UI dans le panneau Réglages (bloc « Compte cloud »).
- `flush()` déclenche un push cloud débouncé (1,2 s) si connecté. À la connexion (ou au chargement si déjà connecté), `cloudPull()` compare `state.updatedAt` local à `updated_at` distant et prend le plus récent (fusion **last-write-wins sur l'état entier**, pas de merge champ à champ).
- Export/Import reste le filet de secours hors ligne, inchangé.
- Toute nouvelle donnée persistée doit rester couverte par `STATE_DEFAULTS` (utilisé par reset/import/pull cloud), en plus des défauts de `state`, gardes d'init et Export/Import (voir Conventions).

## Ce qui existe déjà
Programme 5-6 jours + séance légère du soir ; suivi charges + progression (sparklines) ; minuteur de repos ; fiches technique (`HOWTO`) + alternatives (`ALT`) + sélecteur de swap ; onglet Poids (courbe + objectif 92 kg + verdict de rythme) ; bouton « Terminer la séance » ; onglet Nutrition (cibles, timing, repas) ; Export/Import ; hébergement GitHub Pages ; synchro cloud Supabase (magic link + last-write-wins).

## Roadmap (par priorité)
1. ~~Héberger l'app (GitHub Pages)~~ — fait : `https://balenrion.github.io/Positraining/`.
2. ~~Synchro cloud multi-appareils via Supabase~~ — fait (voir section dédiée ci-dessus).
3. Comptes / login multi-appareils : actuellement magic link par email uniquement ; envisager mot de passe en option si besoin d'un flux plus rapide sur appareils de confiance.

## Conventions
- Rester en français côté UI.
- Toute nouvelle donnée persistée : l'ajouter aux valeurs par défaut de `state`, aux gardes d'init, au reset, ET la couvrir par Export/Import.
- Vérifier la syntaxe JS avant de livrer (`node --check` sur le script extrait).
