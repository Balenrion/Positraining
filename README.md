# PosiTraining

Carnet d'entraînement pour la prise de masse : programme, suivi de progression, suivi du poids et nutrition. Une seule page web, sans installation ni build.

## Utiliser l'app
1. Ouvre `index.html` dans un navigateur (ordinateur ou téléphone).
2. Sur mobile : menu du navigateur → **Ajouter à l'écran d'accueil**. Tu obtiens une icône et l'app s'ouvre en plein écran.

## Où sont mes données ?
Les données (charges, poids, séances validées, exercices remplacés) sont enregistrées **dans le navigateur** de l'appareil (localStorage). Elles ne quittent pas l'appareil.

- **Sauvegarde / transfert** : Réglages (⚙︎) → **Exporter mes données** télécharge un fichier `.json`. Sur un autre appareil ou un nouveau compte : Réglages → **Importer une sauvegarde**.
- ⚠️ Fais un export **avant de changer d'appareil ou de compte** — sinon les données restent sur l'ancien.

## Mettre l'app en ligne (multiplateforme)
Héberger le fichier permet d'y accéder depuis n'importe quel appareil via une URL.

### Option A — GitHub Pages (gratuit)
```bash
git init
git add .
git commit -m "PosiTraining v1"
git branch -M main
git remote add origin https://github.com/<ton-user>/positraining.git
git push -u origin main
```
Puis sur GitHub : **Settings → Pages → Branch : main / (root) → Save**.
L'app sera en ligne sur `https://<ton-user>.github.io/positraining/`.

### Option B — Netlify / Cloudflare Pages / Vercel
Glisse-dépose le dossier (ou connecte le repo GitHub). URL générée automatiquement, HTTPS inclus.

> L'hébergement rend l'app **accessible** partout. Les **données** restent locales à chaque navigateur tant que la synchro cloud n'est pas branchée — en attendant, utilise Export / Import.

## Synchro cloud multi-appareils (prochaine étape)
Pour que les données suivent automatiquement d'un appareil à l'autre, il faut un petit backend. Le plus simple : **Supabase** (offre gratuite).
1. Crée un projet sur supabase.com.
2. Récupère le `Project URL` et la clé `anon`.
3. On ajoute le client Supabase, une table `state`, et un login (email + mot de passe, ou lien magique). À chaque modif, l'app pousse l'état ; à l'ouverture, elle le récupère.

La clé `anon` est publique par design ; les données sont protégées par les règles RLS + ton compte. Fournis ces deux infos et la synchro peut être câblée.

## Structure du projet
- `index.html` — toute l'app (HTML + CSS + JavaScript, zéro dépendance externe).

## Feuille de route
- [x] Programme 5-6 jours + séance légère du soir
- [x] Suivi des charges + progression, minuteur de repos
- [x] Fiches technique + alternatives + sélecteur d'exercice
- [x] Suivi du poids avec objectif et rythme
- [x] Bouton « Terminer la séance »
- [x] Onglet nutrition (menus + timing)
- [x] Export / Import des données
- [ ] Synchro cloud (Supabase)
- [ ] Comptes / login multi-appareils
