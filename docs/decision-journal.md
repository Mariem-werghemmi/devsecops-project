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
## Exercice casser/réparer — Gitleaks — 2026-09-23

**Cassé :** commité une fausse clé AWS (`AKIAX7Q3M9F2K4J8P1RS`) dans
`app/config_debug.py`.

**Pourquoi le pipeline l'a bloqué :** Gitleaks scanne l'historique Git
complet à chaque push (grâce à `fetch-depth: 0`). Il a détecté le
pattern d'une clé AWS (règle `aws-access-token`, entropie 4.12) et
fait échouer le job avant même l'installation de Python — c'est le
shift-left : bloquer le plus tôt possible dans le pipeline.

**Ce que ça m'a appris :** `git rm` seul ne suffit pas — le secret
reste dans l'historique. Il faut réécrire l'historique
(`git reset --soft` + recommit) et forcer le push. En situation
réelle, la vraie protection est de révoquer/régénérer la clé
immédiatement, pas seulement de nettoyer l'historique.

**Commits liés :**
- Secret commité : `e6e65e7`
- Nettoyage : <colle le hash du commit de correction>
