---
origem: "Grupo 11 - Second Challenge - RAG (Relatório de Projeto, Semana 2) · seção Consulta, recuperação e resposta"
codigo: "src/query.py · src/lexical.py"
---

# Consulta e resposta

Por padrão, a busca híbrida seleciona até **5 trechos**. O modelo configurado recebe a instrução de responder com base neles e citar as fontes. O validador verifica o formato e se os identificadores citados correspondem aos trechos recuperados. A conferência de que cada fonte sustenta a afirmação é uma etapa da [avaliação](../avaliacao/index.md).

Quando falta evidência, o sistema pode se abster. Uma resposta com citação inválida é bloqueada. Para testar a consulta localmente, siga o [guia de reprodução](../guias/reproduzir.md) e execute:

```bash
uv run python -m src.query "Quais empresas precisam publicar o relatório de transparência salarial?"
```

## Etapas da consulta

<ol class="art-steps" markdown>
<li markdown>
**Busca vetorial:** os 20 chunks mais próximos da pergunta por cosseno.
</li>
<li markdown>
**Busca por palavras (BM25):** os 20 chunks com mais termos em comum, com peso maior para termos raros.
</li>
<li markdown>
**Fusão RRF:** quem vai bem nas duas listas sobe.
</li>
<li markdown>
**Diversificação:** o melhor chunk de cada página entra antes de repetir uma página.
</li>
<li markdown>
**Geração:** os 5 trechos vão rotulados de FONTE 1 a FONTE 5, com título, URL e página; o prompt exige citar `[FONTE N]` em todo parágrafo e tratar o texto recuperado como dado, nunca como instrução.
</li>
<li markdown>
**Validação:** a resposta é barrada se citar fonte não recuperada, tiver citação malformada ou parágrafo sem citação.
</li>
</ol>

## Exemplo completo

**Pergunta:** "Quais empresas precisam publicar o relatório de transparência salarial?"

### Trechos recuperados

| Trecho | Fonte | Página | Distância | Trecho recuperado (início) | Citado |
|---|---|--:|--:|---|:-:|
| FONTE 1 | Diretrizes para os Planos de Ação | 4 | 0,265 | "Desde 2023, empresas com 100 (cem) ou mais empregados, deverão publicar a cada semestre relatórios de transparência salarial…" | <span class="art-chip art-chip--ok">sim</span> |
| FONTE 2 | Portaria MTE nº 3.714/2023 | 2 | 0,273 | "Art. 6º A publicação do Relatório de Transparência Salarial e de Critérios Remuneratórios, pelo Ministério do Trabalho e Emprego…" | <span class="art-chip">não</span> |
| FONTE 3 | Cartilha Tira-Dúvidas | 9 | 0,296 | "Como é feita a publicação do Relatório de Transparência Salarial…" | <span class="art-chip">não</span> |
| FONTE 4 | Cartilha Tira-Dúvidas | 5 | 0,302 | "…a obrigação das empresas de direito privado com 100 ou mais empregados de apresentar, duas vezes ao ano, o Relatório…" | <span class="art-chip art-chip--ok">sim</span> |
| FONTE 5 | Guia para Negociação Coletiva | 33 | 0,255 | "Prevê a criação de relatórios anuais conjuntos sobre boas práticas de equidade salarial…" | <span class="art-chip">não</span> |

### Resposta exibida

> As empresas de direito privado que possuem 100 (cem) ou mais empregados devem publicar relatórios de transparência salarial e de critérios remuneratórios **\[FONTE 1\]** **\[FONTE 4\]**.

!!! success "Evidência"
    As duas fontes citadas trazem a regra quase literalmente (Diretrizes, p. 4, e Cartilha, p. 5), e cada uma aparece com link para o documento oficial e a página.

Veja as outras quatro perguntas da demonstração em [Demonstração](demonstracao.md).
