-- Consulta 1: Relatório de produtos com baixo estoque (menos de 10 unidades)
SELECT p.id, p.nome, p.quantidade_estoque, c.nome AS categoria
FROM produtos p
JOIN categorias c ON p.categoria_id = c.id
WHERE p.quantidade_estoque < 10
ORDER BY p.quantidade_estoque ASC;

-- Consulta 2: Total de valor em estoque por categoria
SELECT c.nome AS categoria, SUM(p.quantidade_estoque * p.preco_unitario) AS valor_total
FROM produtos p
JOIN categorias c ON p.categoria_id = c.id
GROUP BY c.id
ORDER BY valor_total DESC;

-- Consulta 3: Produtos mais movimentados nos últimos 30 dias
SELECT p.nome, SUM(m.quantidade) AS total_movimentado
FROM produtos p
JOIN movimentacoes_estoque m ON p.id = m.produto_id
WHERE m.data_movimentacao >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)
GROUP BY p.id
ORDER BY total_movimentado DESC
LIMIT 10;

-- Consulta 4: Fornecedores com mais produtos em estoque
SELECT f.nome AS fornecedor, COUNT(p.id) AS total_produtos, SUM(p.quantidade_estoque) AS total_estoque
FROM fornecedores f
JOIN produtos p ON f.id = p.fornecedor_id
GROUP BY f.id
ORDER BY total_estoque DESC;

-- Consulta 5: Histórico de movimentações de um produto específico
SELECT m.data_movimentacao, m.tipo_movimentacao, m.quantidade, m.usuario_responsavel
FROM movimentacoes_estoque m
WHERE m.produto_id = 1  -- Substitua 1 pelo ID do produto desejado
ORDER BY m.data_movimentacao DESC;
