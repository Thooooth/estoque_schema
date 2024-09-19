-- Criação do banco de dados
CREATE DATABASE IF NOT EXISTS sistema_estoque;
USE sistema_estoque;

-- Tabela de Categorias
CREATE TABLE categorias (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(50) NOT NULL,
    descricao TEXT
);

-- Tabela de Fornecedores
CREATE TABLE fornecedores (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    cnpj VARCHAR(14) UNIQUE NOT NULL,
    telefone VARCHAR(20),
    email VARCHAR(100)
);

-- Tabela de Produtos
CREATE TABLE produtos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    descricao TEXT,
    preco_unitario DECIMAL(10, 2) NOT NULL,
    quantidade_estoque INT NOT NULL DEFAULT 0,
    categoria_id INT,
    fornecedor_id INT,
    FOREIGN KEY (categoria_id) REFERENCES categorias(id),
    FOREIGN KEY (fornecedor_id) REFERENCES fornecedores(id)
);

-- Tabela de Movimentações de Estoque
CREATE TABLE movimentacoes_estoque (
    id INT AUTO_INCREMENT PRIMARY KEY,
    produto_id INT,
    tipo_movimentacao ENUM('entrada', 'saida') NOT NULL,
    quantidade INT NOT NULL,
    data_movimentacao DATETIME DEFAULT CURRENT_TIMESTAMP,
    usuario_responsavel VARCHAR(50),
    FOREIGN KEY (produto_id) REFERENCES produtos(id)
);

-- Índices para otimização de consultas
CREATE INDEX idx_produtos_categoria ON produtos(categoria_id);
CREATE INDEX idx_produtos_fornecedor ON produtos(fornecedor_id);
CREATE INDEX idx_movimentacoes_produto ON movimentacoes_estoque(produto_id);

-- Trigger para atualizar quantidade em estoque após movimentação
DELIMITER //
CREATE TRIGGER atualiza_estoque AFTER INSERT ON movimentacoes_estoque
FOR EACH ROW
BEGIN
    IF NEW.tipo_movimentacao = 'entrada' THEN
        UPDATE produtos SET quantidade_estoque = quantidade_estoque + NEW.quantidade
        WHERE id = NEW.produto_id;
    ELSE
        UPDATE produtos SET quantidade_estoque = quantidade_estoque - NEW.quantidade
        WHERE id = NEW.produto_id;
    END IF;
END;
//
DELIMITER ;

-- View para relatório de produtos com baixo estoque
CREATE VIEW produtos_baixo_estoque AS
SELECT p.id, p.nome, p.quantidade_estoque, c.nome AS categoria
FROM produtos p
JOIN categorias c ON p.categoria_id = c.id
WHERE p.quantidade_estoque < 10;
