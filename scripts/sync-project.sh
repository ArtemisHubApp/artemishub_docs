#!/usr/bin/env bash
# Preenche os campos "Semana" e "Prioridade" do Project a partir das labels das issues.
set -euo pipefail
OWNER=ArtemisHubApp
N=${PROJECT_NUMBER:?defina PROJECT_NUMBER antes de rodar}
PID=$(gh project view "$N" --owner "$OWNER" --format json --jq .id)

ensure_field() {
  if ! gh project field-list "$N" --owner "$OWNER" --format json --jq '.fields[].name' | grep -qx "$1"; then
    gh project field-create "$N" --owner "$OWNER" --name "$1" --data-type SINGLE_SELECT --single-select-options "$2" >/dev/null
    echo "campo criado: $1"
  fi
}
ensure_field Semana "Semana 1,Semana 2,Semana 3,Semana 4,Semana 5,Semana 6,Semana 7"
ensure_field Prioridade "Alta,Média,Baixa"

FIELDS=$(gh project field-list "$N" --owner "$OWNER" --format json)
fid() { jq -r --arg f "$1" '.fields[] | select(.name==$f) | .id' <<<"$FIELDS"; }
oid() { jq -r --arg f "$1" --arg o "$2" '.fields[] | select(.name==$f) | .options[]? | select(.name==$o) | .id' <<<"$FIELDS"; }
SEM=$(fid Semana); PRI=$(fid Prioridade)

for r in docs rag agents backend frontend; do
  gh issue list --repo "$OWNER/artemishub_$r" --state open --limit 100 --json url,title,labels \
    --jq '.[] | select(.title | startswith("[S"))
          | [.url,
             ([.labels[].name | select(startswith("semana-")) | ltrimstr("semana-")] | first // ""),
             ([.labels[].name | select(startswith("prioridade: ")) | ltrimstr("prioridade: ")] | first // "")]
          | @tsv' |
  while IFS=$'\t' read -r url week prio; do
    item=$(gh project item-add "$N" --owner "$OWNER" --url "$url" --format json --jq .id)
    case "$prio" in alta) P=Alta ;; média) P=Média ;; baixa) P=Baixa ;; *) P="" ;; esac
    w_opt=$(oid Semana "Semana $week"); p_opt=$(oid Prioridade "$P")
    [ -n "$w_opt" ] && gh project item-edit --id "$item" --project-id "$PID" --field-id "$SEM" --single-select-option-id "$w_opt" >/dev/null
    [ -n "$p_opt" ] && gh project item-edit --id "$item" --project-id "$PID" --field-id "$PRI" --single-select-option-id "$p_opt" >/dev/null
    echo "ok  Semana ${week:-?}  ${P:-sem prioridade}  $url"
  done
done
