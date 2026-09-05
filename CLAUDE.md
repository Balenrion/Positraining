# Contexte projet — PosiTraining

App web de suivi d'entraînement, **multi-profils** (un foyer, plusieurs personnes possibles).
Tout tient dans `index.html`.

## Stack & contraintes
- **Un seul fichier** : `index.html` (HTML + CSS + JS vanilla, aucune dépendance, aucun build).
- **Mobile-first**, thème sombre « athlétique », police Oswald pour les chiffres. UI **en français**.
- Pas de framework. Garder ce format autonome sauf décision explicite de migrer.

## Modèle de données : profils
- Un **profil** = une personne = `{onboarding, program, state}` :
  - `onboarding` : réponses du questionnaire (`prenom,sexe,age,poids,taille,objectif,joursParSemaine,niveau,limites`), ou `null` pour un profil migré depuis l'ancienne version mono-utilisateur.
  - `program` : `{days, goal, nutrition}` — le programme généré (ou celui de Laurent, `PROGRAM_DEFAULT`, pour la migration).
  - `state` : `{week, day, view, weights[], swaps{}, done{}, logs{}, updatedAt, timeCap, ...}` — les données d'entraînement. `timeCap` (0 = illimité, sinon 30/45/60/75/90 minutes) est une préférence d'affichage, pas une donnée d'entraînement : préservée par le reset (« Effacer mes données »), contrairement à `weights/logs/swaps/done`.
- `DAYS`, `GOAL`, `NUTRI` sont des `let` au niveau module, réaffectés depuis `program` à chaque chargement/changement de profil (voir `applyBundle`). Toutes les fonctions de rendu (`renderDays`, `renderDay`, `renderNutri`, `weightChart`…) lisent ces variables sans savoir qu'elles changent de profil — **ne pas** les repasser en `const`.
- `DAYS_ORIGINAL` (le programme historique de Laurent, 5-6 jours) reste une constante à part : c'est à la fois le template « 5/6 jours » du générateur et le pool d'exercices (`EXO_POOL`/`EXO_GROUP`) utilisé pour construire les templates full-body (3j) et haut/bas (4j). Ne jamais muter ses objets en place (toujours cloner avant modif — voir `template56`, `buildDay`).

## Stockage (persistant, avec repli mémoire)
- `writeNow/readVal/delVal` : `window.storage` (runtime artefact Claude) → sinon `localStorage` → sinon mémoire.
- Clés : `positraining_v1_profiles` (index `[{id,name,createdAt}]`), `positraining_v1_active` (id du profil actif), `positraining_v1_p_<id>` (bundle complet d'un profil). `OLD_KEY='positraining_v1'` n'est lu qu'une fois, pour la migration (voir Init).
- Sauvegarde debouncée + `flush()` sur `pagehide`/`visibilitychange` → persiste le bundle du profil actif (`persistActiveBundle`) et pousse au cloud (`cloudPush`).
- Export/Import portent sur le bundle complet du profil actif (`onboarding`+`program`+`state`) ; l'ancien format (state seul) reste importable en compat.
- Les logs sont indexés par `exId__wSEMAINE` ; un exercice remplacé (swap) prend un id suffixé (`exId~slug`) pour garder un historique distinct — dans l'écran de review d'un nouveau profil (avant toute donnée), le swap remplace directement l'exercice (`openSwapDraft`) plutôt que de passer par `state.swaps`.
- `state.updatedAt` (timestamp ms) mis à jour à chaque `flush()` ; sert de base à la fusion last-write-wins avec le cloud.
- **Migration automatique** (Init) : si aucun profil n'existe mais que `positraining_v1` (ancien format) existe, un profil « Laurent » est créé à partir de ces données + `PROGRAM_DEFAULT`, sans perte de charges/poids/logs.

## Générateur de programme
- `generateProgram(onboarding)` (pur, pas d'effet de bord) : choisit un template selon `joursParSemaine` (≤3 → full-body ×3, 4 → haut/bas ×4, 5-6 → `template56`, la structure historique de Laurent), applique `genderBias` (voir plus bas), ajuste séries/reps/repos selon `niveau` (`applyNiveau`), calcule nutrition et objectif de poids.
- **Nutrition** : formule de Mifflin-St Jeor (BMR selon `poids/taille/age/sexe`) × multiplicateur d'activité dérivé de `joursParSemaine` (1.4 à 1.7) = TDEE, puis ajustement additif selon `objectif` (+350 kcal prise de masse, −500 perte de poids, 0 sinon). Protéines/lipides toujours en g/kg de poids de corps, glucides en reste calorique. `sexe` vaut `'H'`/`'F'`/`'A'` (autre/non précisé, offset moyen) — champ requis dans le questionnaire, c'est la seule vraie utilité biologique du sexe ici.
- **Exercices** : `genderBias(days,sexe)` ajoute, pour `sexe==='F'`, un exercice fessiers supplémentaire sur chaque jour qui travaille déjà le bas du corps (quad/hinge) — un choix de programmation courant, pas une règle rigide ; reste modifiable via le swap. S'applique à tous les templates générés (y compris `template56`) ; le profil migré de Laurent (`PROGRAM_DEFAULT`, jamais passé par `generateProgram`) n'est jamais concerné.
- Les templates full-body/haut-bas piochent des exercices dans `EXO_POOL` via `EXO_GROUP` (nom → groupe musculaire) : mêmes noms d'exercices que `DAYS_ORIGINAL`, donc `HOWTO`/`ALT` restent valides pour tout programme généré.
- Un rappel cardio (`cardioNote()`, note non swappable, ~9 min zone 2) est ajouté à chaque jour des templates full-body/haut-bas (`jours<=4`) ; les templates 5-6 jours en ont déjà un via la séance du soir (`ds`).
- Flux UI : sheet `#onboard` (questionnaire) → `generateProgram` → sheet `#review` (édition : swap d'exercice via `openSwapDraft`, objectif, nutrition, rappel du nombre de jours de repos) → validation → nouveau profil créé et activé.
- Les limites/blessures signalées ne sont **pas** parsées automatiquement (texte libre trop peu fiable) : affichées en rappel dans l'écran de review, à gérer via le swap manuel.

## Temps disponible (durée de séance)
- `state.timeCap` (0/30/45/60/75/90 min) est réglable en haut de la séance du jour (`renderDay`), via des chips réutilisant le style `.day`.
- `trimDayToTime(exList, capMinutes)` masque les derniers exercices de la liste (jamais les premiers : les mouvements de base restent) tant que la durée estimée dépasse le cap, **sans jamais repasser sous un plancher strict de 30 minutes** — un cap trop serré est ignoré plutôt que de couper davantage. La séance réelle (`day.ex`) n'est jamais modifiée : seul l'affichage (et `sessionProgress`, donc le bouton « Terminer la séance ») porte sur la liste visible tronquée. Changer/agrandir le temps dispo fait immédiatement réapparaître les exercices masqués, logs déjà saisis compris.
- `exDuration(e)` estime la durée par exercice (`sets × (45 s + repos)` ; notes ~3 min, cardio ~9 min) — une heuristique volontairement simple, pas un chronométrage réel.
- `timeCap` est une préférence d'affichage : incluse dans `STATE_DEFAULTS`, mais **préservée** (pas remise à 0) par le bouton reset, comme `show6`/`view`.

## Synchro cloud (Supabase) — par profil
- Client `@supabase/supabase-js` chargé via CDN (`<script src="...supabase-js@2.45.4/dist/umd/supabase.js">`), pas de build.
- Constantes `SUPABASE_URL` / `SUPABASE_ANON_KEY` en dur dans `index.html` (clé publishable, publique par design).
- Table `state` (une ligne par utilisateur Supabase, `user_id` = `auth.users.id`, colonnes `data jsonb`, `updated_at timestamptz`) + RLS. Schéma dans `supabase-schema.sql` — inchangé, `data` contient désormais le bundle complet (`onboarding`+`program`+`state`) au lieu du seul `state`.
- Auth par magic link (`signInWithOtp`, pas de mot de passe). **Un client Supabase par profil actif** (`reconnectCloud`, `auth.storageKey:'sb-auth-'+profileId`) : chaque profil garde sa propre session de connexion dans le même navigateur, sans se marcher dessus au changement de profil.
- `flush()` déclenche un push cloud débouncé (1,2 s) si connecté. À la connexion (ou au chargement), `cloudPull()` compare `state.updatedAt` local à `updated_at` distant et prend le plus récent (fusion **last-write-wins sur le bundle entier**, pas de merge champ à champ).

## Ce qui existe déjà
Profils multi-utilisateurs avec sélecteur local (sans login) ; générateur de programme par questionnaire (full-body/haut-bas/5-6 jours selon jours par semaine et niveau) ; programme historique 5-6 jours + séance légère du soir ; suivi charges + progression (sparklines) ; minuteur de repos ; fiches technique (`HOWTO`) + alternatives (`ALT`) + sélecteur de swap ; onglet Poids (courbe + objectif + verdict de rythme) ; bouton « Terminer la séance » ; onglet Nutrition (cibles calculées par profil) ; Export/Import ; hébergement GitHub Pages ; synchro cloud Supabase par profil (magic link + last-write-wins).

## Roadmap (par priorité)
1. ~~Héberger l'app (GitHub Pages)~~ — fait : `https://balenrion.github.io/Positraining/`.
2. ~~Synchro cloud multi-appareils via Supabase~~ — fait.
3. ~~Profils multi-utilisateurs + générateur de programme~~ — fait (voir sections dédiées ci-dessus).
4. Comptes / login plus riches : actuellement magic link par email uniquement ; envisager mot de passe en option si besoin d'un flux plus rapide sur appareils de confiance.

## Conventions
- Rester en français côté UI.
- Toute nouvelle donnée persistée : l'ajouter aux valeurs par défaut (`STATE_DEFAULTS` pour `state`, structure de `program` sinon), aux gardes d'init/migration, au reset, ET la couvrir par Export/Import.
- Ne jamais muter `DAYS_ORIGINAL`/`EXO_POOL` en place — toujours cloner avant modification (le générateur et les profils en dépendent).
- Vérifier la syntaxe JS avant de livrer (`node --check` sur le script extrait).
