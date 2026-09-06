# Contexte projet — PosiTraining

App web de suivi d'entraînement, **multi-profils** (un foyer, plusieurs personnes possibles).
Tout tient dans `index.html`.

## Stack & contraintes
- **Un seul fichier** : `index.html` (HTML + CSS + JS vanilla, aucune dépendance, aucun build).
- **Mobile-first**, thème sombre « athlétique », police Oswald pour les chiffres. UI **en français**.
- Pas de framework. Garder ce format autonome sauf décision explicite de migrer.
- **Usage 100 % mobile** (confirmé par l'utilisateur) : sur tout nouvel élément (ligne de champs côte à côte, sheet, chips), vérifier qu'il tient sur un écran étroit (~375px de large, soit ~310px une fois les paddings `.wrap`/`.card` déduits). Piège classique : des `<input>` en enfants directs d'un `display:flex` peuvent refuser de rétrécir sous leur largeur intrinsèque et déborder — toujours les envelopper dans un `<div style="flex:1;min-width:0">` (voir `#addex`, ou `revKcal`/`revProt` dans la review) plutôt que de mettre `flex`/`width:100%` sur l'input directement.

## Modèle de données : profils
- Un **profil** = une personne = `{onboarding, program, state}` :
  - `onboarding` : réponses du questionnaire (`prenom,sexe,age,poids,taille,objectif,joursParSemaine,niveau,limites`), ou `null` pour un profil migré depuis l'ancienne version mono-utilisateur.
  - `program` : `{days, goal, nutrition}` — le programme généré (ou celui de Laurent, `PROGRAM_DEFAULT`, pour la migration).
  - `state` : `{week, day, view, weights[], swaps{}, done{}, logs{}, skips{}, updatedAt, timeCap, ...}` — les données d'entraînement. `skips` (même clé que `logs`, par semaine) marque un exercice passé — voir plus bas. `timeCap` (0 = illimité, sinon 30/45/60/75/90 minutes) est une préférence d'affichage, pas une donnée d'entraînement : préservée par le reset (« Effacer mes données »), contrairement à `weights/logs/swaps/done/skips`.
- `DAYS`, `GOAL`, `NUTRI` sont des `let` au niveau module, réaffectés depuis `program` à chaque chargement/changement de profil (voir `applyBundle`). Toutes les fonctions de rendu (`renderDays`, `renderDay`, `renderNutri`, `weightChart`…) lisent ces variables sans savoir qu'elles changent de profil — **ne pas** les repasser en `const`.
- `DAYS_ORIGINAL` (le programme historique de Laurent, 5-6 jours) reste une constante à part : c'est à la fois le template « 5/6 jours » du générateur et le pool d'exercices (`EXO_POOL`/`EXO_GROUP`) utilisé pour construire les templates full-body (3j) et haut/bas (4j). Ne jamais muter ses objets en place (toujours cloner avant modif — voir `template56`, `buildDay`).

## Stockage (persistant, avec repli mémoire)
- `writeNow/readVal/delVal` : `window.storage` (runtime artefact Claude) → sinon `localStorage` → sinon mémoire.
- Clés : `positraining_v1_profiles` (index `[{id,name,createdAt}]`), `positraining_v1_active` (id du profil actif), `positraining_v1_p_<id>` (bundle complet d'un profil). `OLD_KEY='positraining_v1'` n'est lu qu'une fois, pour la migration (voir Init).
- Sauvegarde debouncée + `flush()` sur `pagehide`/`visibilitychange` → persiste le bundle du profil actif (`persistActiveBundle`).
- Export/Import portent sur le bundle complet du profil actif (`onboarding`+`program`+`state`) ; l'ancien format (state seul) reste importable en compat.
- Les logs sont indexés par `exId__wSEMAINE` ; un exercice remplacé (swap) prend un id suffixé (`exId~slug`) pour garder un historique distinct — dans l'écran de review d'un nouveau profil (avant toute donnée), le swap remplace directement l'exercice (`openSwapDraft`) plutôt que de passer par `state.swaps`.
- `state.updatedAt` (timestamp ms) mis à jour à chaque `flush()`.
- **Migration automatique** (Init) : si aucun profil n'existe mais que `positraining_v1` (ancien format) existe, un profil « Laurent » est créé à partir de ces données + `PROGRAM_DEFAULT`, sans perte de charges/poids/logs.

## Générateur de programme
- `generateProgram(onboarding)` (pur, pas d'effet de bord) : choisit un template selon `joursParSemaine` (≤3 → full-body ×3, 4 → haut/bas ×4, 5-6 → `template56`, la structure historique de Laurent), applique `genderBias` puis `applyMuscleFocus` puis `applyObjectif` (voir plus bas) puis `applyNiveau` (séries/reps/repos selon `niveau`), calcule nutrition et objectif de poids.
- **`applyMuscleFocus(days,weakGroups,strongGroups)`** — points faibles/forts choisis dans le questionnaire (chips `MUSCLE_GROUPS`, mutuellement exclusifs côté UI : un groupe ne peut pas être à la fois faible et fort) :
  - Groupe faible → ajoute un exercice supplémentaire de ce groupe sur chaque jour qui travaille déjà ce pattern (même logique que `genderBias`, `idx:2` pour différer du choix de `genderBias`).
  - Groupe fort → retire un exercice de ce groupe par jour, **sauf si ça ferait tomber la durée estimée du jour sous le plancher de 30 min** (même `dayDuration`/plancher que `trimDayToTime` — un jour haut/bas de seulement 4 exercices ne doit pas se retrouver avec 3 exercices très courts). Testé sur 3840 combinaisons jours×groupe×objectif : aucune violation du plancher, aucun jour vidé, aucun id dupliqué.
- **Nutrition** : formule de Mifflin-St Jeor (BMR selon `poids/taille/age/sexe`) × multiplicateur d'activité dérivé de `joursParSemaine` (1.4 à 1.7) = TDEE, puis ajustement additif selon `objectif` (+350 kcal prise de masse, −500 perte de poids, 0 sinon). Protéines/lipides toujours en g/kg de poids de corps, glucides en reste calorique. `sexe` vaut `'H'`/`'F'`/`'A'` (autre/non précisé, offset moyen) — champ requis dans le questionnaire, c'est la seule vraie utilité biologique du sexe ici.
- **`applyObjectif(days,objectif)` — la séance elle-même s'adapte à l'objectif, pas seulement la nutrition** :
  - `masse` : aucun changement de repos (préserve récup et surplus calorique) ; cardio minimal (un seul rappel léger ~8 min sur les templates full-body/haut-bas, rien d'ajouté sur `template56` au-delà du `ds` existant).
  - `perte` : repos réduit ×0.65 (plancher 30 s, style circuit/métabolique) ; cardio ~15 min ajouté sur **chaque** jour, y compris `template56`.
  - `recomp` : repos ×0.85 ; cardio ~10 min sur chaque jour.
  - `maintien` : repos inchangé ; cardio ~8 min sur chaque jour.
  - Les reps ne sont volontairement pas réécrites (formats hétérogènes dans `DAYS_ORIGINAL` — `"12 /côté"`, `"circuit"`, etc. — trop risqué à parser) ; le repos et le volume cardio sont les leviers utilisés pour différencier l'objectif.
- **Exercices (sexe)** : `genderBias(days,sexe)` ajoute, pour `sexe==='F'`, un exercice fessiers supplémentaire sur chaque jour qui travaille déjà le bas du corps (quad/hinge) — un choix de programmation courant, pas une règle rigide ; reste modifiable via le swap. S'applique à tous les templates générés ; le profil migré de Laurent (`PROGRAM_DEFAULT`, jamais passé par `generateProgram`) n'est jamais concerné.
- Les templates full-body/haut-bas piochent des exercices dans `EXO_POOL` via `EXO_GROUP` (nom → groupe musculaire) : mêmes noms d'exercices que `DAYS_ORIGINAL`, donc `HOWTO`/`ALT` restent valides pour tout programme généré.
- `cardioNote(minutes)` (note non swappable, durée stockée dans `mins` — utilisée par `exDuration` pour le temps disponible) : voir `applyObjectif` pour qui en reçoit combien.
- Flux UI : sheet `#onboard` (questionnaire) → `generateProgram` → sheet `#review` (édition : swap d'exercice via `openSwapDraft`, objectif de poids, nutrition, rappel du nombre de jours de repos, changements liés aux limites) → validation → nouveau profil créé et activé.
- **Limites (genou, épaule, bas du dos, coude, poignet, cheville)** : chips structurées (`LIMITE_INFO`), traitées par `applyLimites` — voir plus bas. Le textarea `#obLimites` reste pour des précisions libres, mais n'est **que** affiché en rappel (pas structuré, pas fiable à automatiser).
- **`applyLimites(days,limiteZones)`** : pour chaque zone cochée, exclut les exercices à risque du pool réel (`LIMITE_INFO[].exclude`). Une seule substitution jugée réellement plus sûre existe (bas du dos : RDL/hip thrust lourd → `Leg curl`, qui isole les ischios sans charger le dos) ; les autres zones retirent l'exercice plutôt que de proposer une fausse alternative (dans le pool actuel, les alternatives à un squat restent des squats — pas un vrai gain de sécurité). Même garde-fou de plancher que `applyMuscleFocus` (jamais sous 30 min de `dayDuration`). Appliqué après `applyMuscleFocus` pour avoir le dernier mot sur les groupes/limites. Retourne un journal `[{label,from,to}]` (to=null si simple retrait) affiché tel quel dans la review — pas de diff heuristique, la fonction sait exactement ce qu'elle a changé.

## Progression, échauffement, minuteur auto
- `suggestWeight(e,lt)` : si la dernière perf (`lt`, déjà utilisé partout via `lastTime`) a atteint ou dépassé la borne haute de `e.reps` (`repsRange`, regex tolérante aux formats non numériques type `"circuit"` → pas de suggestion), suggère `+2,5 kg`. Affiché en plus de la ligne « Dernière fois » existante, jamais à sa place.
- `warmupSets(e,lt)` : deux paliers (50 %/75 % du poids de référence — dernière perf sinon `e.start`, **attention** : `e.start` contient parfois un `~` ou une fourchette type `"~38-40 kg"`, extraction par regex numérique, pas `parseFloat` direct qui casserait sur le `~`) affichés juste avant la grille de séries. Rien de persisté (pas dans `state.logs`), ni pour les exercices core/note.
- Le bouton "done" d'une série démarre automatiquement le minuteur de repos (`startTimer(e.rest,nm)`) si `e.rest>0` — pas de réglage on/off séparé, le bouton "Stop" du minuteur suffit.

## Passer un exercice / en ajouter un (retour utilisateur : machine indispo, muscle douloureux)
- **Passer** : `state.skips[exId__wSEMAINE]` (même format de clé que `logs`, via `logKey`) — persisté **par semaine**, pas définitif : la semaine suivante l'exercice revient normalement. `sessionProgress` exclut les exercices passés du total (comme les notes), donc « Terminer la séance » n'est pas bloqué par un exercice qu'on ne peut pas faire. Carte réduite (style `.ex.note` réutilisé) avec un bouton « ↩ Reprendre » tant qu'il est passé.
- **Ajouter un exercice** : sheet `#addex` (nom, séries, reps, repos) → poussé dans `DAYS[dayIdx].ex` (donc dans `program.days`, **persisté** via `persistActiveBundle()` — structurel, pas une donnée de séance) avec `custom:true` et un id `<dayId>_c<uid()>`. Un bouton « ✕ Retirer » n'apparaît que sur les exercices `custom` (ceux du programme de base n'ont pas de bouton de suppression — swap ou passer restent les bons outils pour eux).
- **`freshProgramDefault()`** — même piège que `freshState()`/`STATE_DEFAULTS` (voir plus bas) : `program.days` ne doit **jamais** pointer directement vers `DAYS_ORIGINAL` (référence partagée) dès qu'on permet de muter les jours (ajout/suppression d'exercice). Remplace l'ancien `PROGRAM_DEFAULT` (objet unique) par une fabrique qui clone `DAYS_ORIGINAL` à chaque appel.

## Temps disponible (durée de séance)
- `state.timeCap` (0/30/45/60/75/90 min) est réglable en haut de la séance du jour (`renderDay`), via des chips réutilisant le style `.day`.
- `trimDayToTime(exList, capMinutes)` masque les derniers exercices de la liste (jamais les premiers : les mouvements de base restent) tant que la durée estimée dépasse le cap, **sans jamais repasser sous un plancher strict de 30 minutes** — un cap trop serré est ignoré plutôt que de couper davantage. La séance réelle (`day.ex`) n'est jamais modifiée : seul l'affichage (et `sessionProgress`, donc le bouton « Terminer la séance ») porte sur la liste visible tronquée. Changer/agrandir le temps dispo fait immédiatement réapparaître les exercices masqués, logs déjà saisis compris.
- `exDuration(e)` estime la durée par exercice (`sets × (45 s + repos)` ; notes ~3 min, cardio = `e.mins` minutes, 8 min par défaut) — une heuristique volontairement simple, pas un chronométrage réel.
- `timeCap` est une préférence d'affichage : incluse dans `freshState()`, mais **préservée** (pas remise à 0) par le bouton reset, comme `show6`/`view`.

## Mesures corporelles
- `state.measures = {waist:[], arm:[], hip:[]}` (même forme que `state.weights` : `{date,cm}`). UI dans l'onglet Poids (`renderWeight`/`measureBlockHtml`), sous le graphique de poids — dernière valeur + delta + 5 dernières entrées par mesure, pas de graphique dédié (reste léger).
- Le reset (« Effacer mes données ») efface aussi les mesures, comme poids/logs/swaps/done.

## `freshState()` — piège des objets par défaut partagés
- **Bug corrigé** : `state` par défaut était un objet **const unique** (`STATE_DEFAULTS`) réutilisé partout via `Object.assign({},STATE_DEFAULTS,...)`. Comme `Object.assign` ne copie les tableaux/objets imbriqués (`weights`, `logs`, `swaps`, `done`) que **par référence**, tout état qui n'écrasait pas explicitement un de ces champs gardait la référence partagée — une `.push()` ou une mutation en place (`state.logs[k]=...`) polluait alors `STATE_DEFAULTS` pour de bon, pour le reste de la session (reset, nouveau profil, migration compris).
- Corrigé en remplaçant `STATE_DEFAULTS` (objet) par `freshState()` (fonction qui retourne un objet neuf à chaque appel, tableaux/objets imbriqués inclus). **Toujours utiliser `freshState()`, jamais un objet littéral partagé, pour tout nouvel état par défaut.** Vérifié : deux appels à `freshState()` puis mutation de l'un ne touchent pas l'autre.
- Même correctif appliqué à `program` : `PROGRAM_DEFAULT` (objet, `days:DAYS_ORIGINAL` en référence directe) → `freshProgramDefault()` (clone `DAYS_ORIGINAL` à chaque appel). Devenu nécessaire dès que `program.days` peut être muté (ajout/suppression d'exercice, voir plus haut) — sans ça, une mutation aurait pollué la constante `DAYS_ORIGINAL` partagée par tout le monde (pool d'exercices, migration) pour le reste de la session.

## PWA installable (sans service worker)
- Icône (SVG inline) + manifest générés **en JS** (IIFE tout en haut du script, avant `/* Programme */`) via `encodeURIComponent`/`JSON.stringify`, jamais par concaténation manuelle de data-URI imbriquées (fragile à la main : un `%` mal encodé casse silencieusement le manifest ou l'icône). Posés sur des `<link>` placeholders (`#appIcon`,`#appTouchIcon`,`#appManifest`) dans le `<head>`.
- Volontairement pas de service worker (décision utilisateur) : garde le format à fichier unique. L'app tourne entièrement hors-ligne via `localStorage` une fois chargée — aucun appel réseau dans l'app.
- Pas testable dans cet environnement (pas de vrai navigateur) — l'installation réelle (icône, écran de démarrage) est à vérifier sur un téléphone.

## Ce qui existe déjà
Profils multi-utilisateurs avec sélecteur local (sans login) ; générateur de programme par questionnaire (full-body/haut-bas/5-6 jours, sexe, objectif, niveau, points faibles/forts, limites/douleurs) ; programme historique 5-6 jours + séance légère du soir ; suivi charges + progression (sparklines) + suggestion de charge + échauffement ; minuteur de repos (auto au pointage d'une série) ; fiches technique (`HOWTO`) + alternatives (`ALT`) + sélecteur de swap ; onglet Poids (courbe + objectif + verdict de rythme + mesures corporelles) ; réglage de temps disponible par séance ; bouton « Terminer la séance » ; onglet Nutrition (cibles calculées par profil) ; Export/Import ; hébergement GitHub Pages ; PWA installable.

## Roadmap (par priorité)
1. ~~Héberger l'app (GitHub Pages)~~ — fait : `https://balenrion.github.io/Positraining/`.
2. ~~Profils multi-utilisateurs + générateur de programme~~ — fait.
3. ~~Progression auto, échauffement, minuteur auto, limites structurées, PWA, mesures~~ — fait (voir sections dédiées ci-dessus).
4. ~~Synchro cloud multi-appareils via Supabase~~ — implémentée puis **retirée** : le login (magic link, puis code à 6 chiffres en solution de repli) s'est heurté à deux limitations iOS irréductibles (lien qui ouvre toujours Safari plutôt que la PWA installée ; puis config SMTP externe obligatoire côté Supabase pour faire apparaître le code dans l'email) jugées trop contraignantes par l'utilisateur pour un usage mono-appareil. Tout le code associé (client Supabase, table `state`, sheet « Compte cloud ») a été supprimé ; `supabase-schema.sql` n'est plus référencé. Export/Import reste le seul mécanisme de sauvegarde/transfert. À reconsidérer seulement si un vrai besoin multi-appareils réapparaît.

## Conventions
- Rester en français côté UI.
- Toute nouvelle donnée persistée : l'ajouter à `freshState()` (jamais un objet littéral partagé — voir plus haut) pour `state`, à la structure de `program` sinon, aux gardes d'init/migration, au reset, ET la couvrir par Export/Import.
- Ne jamais muter `DAYS_ORIGINAL`/`EXO_POOL` en place — toujours cloner avant modification (le générateur et les profils en dépendent).
- Vérifier la syntaxe JS avant de livrer (`node --check` sur le script extrait).
