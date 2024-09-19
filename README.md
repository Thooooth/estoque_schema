# Documentação do Esquema de Banco de Dados - Sistema de Gerenciamento de Estoque

## Visão Geral

Este documento descreve o esquema de banco de dados para um Sistema de Gerenciamento de Estoque. O sistema é projetado para rastrear produtos, suas categorias, fornecedores e movimentações de estoque.

## Estrutura do Banco de Dados

O banco de dados `sistema_estoque` consiste em quatro tabelas principais e uma view:

1. `categorias`
2. `fornecedores`
3. `produtos`
4. `movimentacoes_estoque`
5. View: `produtos_baixo_estoque`

### Tabelas

#### Categorias

Armazena informações sobre as categorias dos produtos.

| Coluna    | Tipo         | Descrição                       |
|-----------|--------------|----------------------------------|
| id        | INT          | Identificador único da categoria |
| nome      | VARCHAR(50)  | Nome da categoria                |
| descricao | TEXT         | Descrição da categoria           |

#### Fornecedores

Contém dados dos fornecedores dos produtos.

| Coluna    | Tipo         | Descrição                       |
|-----------|--------------|----------------------------------|
| id        | INT          | Identificador único do fornecedor|
| nome      | VARCHAR(100) | Nome do fornecedor               |
| cnpj      | VARCHAR(14)  | CNPJ do fornecedor (único)       |
| telefone  | VARCHAR(20)  | Telefone de contato              |
| email     | VARCHAR(100) | Email de contato                 |

#### Produtos

Armazena informações detalhadas sobre os produtos.

| Coluna             | Tipo           | Descrição                          |
|--------------------|----------------|-------------------------------------|
| id                 | INT            | Identificador único do produto      |
| nome               | VARCHAR(100)   | Nome do produto                     |
| descricao          | TEXT           | Descrição do produto                |
| preco_unitario     | DECIMAL(10, 2) | Preço unitário do produto           |
| quantidade_estoque | INT            | Quantidade atual em estoque         |
| categoria_id       | INT            | ID da categoria (chave estrangeira) |
| fornecedor_id      | INT            | ID do fornecedor (chave estrangeira)|

#### Movimentacoes_Estoque

Registra todas as movimentações de entrada e saída de produtos no estoque.

| Coluna              | Tipo                    | Descrição                           |
|---------------------|-------------------------|--------------------------------------|
| id                  | INT                     | Identificador único da movimentação  |
| produto_id          | INT                     | ID do produto (chave estrangeira)    |
| tipo_movimentacao   | ENUM('entrada', 'saida')| Tipo de movimentação                 |
| quantidade          | INT                     | Quantidade movimentada               |
| data_movimentacao   | DATETIME                | Data e hora da movimentação          |
| usuario_responsavel | VARCHAR(50)             | Usuário responsável pela movimentação|

### View

#### Produtos_Baixo_Estoque

Uma view que mostra produtos com quantidade em estoque menor que 10.

| Coluna             | Tipo         | Descrição                    |
|--------------------|--------------|------------------------------|
| id                 | INT          | ID do produto                |
| nome               | VARCHAR(100) | Nome do produto              |
| quantidade_estoque | INT          | Quantidade atual em estoque  |
| categoria          | VARCHAR(50)  | Nome da categoria do produto |

## Índices

Para otimizar o desempenho das consultas, foram criados os seguintes índices:

- `idx_produtos_categoria` na tabela `produtos` (categoria_id)
- `idx_produtos_fornecedor` na tabela `produtos` (fornecedor_id)
- `idx_movimentacoes_produto` na tabela `movimentacoes_estoque` (produto_id)

## Trigger

Um trigger chamado `atualiza_estoque` foi implementado para atualizar automaticamente a quantidade em estoque na tabela `produtos` após cada inserção na tabela `movimentacoes_estoque`.

## Uso do Esquema

Para utilizar este esquema:

1. Execute o script SQL em um servidor MySQL.
2. O banco de dados `sistema_estoque` será criado com todas as tabelas, índices, trigger e view.
3. Comece a inserir dados nas tabelas, começando com `categorias` e `fornecedores`, seguido por `produtos`.
4. Use a tabela `movimentacoes_estoque` para registrar entradas e saídas de produtos.
5. Consulte a view `produtos_baixo_estoque` para verificar produtos com estoque baixo.

## Considerações de Segurança

- Implemente controle de acesso adequado ao banco de dados.
- Considere criptografar dados sensíveis, se necessário.
- Faça backups regulares do banco de dados.

## Manutenção

- Monitore o desempenho das consultas e ajuste os índices conforme necessário.
- Revise e otimize o esquema periodicamente para garantir que ele atenda às necessidades em evolução do sistema.
