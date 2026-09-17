#!/usr/bin/env bash
set -euo pipefail

echo ">>> [1/5] Installer les dependances"
python3 -m venv .venv
. .venv/bin/activate
pip install --quiet --upgrade pip
pip install --quiet -r app/requirements.txt pytest

echo ">>> [2/5] Tester"
pytest -q app/tests

echo ">>> [3/5] Construire l'image Docker"
docker build -f docker/Dockerfile -t flask-demo:dev .

echo ">>> [4/5] Verifier que l'app repond"
docker run -d --rm -p 8080:8080 --name flask-demo-check flask-demo:dev
sleep 2
curl -sf localhost:8080/health && echo " -> OK"

echo ">>> [5/5] Nettoyage"
docker stop flask-demo-check
deactivate

echo ">>> Pipeline manuel termine avec succes."
