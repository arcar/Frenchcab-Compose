# Frenchcab-Compose

## Contexte 
Vous intégrez une équipe chargée de développer, sur cinq semaines, une application exploitant les données réelles des taxis de New York publiées par la NYC Taxi & Limousine Commission (TLC).

## Structuration du projet
Projet avec **4 repos** `Github`
```
Frenchcab-compose
-> Frenchcab-Backend + Frenchcab-Frontend + Frenchcab-Gateway
```
Le dossier `Frenchcab-compose` contient les autres dossiers du projet (`Frenchcab-Backend`, `Frenchcab-Frontend`, `Frenchcab-Gateway`) il est là pour orchetrer tous le projet.

## Installation 

### 1. Github

Le projet est réparti sur 4 repos de l'organisation `arcar` :

| Repo | Contenu |
|---|---|
| `Frenchcab-Compose` | Orchestration (`compose.yml`, `compose.override.yml`) et scripts |
| `Frenchcab-Backend` | API Python (FastAPI), ETL et modèle ML |
| `Frenchcab-Frontend` | Application Angular |
| `Frenchcab-Gateway` | Gateway Node.js (Express) entre le front et le backend |

Demander l'accès à `arcar` pour être ajouté en tant que contributeur, puis lire le `CONTRIBUTING.md` de chaque microservice.

#### Création du projet

Le script `pull-all-repos.sh` clone `Frenchcab-Compose`, puis les trois microservices **à l'intérieur** (sur la branche `dev`), et crée le `.env` à partir de `.env.example` :

```bash
# Récupérer le script seul, puis le lancer dans le dossier de travail
curl -O https://raw.githubusercontent.com/arcar/Frenchcab-Compose/dev/pull-all-repos.sh
bash pull-all-repos.sh                         # clone en https
bash pull-all-repos.sh git@github.com:arcar/   # ou en SSH
```

Si `Frenchcab-Compose` est déjà cloné, lancer `./pull-all-repos.sh` depuis ce dossier : seuls les repos manquants sont clonés.

Structure obtenue (les dossiers des microservices sont **gitignorés** dans `Frenchcab-Compose`) :

```text
Frenchcab-Compose/
├── Frenchcab-Backend/
├── Frenchcab-Frontend/
├── Frenchcab-Gateway/
├── compose.yml
├── compose.override.yml
├── pull-all-repos.sh   # création du projet
├── pull-dev.sh         # mise à jour de dev sur les 4 repos
└── push-dev.sh         # push des commits de dev sur les 4 repos (-n : simulation)
```

#### Au quotidien

- `./pull-dev.sh` : met à jour `dev` sur les 4 repos (ignore ceux qui ont des modifications non commitées).
- `./push-dev.sh` : pousse les commits de `dev` sur les 4 repos (refuse si `dev` distante a avancé : lancer `./pull-dev.sh` d'abord).
- Dans chaque microservice, un push sur sa branche perso lance les tests puis la merge automatiquement dans `dev` (voir le `CONTRIBUTING.md`).

Ce repo `Frenchcab-Compose` n'a que 2 branches, `main` et `dev` : il ne sert qu'à l'orchestration et n'a pas vocation à être modifié (sauf compose et scripts).

### 2. VM

1. Pour accéder à la VM :
```bash
ssh -i ~/Downloads/myKey.pem groupe2@{numéro api dans VM-linux.txt}
```
Il existe 4 utilisateurs crées (`utilisateur1`, `utilisateur2`, `utilisateur3`, `utilisateur4`). Chacun a un mot de passe qui se trouve dans le fichier text `VM-linux.txt`.

2. `deploy.sh`
Dans la VM a été crée un fichier `deploy.sh` qui avec `cron` se déclenche à intervalle de **15 minnutes** pour faire un `docker pull` et un `docker up`.


## 3. Lancer le projet avec Docker

### Prérequis

Avant de lancer le projet, vérifier que les outils suivants sont installés :

- Docker Desktop
- Git
- Docker Compose

---

## Organisation du projet

Le projet est composé de 4 repositories :

```text
Frenchcab-compose (compose.yml + compose-override.yml)
-> Frenchcab-Backend + Frenchcab-Frontend + Frenchcab-Gateway
```

Le repository `Frenchcab-compose` permet d'orchestrer les trois applications.

Les dossiers `Frenchcab-Backend`, `Frenchcab-Frontend` et `Frenchcab-Gateway` doivent être présents à l'intérieur de `Frenchcab-compose` pour que le `docker-compose.override.yml` fonctionne correctement.

---

## Démarrage en développement local

Se placer dans le dossier :

```bash
cd Frenchcab-compose
```

Construire les images et lancer les conteneurs :

```bash
docker compose up --build -d
```

Cette commande utilise automatiquement :

```text
docker-compose.yml
+
docker-compose.override.yml
```

Le fichier `docker-compose.override.yml` permet de construire les images à partir des projets locaux.

Le front est alors buildé en `development` et appelle la gateway sur `http://localhost:3000`.

## Environnements (local / VM Azure)

Copier `.env.example` en `.env` et adapter `FRONT_PORT` si besoin (4200 par défaut, en local comme sur la VM).

Sur la VM, le nginx de l'hôte gère le https de `g2.valentinduflot.fr` et redirige vers le front (port `FRONT_PORT`). Lancer uniquement `compose.yml` (sans l'override) : l'image Docker Hub du front est buildée en `production` et appelle la gateway en relatif sur `/api`, que le nginx du conteneur front redirige vers `http://gateway:3000`.

```bash
docker compose -f compose.yml up -d
```

### Données du backend sur la VM

La base relationnelle et le modèle ML ne sont pas versionnés, donc absents de l'image Docker Hub. Sur la VM, les placer dans le dossier `data/` à côté de `compose.yml` (monté dans le conteneur backend, les réservations y sont conservées entre deux déploiements) :

```text
data/frenchcab_relationnelle.db   (généré par ETL/Load.py)
data/modele_temps_trajet.pkl      (généré par ML/entrainement.py)
```

Sans ces fichiers, `/zones` et `/courses` renvoient une erreur 500 / 503.


## Consulter les logs

Pour afficher les logs de tous les services :

```bash
docker compose logs -f
```

Pour afficher uniquement les logs d'un service :

```bash
docker compose logs -f frontend
```

```bash
docker compose logs -f backend
```

```bash
docker compose logs -f gateway
```

---

## Arrêter le projet

Pour arrêter et supprimer les conteneurs :

```bash
docker compose down
```

---

## Utiliser les images Docker Hub

Le fichier `docker-compose.yml` utilise les images suivantes :

```text
arcar13/frenchcab-backend:latest
arcar13/frenchcab-gateway:latest
arcar13/frenchcab-frontend:latest
```

Pour récupérer les dernières images disponibles :

```bash
docker compose pull
```

Puis lancer le projet :

```bash
docker compose up
```

Si le fichier `docker-compose.override.yml` est présent, Docker Compose l'utilise automatiquement.

Pour lancer uniquement le `docker-compose.yml`, sans l'override :

```bash
docker compose -f docker-compose.yml up
```

---

## Accès aux services

Une fois les conteneurs démarrés :

```text
Frontend : http://localhost:4200
Gateway  : http://localhost:3000
Backend  : http://localhost:3001
```

---

## Déclenchement de la CI

Chaque repository applicatif contient un workflow GitHub Actions dans :

```text
.github/workflows/ci.yml
```

La CI se déclenche automatiquement lorsqu'un commit est poussé sur la branche :

```text
dev
```
Le CI fait actuellement `docker build` et `docker push`.
Les identifiants ne sont pas écrits directement dans le workflow.

Ils sont stockés dans les secrets GitHub :

```text
DOCKERHUB_USERNAME
DOCKERHUB_TOKEN
```

Le repository `Frenchcab-compose` peut ensuite récupérer ces dernières images avec :

```bash
docker compose pull
```

puis les lancer avec :

```bash
docker compose up
```

## Etat Brief 2 - Groupe 3 
L'application est déployée sur g2.valentinduflot.fr. 
Il est possible de réaliser une prédiction et une réservation.
Problème en cours : 
- Impossible d'annuler une réservation. 
- Base remise à zéro à chaque ```docker compose down```

### TO DO :
- Sauvegarder les modifications de la base de données relationnelles dans un volume afin que les réservations soient sauvegardées et accessibles même après un reboot des conteneurs.
- Revoir la route d'annulation des reservations.
- Interdire les réservations dans le passé.
- Rajouter les routes demandées du Brief 1 (liste des courses de taxi et détails)