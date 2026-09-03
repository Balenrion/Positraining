# Contexte projet — PosiTraining

App web de suivi d'entraînement (prise de masse) pour un utilisateur unique. Tout tient dans `index.html`.

## Stack & contraintes
- **Un seul fichier** : `index.html` (HTML + CSS + JS vanilla, aucune dépendance, aucun build).
- **Mobile-first**, thème sombre « athlétique », police Oswald pour les chiffres. UI **en français**.
- Pas de framework. Garder ce format autonome sauf décision explicite de migrer.

## Données & persistance (important)
- État global unique dans l'objet JS `state` : `{week, day, view, weights[], swaps{}, done{}, logs{}, ...}`.
- Persistance en cascade dans `writeNow/readVal/delVal` : `window.storage` (runtime artefact Claude) → sinon `localStorage` → sinon mémoire. Sauvegarde debouncée + `flush()` sur `pagehide`/`visibilitychange`.
- Clé de stockage : `positraining_v1`. **Ne pas changer le format sans migration** (sinon perte des données utilisateur).
- Export/Import JSON déjà en place dans les Réglages (⚙︎) → c'est aussi le format de sauvegarde.
- Les logs sont indexés par `exId__wSEMAINE` ; un exercice remplacé (swap) prend un id suffixé (`exId~slug`) pour garder un historique distinct.

## Ce qui existe déjà
Programme 5-6 jours + séance légère du soir ; suivi charges + progression (sparklines) ; minuteur de repos ; fiches technique (`HOWTO`) + alternatives (`ALT`) + sélecteur de swap ; onglet Poids (courbe + objectif 92 kg + verdict de rythme) ; bouton « Terminer la séance » ; onglet Nutrition (cibles, timing, repas) ; Export/Import.

## Roadmap (par priorité)
1. **Héberger** l'app (GitHub Pages / Netlify / Cloudflare Pages) pour un accès multiplateforme via URL.
2. **Synchro cloud multi-appareils** via **Supabase** (offre gratuite) :
   - client Supabase (via CDN pour rester sans build, ou petit bundle),
   - table `state` (une ligne par utilisateur), RLS activé,
   - auth simple (email/mot de passe ou magic link),
   - push de `state` à chaque `flush()`, pull à l'ouverture, fusion last-write-wins.
   - Garder Export/Import comme filet de secours hors ligne.
3. Comptes / login multi-appareils propres.

## Conventions
- Rester en français côté UI.
- Toute nouvelle donnée persistée : l'ajouter aux valeurs par défaut de `state`, aux gardes d'init, au reset, ET la couvrir par Export/Import.
- Vérifier la syntaxe JS avant de livrer (`node --check` sur le script extrait).
