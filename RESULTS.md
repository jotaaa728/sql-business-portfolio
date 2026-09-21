# Resultados validados

Todas as consultas abaixo foram executadas contra a base recriada com `schema.sql` + `sample_data.sql`.

## 01. Qual foi o faturamento mensal e quantos pedidos foram concluídos em cada mês?

| month   | completed_orders | revenue |
|:--------|-----------------:|--------:|
| 2026-01 | 142 | 235614 |
| 2026-02 | 129 | 213130 |
| 2026-03 | 141 | 238898 |
| 2026-04 | 136 | 231054 |
| 2026-05 | 140 | 225335 |
| 2026-06 | 137 | 232874 |
| 2026-07 | 141 | 243876 |
| 2026-08 | 142 | 242476 |

## 02. Quais são os 5 produtos com maior faturamento?

| product_name | category | units_sold | revenue |
|:-------------|:---------|-----------:|--------:|
| Product 11 | Home | 114 | 94494.6 |
| Product 24 | Office | 108 | 93916 |
| Product 12 | Home | 112 | 93530.1 |
| Product 36 | Fitness | 110 | 87994.4 |
| Product 23 | Office | 111 | 82525.4 |

## 03. Qual é o ticket médio por segmento de cliente?

| segment | orders | avg_ticket |
|:--------|-------:|-----------:|
| Corporate | 111 | 2005.82 |
| Small Business | 221 | 1821.22 |
| Consumer | 776 | 1595.52 |

## 04. Qual é a taxa de clientes recorrentes entre os clientes que compraram?

| customers_who_bought | repeat_customers | repeat_customer_rate_pct |
|---------------------:|-----------------:|-------------------------:|
| 200 | 200 | 100 |

## 05. Quais estados geram mais faturamento?

| state | orders | revenue |
|:------|-------:|--------:|
| SP | 139 | 267837 |
| PA | 138 | 253722 |
| MG | 139 | 231806 |
| DF | 138 | 229137 |
| GO | 139 | 226722 |
| BA | 139 | 220133 |
| MA | 138 | 217741 |
| TO | 138 | 216158 |

## 06. Qual categoria tem maior margem bruta em valor e percentual?

| category | gross_margin_value | gross_margin_pct |
|:---------|-------------------:|-----------------:|
| Office | 178762 | 37.77 |
| Fitness | 177654 | 37.22 |
| Home | 175984 | 37.80 |
| Electronics | 167232 | 37.40 |

## 07. Quais clientes estão inativos há mais de 90 dias considerando 01/09/2026?

A consulta retorna 74 clientes. Primeiros resultados:

| customer_id | customer_name | state | last_order_date | days_inactive |
|------------:|:--------------|:------|:----------------|--------------:|
| 18 | Customer 018 | GO | 2026-03-05 | 180 |
| 184 | Customer 184 | TO | 2026-03-09 | 176 |
| 10 | Customer 010 | GO | 2026-03-10 | 175 |
| 36 | Customer 036 | MG | 2026-03-11 | 174 |
| 62 | Customer 062 | MA | 2026-03-12 | 173 |

## 08. Qual a participação de cada método de pagamento no faturamento?

| payment_method | transactions | revenue | revenue_share_pct |
|:---------------|-------------:|--------:|------------------:|
| PIX | 277 | 521560 | 27.99 |
| Debit Card | 277 | 449270 | 24.11 |
| Boleto | 277 | 447964 | 24.04 |
| Credit Card | 277 | 444463 | 23.85 |

## 09. Qual canal de venda apresenta a maior taxa de cancelamento?

| sales_channel | total_orders | cancelled_orders | cancellation_rate_pct |
|:--------------|-------------:|-----------------:|----------------------:|
| WhatsApp | 300 | 23 | 7.67 |
| Website | 300 | 23 | 7.67 |
| Marketplace | 300 | 23 | 7.67 |
| App | 300 | 23 | 7.67 |

## 10. Quais produtos têm risco de estoque com base no ritmo recente de vendas?

| product_name | category | stock_qty | units_sold_30d | estimated_days_of_stock |
|:-------------|:---------|----------:|---------------:|------------------------:|
| Product 08 | Electronics | 7 | 19 | 11.1 |
| Product 24 | Office | 11 | 14 | 23.6 |
| Product 32 | Fitness | 13 | 16 | 24.4 |
| Product 16 | Home | 9 | 10 | 27.0 |
| Product 40 | Fitness | 15 | 13 | 34.6 |
| Product 17 | Home | 28 | 16 | 52.5 |
| Product 25 | Office | 30 | 16 | 56.3 |
| Product 01 | Electronics | 24 | 12 | 60.0 |
| Product 09 | Electronics | 26 | 13 | 60.0 |
| Product 33 | Fitness | 32 | 13 | 73.8 |
