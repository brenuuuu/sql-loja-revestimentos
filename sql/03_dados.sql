-- =====================================================================
-- Dados de exemplo (ficticios)
-- =====================================================================
SET search_path TO loja;

INSERT INTO categoria (nome) VALUES
  ('Porcelanatos'), ('Pedras naturais'), ('Marmores'), ('Revestimentos de parede'), ('Argamassas e rejuntes');

INSERT INTO fornecedor (nome, cnpj, cidade, uf) VALUES
  ('Ceramica Horizonte',      '11222333000101', 'Criciuma',          'SC'),
  ('Pedreira Serra Azul',     '22333444000102', 'Cachoeiro de Itapemirim', 'ES'),
  ('Marmoraria Bela Vista',   '33444555000103', 'Sao Paulo',         'SP'),
  ('Quimica Forte Argamassas','44555666000104', 'Jundiai',           'SP');

INSERT INTO produto (nome, categoria_id, fornecedor_id, unidade, preco_custo, preco_venda, estoque, estoque_minimo) VALUES
  ('Porcelanato Acetinado 90x90 Off White', 1, 1, 'm2',  72.00, 129.90, 800, 150),
  ('Porcelanato Polido 120x120 Calacata',   1, 1, 'm2', 118.00, 219.90, 420, 100),
  ('Porcelanato Madeira 20x120 Carvalho',   1, 1, 'm2',  65.00, 109.90, 600, 120),
  ('Pedra Miracema Serrada',                2, 2, 'm2',  38.00,  79.90, 500, 100),
  ('Pedra Sao Tome Branca',                 2, 2, 'm2',  55.00, 119.90, 300,  80),
  ('Granito Preto Sao Gabriel',             2, 2, 'm2', 210.00, 389.00, 150,  40),
  ('Marmore Travertino Romano',             3, 3, 'm2', 340.00, 620.00,  90,  30),
  ('Marmore Branco Pigues',                 3, 3, 'm2', 290.00, 540.00,  70,  25),
  ('Revestimento 3D Ondas 30x60',           4, 1, 'm2',  48.00,  94.90, 260,  60),
  ('Pastilha de Vidro Azul 30x30',          4, 1, 'm2',  70.00, 139.90, 110,  40),
  ('Argamassa AC-III 20kg',                 5, 4, 'un',  24.00,  42.90, 900, 200),
  ('Rejunte Epoxi 1kg Cinza',               5, 4, 'un',  31.00,  59.90, 140, 150);   -- ja abaixo do minimo

INSERT INTO cliente (nome, tipo, documento, email, cidade, uf, criado_em) VALUES
  ('Construtora Alfa Ltda',   'PJ', '55666777000105', 'compras@alfa.com.br',  'Sao Paulo', 'SP', '2026-01-10'),
  ('Joana Martins',           'PF', '12345678901',    'joana@email.com',      'Santo Andre','SP', '2026-02-03'),
  ('Arq. Paulo Lima Studio',  'PJ', '66777888000106', 'paulo@limastudio.com', 'Sao Paulo', 'SP', '2026-02-20'),
  ('Ricardo Gomes',           'PF', '23456789012',    'ricardo@email.com',    'Osasco',    'SP', '2026-03-15'),
  ('Incorporadora Prisma',    'PJ', '77888999000107', 'obras@prisma.com.br',  'Barueri',   'SP', '2026-04-01'),
  ('Fernanda Rocha',          'PF', '34567890123',    'fe.rocha@email.com',   'Sao Paulo', 'SP', '2026-05-12'),
  ('Hotel Mirante',           'PJ', '88999000000108', 'manutencao@mirante.com','Guaruja',  'SP', '2026-06-08'),
  ('Lucas Andrade',           'PF', '45678901234',    'lucas.a@email.com',    'Guarulhos', 'SP', '2026-07-21');

INSERT INTO vendedor (nome, comissao) VALUES
  ('Ana Paula', 2.50), ('Marcos', 2.00), ('Beatriz', 3.00);

-- Pedidos de junho a novembro/2026
INSERT INTO pedido (cliente_id, vendedor_id, data_pedido, status, desconto) VALUES
  (1, 1, '2026-06-05', 'ENTREGUE',  500.00),   -- 1
  (2, 2, '2026-06-18', 'ENTREGUE',    0.00),   -- 2
  (3, 3, '2026-07-02', 'ENTREGUE',  300.00),   -- 3
  (1, 1, '2026-07-22', 'ENTREGUE', 1200.00),   -- 4
  (4, 2, '2026-08-09', 'ENTREGUE',    0.00),   -- 5
  (5, 3, '2026-08-27', 'ENTREGUE', 2000.00),   -- 6
  (6, 1, '2026-09-11', 'ENTREGUE',  150.00),   -- 7
  (7, 3, '2026-09-25', 'ENTREGUE', 1500.00),   -- 8
  (3, 2, '2026-10-06', 'FATURADO',    0.00),   -- 9
  (8, 1, '2026-10-19', 'CANCELADO',   0.00),   -- 10
  (5, 3, '2026-10-30', 'FATURADO', 1800.00),   -- 11
  (2, 2, '2026-11-04', 'FATURADO',    0.00),   -- 12
  (1, 1, '2026-11-12', 'ABERTO',    800.00);   -- 13

INSERT INTO item_pedido (pedido_id, produto_id, quantidade, preco_unitario) VALUES
  (1, 1, 120, 129.90), (1, 11, 60, 42.90),
  (2, 3,  35, 109.90), (2, 11, 12, 42.90),
  (3, 7,  18, 620.00), (3, 6,  10, 389.00),
  (4, 2,  90, 219.90), (4, 1,  60, 129.90), (4, 11, 50, 42.90),
  (5, 4,  45,  79.90), (5, 12,  4, 59.90),
  (6, 2,  70, 214.90), (6, 9,  40, 94.90), (6, 11, 70, 42.90),
  (7, 5,  25, 119.90), (7, 10, 8, 139.90),
  (8, 8,  22, 540.00), (8, 6,  18, 389.00),
  (9, 7,  12, 620.00), (9, 5,  30, 119.90),
  (10,3,  20, 109.90),
  (11,1, 150, 125.00), (11,3, 80, 105.00), (11,11, 90, 42.90),
  (12,4,  30,  79.90), (12,10, 6, 139.90),
  (13,2,  60, 219.90), (13,9, 25, 94.90);

-- Parcelas (contas a receber) de cada pedido
INSERT INTO parcela (pedido_id, numero, valor, vencimento, data_pagamento, forma) VALUES
  (1, 1, 8831.00, '2026-07-05', '2026-07-05', 'BOLETO'),
  (1, 2, 8831.00, '2026-08-04', '2026-08-04', 'BOLETO'),
  (2, 1, 4361.30, '2026-07-18', '2026-07-18', 'PIX'),
  (3, 1, 7375.00, '2026-08-01', '2026-08-01', 'BOLETO'),
  (3, 2, 7375.00, '2026-08-31', '2026-08-31', 'BOLETO'),
  (4, 1, 9510.00, '2026-08-21', '2026-08-21', 'BOLETO'),
  (4, 2, 9510.00, '2026-09-20', '2026-09-20', 'BOLETO'),
  (4, 3, 9510.00, '2026-10-20', '2026-10-20', 'BOLETO'),
  (5, 1, 3835.10, '2026-09-08', '2026-09-08', 'PIX'),
  (6, 1, 9921.00, '2026-09-26', NULL, 'BOLETO'),
  (6, 2, 9921.00, '2026-10-26', NULL, 'BOLETO'),
  (7, 1, 3966.70, '2026-10-11', '2026-10-11', 'PIX'),
  (8, 1, 8691.00, '2026-10-25', '2026-10-25', 'BOLETO'),
  (8, 2, 8691.00, '2026-11-24', NULL, 'BOLETO'),
  (9, 1, 5518.50, '2026-11-05', NULL, 'BOLETO'),
  (9, 2, 5518.50, '2026-12-05', NULL, 'BOLETO'),
  (11, 1, 9737.00, '2026-11-29', NULL, 'BOLETO'),
  (11, 2, 9737.00, '2026-12-29', NULL, 'BOLETO'),
  (11, 3, 9737.00, '2027-01-28', NULL, 'BOLETO'),
  (12, 1, 3236.40, '2026-12-04', NULL, 'PIX');
