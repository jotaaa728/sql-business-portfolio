# SQL Business Portfolio — E-commerce

Projeto de portfólio em SQL com uma base amostral de e-commerce e 10 perguntas de negócio respondidas com consultas SQL.

## Objetivo

Demonstrar domínio prático de SQL aplicado a problemas de negócio, incluindo:

- agregações (`SUM`, `COUNT`, `AVG`);
- `JOIN`s;
- CTEs (`WITH`);
- funções de data;
- `CASE WHEN`;
- funções de janela;
- análise de receita, margem, recorrência e cancelamento.

## Estrutura do projeto

```text
sql_business_portfolio/
├── README.md
├── schema.sql
├── seed.sql
├── business_questions.sql
├── ecommerce_sample.db
├── RESULTS.md
└── .gitignore
```

## Base de dados

A base contém cinco tabelas:

- `customers`: clientes, estado, segmento e data de cadastro;
- `products`: produtos, categoria, preço, custo e estoque;
- `orders`: pedidos, cliente, data, status e canal;
- `order_items`: itens de cada pedido, quantidade, preço e desconto;
- `payments`: método de pagamento e valor dos pedidos concluídos.

A amostra contém 200 clientes, 40 produtos e 1.200 pedidos entre janeiro e agosto de 2026.

## 10 perguntas de negócio

1. Qual foi o faturamento mensal e quantos pedidos foram concluídos em cada mês?
2. Quais são os 5 produtos com maior faturamento?
3. Qual é o ticket médio por segmento de cliente?
4. Qual é a taxa de clientes recorrentes entre os clientes que compraram?
5. Quais estados geram mais faturamento?
6. Qual categoria tem maior margem bruta em valor e percentual?
7. Quais clientes estão inativos há mais de 90 dias considerando 01/09/2026?
8. Qual a participação de cada método de pagamento no faturamento?
9. Qual canal de venda apresenta a maior taxa de cancelamento?
10. Quais produtos têm risco de estoque com base no ritmo recente de vendas?

As respostas SQL estão em `business_questions.sql`.

## Como executar

### Opção 1 — usar a base pronta

```bash
sqlite3 ecommerce_sample.db
```

Dentro do SQLite:

```sql
.read business_questions.sql
```

### Opção 2 — recriar a base

```bash
sqlite3 ecommerce_sample.db < schema.sql
sqlite3 ecommerce_sample.db < seed.sql
sqlite3 ecommerce_sample.db < business_questions.sql
```

## Resultados

Uma prévia das saídas validadas está em `RESULTS.md`.

## Tecnologias

- SQL
- SQLite
- Git/GitHub

## Sugestão de descrição para o GitHub

> Projeto de análise de dados em SQL com uma base amostral de e-commerce. Contém modelagem relacional e 10 consultas orientadas a perguntas reais de negócio, cobrindo faturamento, ticket médio, recorrência, margem, canais de venda, pagamentos e estoque.
