#!/usr/bin/env bash
# Pousse les commits de la branche dev de Frenchcab-Compose et des microservices (usage : ./push-dev.sh [-n])
# -n : simulation, affiche ce qui serait poussé sans rien pousser

set -u

RACINE="$(cd "$(dirname "$0")" && pwd)"
REPOS=(Frenchcab-Backend Frenchcab-Frontend Frenchcab-Gateway)
SIMULATION=0
ECHECS=0

[ "${1:-}" = "-n" ] && SIMULATION=1

push_dev() {
    local nom="$1" dossier="$2"
    echo "== $nom"

    if [ ! -d "$dossier/.git" ]; then
        echo "   absent, ignoré (lancer ./pull-dev.sh)"
        ECHECS=$((ECHECS + 1))
        return
    fi

    if ! git -C "$dossier" fetch -q origin dev; then
        echo "   échec du fetch"
        ECHECS=$((ECHECS + 1))
        return
    fi

    local avance retard
    avance="$(git -C "$dossier" rev-list --count origin/dev..dev)"
    retard="$(git -C "$dossier" rev-list --count dev..origin/dev)"

    if [ -n "$(git -C "$dossier" status --porcelain)" ]; then
        echo "   attention : modifications non commitées (non poussées)"
    fi

    if [ "$retard" -gt 0 ]; then
        echo "   dev distante a $retard commit(s) en plus, lancer ./pull-dev.sh avant de pousser"
        ECHECS=$((ECHECS + 1))
        return
    fi

    if [ "$avance" -eq 0 ]; then
        echo "   rien à pousser"
        return
    fi

    git -C "$dossier" log --oneline origin/dev..dev | sed 's/^/   /'

    if [ "$SIMULATION" -eq 1 ]; then
        echo "   simulation : $avance commit(s) à pousser"
    elif git -C "$dossier" push -q origin dev; then
        echo "   $avance commit(s) poussé(s)"
    else
        echo "   échec du push"
        ECHECS=$((ECHECS + 1))
    fi
}

push_dev "Frenchcab-Compose" "$RACINE"

for repo in "${REPOS[@]}"; do
    push_dev "$repo" "$RACINE/$repo"
done

if [ "$ECHECS" -gt 0 ]; then
    echo "$ECHECS repo(s) non poussé(s)"
    exit 1
fi
echo "Push terminé"
