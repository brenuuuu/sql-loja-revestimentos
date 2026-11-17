-- =====================================================================
-- Loja de Revestimentos - Criação das tabelas (PostgreSQL)
-- Autor: Breno Oliveira
-- =====================================================================

DROP SCHEMA IF EXISTS loja CASCADE;
CREATE SCHEMA loja;
SET search_path TO loja;

CREATE TABLE categoria (
    id      SERIAL PRIMARY KEY,
    nome    VARCHAR(60) NOT NULL UNIQUE
);

CREATE TABLE fornecedor (
    id      SERIAL PRIMARY KEY,
    nome    VARCHAR(120) NOT NULL,
    cnpj    CHAR(14) NOT NULL UNIQUE,
    cidade  VARCHAR(80),
    uf      CHAR(2)
);

CREATE TABLE produto (
    id              SERIAL PRIMARY KEY,
    nome            VARCHAR(120) NOT NULL,
    categoria_id    INT NOT NULL REFERENCES categoria(id),
    fornecedor_id   INT NOT NULL REFERENCES fornecedor(id),
    unidade         VARCHAR(5) NOT NULL DEFAULT 'm2' CHECK (unidade IN ('m2', 'un', 'ml')),
    preco_custo     NUMERIC(10,2) NOT NULL CHECK (preco_custo > 0),
    preco_venda     NUMERIC(10,2) NOT NULL CHECK (preco_venda > 0),
    estoque         NUMERIC(10,2) NOT NULL DEFAULT 0 CHECK (estoque >= 0),
    estoque_minimo  NUMERIC(10,2) NOT NULL DEFAULT 0,
    ativo           BOOLEAN NOT NULL DEFAULT TRUE,
    CONSTRAINT preco_venda_maior_que_custo CHECK (preco_venda >= preco_custo)
);

CREATE TABLE cliente (
    id          SERIAL PRIMARY KEY,
    nome        VARCHAR(120) NOT NULL,
    tipo        CHAR(2) NOT NULL CHECK (tipo IN ('PF', 'PJ')),
    documento   VARCHAR(14) NOT NULL UNIQUE,   -- CPF ou CNPJ, só números
    email       VARCHAR(120),
    cidade      VARCHAR(80),
    uf          CHAR(2),
    criado_em   DATE NOT NULL DEFAULT CURRENT_DATE
);

CREATE TABLE vendedor (
    id          SERIAL PRIMARY KEY,
    nome        VARCHAR(80) NOT NULL,
    comissao    NUMERIC(4,2) NOT NULL DEFAULT 2.00   -- percentual
);

CREATE TABLE pedido (
    id              SERIAL PRIMARY KEY,
    cliente_id      INT NOT NULL REFERENCES cliente(id),
    vendedor_id     INT NOT NULL REFERENCES vendedor(id),
    data_pedido     DATE NOT NULL,
    status          VARCHAR(12) NOT NULL DEFAULT 'ABERTO'
                    CHECK (status IN ('ABERTO', 'FATURADO', 'ENTREGUE', 'CANCELADO')),
    desconto        NUMERIC(10,2) NOT NULL DEFAULT 0 CHECK (desconto >= 0)
);

CREATE TABLE item_pedido (
    pedido_id       INT NOT NULL REFERENCES pedido(id) ON DELETE CASCADE,
    produto_id      INT NOT NULL REFERENCES produto(id),
    quantidade      NUMERIC(10,2) NOT NULL CHECK (quantidade > 0),
    preco_unitario  NUMERIC(10,2) NOT NULL CHECK (preco_unitario > 0),
    PRIMARY KEY (pedido_id, produto_id)
);

-- Contas a receber: cada pedido pode ser dividido em parcelas
CREATE TABLE parcela (
    id              SERIAL PRIMARY KEY,
    pedido_id       INT NOT NULL REFERENCES pedido(id) ON DELETE CASCADE,
    numero          SMALLINT NOT NULL,
    valor           NUMERIC(10,2) NOT NULL CHECK (valor > 0),
    vencimento      DATE NOT NULL,
    data_pagamento  DATE,
    forma           VARCHAR(10) NOT NULL CHECK (forma IN ('PIX', 'BOLETO', 'CARTAO', 'DINHEIRO')),
    UNIQUE (pedido_id, numero)
);

-- Índices para deixar as consultas por data e por cliente mais rápidas
CREATE INDEX idx_pedido_data    ON pedido (data_pedido);
CREATE INDEX idx_pedido_cliente ON pedido (cliente_id);
