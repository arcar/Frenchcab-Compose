#!/usr/bin/env bash
# Création du projet Frenchcab : clone Frenchcab-Compose et les microservices sur dev.
# Usage : ./pull-all-repos.sh [base_url]
#   base_url : https://github.com/arcar/ par défaut (ex : git@github.com:arcar/ pour SSH)
# Lancé depuis Frenchcab-Compose, il complète ce dossier ; sinon il crée ./Frenchcab-Compose.

set -u

REPOS=(Frenchcab-Backend Frenchcab-Frontend Frenchcab-Gateway)
DOSSIER_SCRIPT="$(cd "$(dirname "$0")" && pwd)"
ECHECS=0

# Dossier Frenchcab-Compose : celui du script s'il en est un, sinon à créer ici
if git -C "$DOSSIER_SCRIPT" remote get-url origin 2>/dev/null | grep -q "Frenchcab-Compose\(\.git\)\?$"; then
    RACINE="$DOSSIER_SCRIPT"
    BASE_DEFAUT="$(git -C "$RACINE" remote get-url origin | sed 's#Frenchcab-Compose\(\.git\)\?$##')"
else
    RACINE="$PWD/Frenchcab-Compose"
    BASE_DEFAUT="https://github.com/arcar/"
fi
BASE_URL="${1:-$BASE_DEFAUT}"

cloner() {
    local repo="$1" dossier="$2"
    echo "== $repo"

    if [ -d "$dossier/.git" ]; then
        echo "   déjà présent (mise à jour : ./pull-dev.sh)"
        return
    fi

    if git clone -q -b dev "${BASE_URL}${repo}.git" "$dossier"; then
        echo "   cloné sur dev"
    else
        echo "   échec du clonage (accès au repo ? demander à être ajouté comme contributeur)"
        ECHECS=$((ECHECS + 1))
    fi
}

cloner "Frenchcab-Compose" "$RACINE"
[ -d "$RACINE/.git" ] || { echo "Impossible de continuer sans Frenchcab-Compose"; exit 1; }

for repo in "${REPOS[@]}"; do
    cloner "$repo" "$RACINE/$repo"
done

# Variables d'environnement de compose (FRONT_PORT...)
if [ ! -f "$RACINE/.env" ] && [ -f "$RACINE/.env.example" ]; then
    cp "$RACINE/.env.example" "$RACINE/.env"
    echo "== .env créé depuis .env.example"
fi

if [ "$ECHECS" -gt 0 ]; then
    echo "$ECHECS repo(s) non cloné(s)"
    exit 1
fi
echo "Projet prêt dans $RACINE"
echo "Lancer en local : cd \"$RACINE\" && docker compose up --build -d"
