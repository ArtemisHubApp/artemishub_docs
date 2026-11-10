# Site da documentação (MkDocs Material)

Endereço configurado para publicação no GitHub Pages: <https://artemishubapp.github.io/artemishub_docs/>

## Publicar (uma vez)

1. No GitHub: **Settings → Pages → Build and deployment → Source: GitHub Actions**.
2. Faça push na `main`. O workflow `.github/workflows/docs.yml` constrói e publica o site.

A documentação original em `docs/01-definicoes/` foi preservada. A navegação usa as novas seções do site.

## Visualizar localmente no PowerShell

```powershell
python -m venv .venv
.\.venv\Scripts\python.exe -m pip install -r requirements.txt
.\.venv\Scripts\python.exe -m mkdocs serve --dev-addr 127.0.0.1:8000
.\.venv\Scripts\python.exe -m mkdocs build --strict
```

Acesse <http://127.0.0.1:8000/artemishub_docs/>.

## Onde mexer

| O quê | Onde |
|---|---|
| Cores, fontes e tokens da identidade visual | `docs/assets/stylesheets/artemis.css` (seção 1) |
| Logo, emblema e favicon | `docs/assets/images/brand/` (PNGs gerados da logo oficial) |
| Landing page | `overrides/home.html` |
| Menu e plugins | `mkdocs.yml` |
| Termos com dica ao passar o mouse | `docs/includes/abbreviations.md` |

## Identidade visual

Paleta extraída da logo oficial: creme `#f5f2e9`, ameixa `#53063a`, carmim `#a60c0b` (e coral `#ff6b5e` no tema escuro). Os tokens ficam na seção 1 de `docs/assets/stylesheets/artemis.css`. Os emblemas e wordmarks em `docs/assets/images/brand/` foram gerados a partir da imagem da logo (fundo transparente, versões clara e escura).
