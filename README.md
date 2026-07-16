# AdventureWorks Product Portfolio Analytics

Dashboard analítico de portfólio de produtos construído sobre o dataset AdventureWorks da Microsoft, com pipeline completo de engenharia analítica: ingestão, transformação, modelagem e visualização.

---

## Visão Geral

Este projeto responde às seguintes perguntas de negócio de um Gerente de Produto:

- Quais produtos geram margem real versus apenas volume de vendas?
- Quais produtos escalar, quais descontinuar?
- Onde os descontos estão destruindo a rentabilidade?
- Quais produtos representam 80% da receita (Pareto)?
- Como a performance varia por região e loja?

---

## Stack

```
SQL Server (Docker)
    → Airbyte (ingestão)
        → PostgreSQL (Docker)
            → dbt (transformação)
                → Power BI (visualização)
```

---

## Arquitetura do Pipeline

### Fonte de Dados
**AdventureWorks 2022 OLTP** — banco operacional oficial da Microsoft, disponível em:
> https://github.com/microsoft/sql-server-samples/releases

O arquivo `.bak` é restaurado automaticamente no container SQL Server ao subir o ambiente.

### Ingestão
O **Airbyte** conecta no SQL Server como source e replica os schemas `Sales`, `Production` e `Person` para o PostgreSQL como destination. A sincronização é manual (Full Refresh | Overwrite) — dado estático não justifica sync automático.

### Transformação (dbt)
A modelagem segue a arquitetura em três camadas:

```
staging/        → padronização de nomenclatura, remoção de colunas desnecessárias
intermediate/   → joins entre tabelas, lógica de custo histórico
marts/          → fatos e dimensões com métricas calculadas
```

**Decisões técnicas relevantes:**
- `ProductCostHistory` segue padrão SCD Type 2 — o custo correto por data de venda é buscado via join por período de vigência (`OrderDate BETWEEN StartDate AND COALESCE(EndDate, '9999-12-31')`)
- Produtos sem custo vigente na data da venda usam o último custo conhecido via `DISTINCT ON` — fallback implementado no intermediate
- Pedidos online (sem loja física) recebem `store_id = -1` via `COALESCE` — linha "Online" adicionada na `dim_store` via `UNION ALL`
- Margem bruta calculada no dbt: `(unit_price * order_quantity * (1 - unit_price_discount) - standard_cost * order_quantity) / NULLIF(net_revenue, 0)`

### Modelo de Dados

| Tabela | Tipo | Linhas | Descrição |
|--------|------|--------|-----------|
| `fact_sales` | Fato | 121.317 | Linhas de pedido com custo, desconto e métricas calculadas |
| `dim_product` | Dimensão | 504 | Produto com hierarquia completa (categoria → subcategoria) |
| `dim_store` | Dimensão | 702 | Loja com território e grupo regional |
| `dim_date` | Dimensão | - | Criada no Power BI via M |

**Relacionamentos:**
- `fact_sales.product_id` → `dim_product.product_id`
- `fact_sales.store_id` → `dim_store.store_id`
- `fact_sales.order_date` → `dim_date.date`

---

## Estrutura do Projeto

```
adventureworks_product_analytics/
├── data/                          # .bak do AdventureWorks (não versionado)
├── dbt/
│   ├── models/
│   │   ├── staging/               # 16 models de staging
│   │   ├── intermediate/          # 2 models intermediários
│   │   └── marts/                 # 3 marts (dim_product, dim_store, fact_sales)
│   ├── macros/
│   │   └── net_revenue.sql        # Macro reutilizável para cálculo de receita líquida
│   ├── tests/
│   │   └── test_pct_range.sql     # Teste singular: validação de range de percentuais
│   └── dbt_project.yml
├── docker/
│   ├── sqlserver.Dockerfile       # SQL Server com restore automático do .bak
│   ├── entrypoint.sh              # Script de restore automático
│   └── dbt.Dockerfile             # Python + dbt-core + dbt-postgres
├── docker-compose.yml
├── .env.example
└── README.md
```

---

## Como Executar

### Pré-requisitos
- Docker Desktop
- Airbyte via `abctl` (Kubernetes local)
- Power BI Desktop
- 8GB+ RAM disponível

### 1. Clonar o repositório
```bash
git clone https://github.com/rodriguesgui/adventureworks_product_analytics
cd adventureworks_product_analytics
```

### 2. Baixar o dataset
Baixe o `AdventureWorks2022.bak` em:
> https://github.com/microsoft/sql-server-samples/releases

Coloque o arquivo em `data/AdventureWorks2022.bak`.

### 3. Configurar variáveis de ambiente
```bash
cp .env.example .env
```

Edite o `.env` com suas credenciais:
```env
MSSQL_SA_PASSWORD=Admin@1234
POSTGRES_USER=postgres
POSTGRES_PASSWORD=postgres
POSTGRES_DB=adventureworks_raw
```

### 4. Subir os containers
```bash
docker-compose up --build -d
```

O SQL Server vai restaurar o `.bak` automaticamente. Aguarde ~30 segundos e verifique:
```bash
docker logs aw_sqlserver
```

### 5. Configurar o Airbyte
Com o `abctl` rodando:
```bash
abctl local credentials
```

Acesse `http://localhost:8000` e configure:
- **Source:** SQL Server — `host.docker.internal:1444`, database `AdventureWorks2022`, schemas `Sales`, `Production`, `Person`
- **Destination:** PostgreSQL — `host.docker.internal:5444`, database `adventureworks_raw`
- **Sync:** Full Refresh | Overwrite | Manual

Execute a sincronização.

### 6. Executar o dbt
```bash
docker exec -it aw_dbt bash
dbt run
dbt test
```

Resultado esperado: **21 models**, **102 testes passando**.

### 7. Conectar o Power BI
No Power BI Desktop:
- **Obter dados** → PostgreSQL
- Servidor: `localhost:5444`
- Banco: `adventureworks_raw`
- Importar: `public_marts.fact_sales`, `public_marts.dim_product`, `public_marts.dim_store`

---

## Dashboard

### Páginas

| Página | Descrição |
|--------|-----------|
| Visão Executiva | KPIs gerais, receita por mês/ano, ranking de produtos |
| Rentabilidade do Portfólio | Margem por categoria, evolução temporal, tabela detalhada |
| Giro x Margem | Scatter com quadrantes (Estrela, Vaca Leiteira, Nicho, Abacaxi) |
| Impacto de Desconto | Análise do efeito dos descontos na margem por categoria |
| Pareto de Receita | Curva acumulada — 63 produtos representam 80% da receita |
| Visão Regional e por Loja | Decomposition Tree hierárquico + tabela de lojas |

### Principais Insights
- **Bikes** com desconto têm margem média de **-41,57%** — vendendo abaixo do custo
- **63 de 266 produtos** (23,7%) representam 80% da receita total de R$109,8 mi
- **Online** é o canal com maior margem: **41,15%**
- **Accessories** é a categoria com melhor margem sem desconto: **52,66%**

---

## Testes dbt

| Camada | Testes | Resultado |
|--------|--------|-----------|
| Staging | 56 | ✅ Passando |
| Intermediate | 20 | ✅ Passando |
| Marts | 26 | ✅ Passando |
| Singular | 1 | ✅ Passando |
| **Total** | **103** | **✅ 103/103** |

---

## Decisões de Design

**Por que AdventureWorks OLTP e não o RetailDW?**
O RetailDW já vem como star schema tratado — o trabalho de transformação seria mínimo. O OLTP normalizado permite mostrar a transformação real: `staging → intermediate → marts`, que é o que diferencia um portfólio de engenharia analítica.

**Por que Airbyte e não carga direta?**
O padrão SQL Server → Airbyte → PostgreSQL replica exatamente o que acontece em empresas com sistemas legados sendo replicados para ambientes analíticos. É um diferencial de portfólio defensável em entrevista.

**Por que calcular margem no dbt e não no Power BI?**
Métricas de negócio calculadas na camada de transformação garantem consistência — qualquer ferramenta que consumir os dados (Power BI, Tableau, Python) vai ter o mesmo número. Cálculo no Power BI fica preso na ferramenta.

---

## Sobre o Projeto

**Período:** 2011–2014 (período do dataset AdventureWorks)
**Volume:** 121.317 linhas de pedido | 266 produtos vendidos | 701 lojas | 10 territórios
**Tecnologias:** SQL Server, Airbyte, PostgreSQL, dbt 1.8, Power BI

---

*Projeto 2 do portfólio de dados — Guilherme Rodrigues*
*github.com/rodriguesgui*
 
