-- =====================================================================
-- Consultas de relatorio
-- Cada consulta responde a uma pergunta do dia a dia da loja.
-- =====================================================================
SET search_path TO loja;

-- 1) Quanto a loja faturou em cada mes? (sem contar pedidos cancelados)
SELECT  TO_CHAR(data_pedido, 'YYYY-MM') AS mes,
        COUNT(*)              AS pedidos,
        SUM(total)            AS faturamento,
        ROUND(AVG(total), 2)  AS ticket_medio
FROM vw_pedido_total
WHERE status <> 'CANCELADO'
GROUP BY TO_CHAR(data_pedido, 'YYYY-MM')
ORDER BY mes;

-- 2) Quais sao os 5 produtos que mais venderam (em reais)?
SELECT  pr.nome,
        SUM(i.quantidade)                               AS quantidade,
        ROUND(SUM(i.quantidade * i.preco_unitario), 2)  AS receita
FROM item_pedido i
JOIN produto pr ON pr.id = i.produto_id
JOIN pedido  p  ON p.id  = i.pedido_id
WHERE p.status <> 'CANCELADO'
GROUP BY pr.nome
ORDER BY receita DESC
LIMIT 5;

-- 3) Quanto cada categoria de produto faturou?
SELECT  c.nome AS categoria,
        ROUND(SUM(i.quantidade * i.preco_unitario), 2) AS receita
FROM item_pedido i
JOIN produto   pr ON pr.id = i.produto_id
JOIN categoria c  ON c.id  = pr.categoria_id
JOIN pedido    p  ON p.id  = i.pedido_id
WHERE p.status <> 'CANCELADO'
GROUP BY c.nome
ORDER BY receita DESC;

-- 4) Quanto cada vendedor vendeu e quanto recebe de comissao?
SELECT  v.vendedor,
        COUNT(*)                                     AS pedidos,
        SUM(v.total)                                 AS vendido,
        ROUND(SUM(v.total) * ve.comissao / 100, 2)   AS comissao
FROM vw_pedido_total v
JOIN vendedor ve ON ve.nome = v.vendedor
WHERE v.status <> 'CANCELADO'
GROUP BY v.vendedor, ve.comissao
ORDER BY vendido DESC;

-- 5) Quais clientes estao com parcelas atrasadas?
SELECT  cliente,
        COUNT(*)          AS parcelas_atrasadas,
        SUM(valor)        AS valor_em_atraso,
        MAX(dias_atraso)  AS maior_atraso_dias
FROM vw_contas_a_receber
WHERE situacao = 'ATRASADA'
GROUP BY cliente
ORDER BY valor_em_atraso DESC;

-- 6) Quanto a loja tem para receber nos proximos 90 dias?
SELECT  TO_CHAR(vencimento, 'YYYY-MM') AS mes,
        COUNT(*)   AS parcelas,
        SUM(valor) AS a_receber
FROM vw_contas_a_receber
WHERE vencimento BETWEEN CURRENT_DATE AND CURRENT_DATE + 90
GROUP BY TO_CHAR(vencimento, 'YYYY-MM')
ORDER BY mes;

-- 7) Quais produtos estao com estoque abaixo do minimo?
SELECT  pr.nome,
        f.nome AS fornecedor,
        pr.estoque,
        pr.estoque_minimo
FROM produto pr
JOIN fornecedor f ON f.id = pr.fornecedor_id
WHERE pr.ativo = TRUE
  AND pr.estoque < pr.estoque_minimo;

-- 8) Quais clientes nao compram ha mais de 90 dias (ou nunca compraram)?
SELECT  c.nome,
        c.email,
        MAX(p.data_pedido) AS ultima_compra
FROM cliente c
LEFT JOIN pedido p ON p.cliente_id = c.id AND p.status <> 'CANCELADO'
GROUP BY c.id, c.nome, c.email
HAVING MAX(p.data_pedido) IS NULL
    OR MAX(p.data_pedido) < CURRENT_DATE - 90
ORDER BY ultima_compra;
