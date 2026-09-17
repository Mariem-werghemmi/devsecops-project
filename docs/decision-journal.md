# Journal de décisions — Étape 0

## Exercice casser/réparer — 2026-09-XX

**Cassé :** j'ai modifié `app/tests/test_app.py` pour attendre
`status == "ko"` au lieu de `"ok"` sur l'endpoint `/health`.

**Pourquoi le pipeline l'a bloqué :** GitHub Actions relance
`pytest` à chaque push. L'assertion a échoué, pytest est sorti
avec un code d'erreur non nul, donc l'étape "TESTER" du workflow
a échoué, ce qui a fait échouer tout le job (build ROUGE).
L'image Docker n'a même pas été construite : le pipeline s'arrête
à la première étape qui échoue.

**Ce que ça m'a appris :** un pipeline CI ne sert pas juste à
automatiser des commandes — il sert de garde-fou. Sans lui,
j'aurais pu committer/merger du code cassé sans m'en rendre
compte. Le rouge n'est pas une punition, c'est le pipeline qui
fait exactement son travail.

**Commits liés :**
- Rouge (test cassé) : `<HASH_ROUGE>`
- Vert (correction) : `<HASH_VERT>`
