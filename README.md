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
https://github.com/mmorkos-cyber/Frenchcab-Compose.git
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

Pour accéder à la VM :
```bash
ssh -i ~/Downloads/myKey.pem groupe2@{numéro api dans VM-linux.txt}
```
Il existe 4 utilisateurs crées (`utilisateur1`, `utilisateur2`, `utilisateur3`, `utilisateur4`). Chacun a un mot de passe qui se trouve dans le fichier text `VM-linux.txt`.

### 3. Docker

Les images docker sont sur Dockerhub, et s'active via les fichiers `ci` dans chaque repo, il n'est donc pas utile de passer par le compose pour récuprérer les images.




