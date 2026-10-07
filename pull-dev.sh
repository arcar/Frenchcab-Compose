set -u

RACINE="$(cd "$(dirname "$0")" && pwd)"
# Base des URLs déduite du remote de ce repo (ex : git@github.com:arcar/)
BASE_URL="$(git -C "$RACINE" remote get-url origin | sed 's#Frenchcab-Compose\(\.git\)\?$##')"
REPOS=(Frenchcab-Backend Frenchcab-Frontend Frenchcab-Gateway)
ECHECS=0

maj_dev() {
    local nom="$1" dossier="$2"
    echo "== $nom"

    if [ -n "$(git -C "$dossier" status --porcelain)" ]; then
        echo "   modifications non commitées, ignoré"
        ECHECS=$((ECHECS + 1))
        return
    fi

    if git -C "$dossier" fetch --prune origin \
        && git -C "$dossier" checkout -q dev \
        && git -C "$dossier" pull --ff-only origin dev; then
        echo "   dev à jour ($(git -C "$dossier" log --oneline -1))"
    else
        echo "   échec de la mise à jour"
        ECHECS=$((ECHECS + 1))
    fi
}

maj_dev "Frenchcab-Compose" "$RACINE"

for repo in "${REPOS[@]}"; do
    if [ ! -d "$RACINE/$repo/.git" ]; then
        echo "== $repo : absent, clonage"
        git clone -b dev "${BASE_URL}${repo}.git" "$RACINE/$repo" || { ECHECS=$((ECHECS + 1)); continue; }
    fi
    maj_dev "$repo" "$RACINE/$repo"
done

if [ "$ECHECS" -gt 0 ]; then
    echo "$ECHECS repo(s) non mis à jour"
    exit 1
fi
echo "Tous les repos sont à jour sur dev"
