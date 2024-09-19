DELIMITER //

-- Procedure 1: Adicionar novo produto
CREATE PROCEDURE adicionar_produto(
    IN p_nome VARCHAR(100),
    IN p_descricao TEXT,
    IN p_preco_unitario DECIMAL(10, 2),
    IN p_quantidade_inicial INT,
    IN p_categoria_id INT,
    IN p_fornecedor_id INT
)
BEGIN
    INSERT INTO produtos (nome, descricao, preco_unitario, quantidade_estoque, categoria_id, fornecedor_id)
    VALUES (p_nome, p_descricao, p_preco_unitario, p_quantidade_inicial, p_categoria_id, p_fornecedor_id);
    
    -- Registrar a entrada inicial no estoque
    INSERT INTO movimentacoes_estoque (produto_id, tipo_movimentacao, quantidade, usuario_responsavel)
    VALUES (LAST_INSERT_ID(), 'entrada', p_quantidade_inicial, 'Sistema');
END //

-- Procedure 2: Atualizar quantidade em estoque
CREATE PROCEDURE atualizar_estoque(
    IN p_produto_id INT,
    IN p_quantidade INT,
    IN p_tipo_movimentacao ENUM('entrada', 'saida'),
    IN p_usuario VARCHAR(50)
)
BEGIN
    INSERT INTO movimentacoes_estoque (produto_id, tipo_movimentacao, quantidade, usuario_responsavel)
    VALUES (p_produto_id, p_tipo_movimentacao, p_quantidade, p_usuario);
    
    -- A atualização da quantidade em estoque é feita pelo trigger 'atualiza_estoque'
END //

-- Procedure 3: Obter relatório de estoque baixo
CREATE PROCEDURE relatorio_estoque_baixo(IN p_limite INT)
BEGIN
    SELECT p.id, p.nome, p.quantidade_estoque, c.nome AS categoria
    FROM produtos p
    JOIN categorias c ON p.categoria_id = c.id
    WHERE p.quantidade_estoque <= p_limite
    ORDER BY p.quantidade_estoque ASC;
END //

DELIMITER ;
