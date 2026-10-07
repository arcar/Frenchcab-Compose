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

1. Cloner le repo Github :
```powershell
https://github.com/arcar/Frenchcab-Compose.git


```
Demander l'accè à `mmorkos-cyber` pour être ajouté en tant que contributeur, puis lire le `contributing`.

2. Cloner les autres repos dans le dossier `Frenchcab-compose` :
- Frenchcab-Gateway
 ```powershell
https://github.com/mmorkos-cyber/Frenchcab-Gateway.git
```
- Frenchcab-Backend
```powershell
https://github.com/mmorkos-cyber/Frenchcab-Backend.git
```
- Frenchcab-Frontend :
```powershell
https://github.com/mmorkos-cyber/Frenchcab-Frontend.git
```
Ces repos `Frenchcab-Backend`, `Frenchcab-Frontend`, `Frenchcab-Gateway` sont **gitignorés**.

3. Chaque repo a un fichier `CONTRIUTING.md` et un `README.md`, qui vous expliquera l'installation mais aussi où en est le groupe à la fin de la semaine sur chaque partie.

4. Concernant ce repo on y trouve que 2 branches `main` et `dev`, étant donné que celui-ci n'est là que pour l'orchestration il n'a pas pour objectif d'être modifié (sauf compose).

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

