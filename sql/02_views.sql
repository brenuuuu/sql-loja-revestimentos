-- =====================================================================
-- Views (consultas salvas que uso nos relatorios)
-- =====================================================================
SET search_path TO loja;

-- Total de cada pedido ja com desconto
CREATE OR REPLACE VIEW vw_pedido_total AS
SELECT  p.id                                    AS pedido_id,
        p.data_pedido,
        p.status,
        c.nome                                  AS cliente,
        v.nome                                  AS vendedor,
        ROUND(SUM(i.quantidade * i.preco_unitario), 2) AS subtotal,
        p.desconto,
        ROUND(SUM(i.quantidade * i.preco_unitario) - p.desconto, 2) AS total
FROM pedido p
JOIN cliente     c ON c.id = p.cliente_id
JOIN vendedor    v ON v.id = p.vendedor_id
JOIN item_pedido i ON i.pedido_id = p.id
GROUP BY p.id, c.nome, v.nome;

-- Parcelas em aberto com dias de atraso
CREATE OR REPLACE VIEW vw_contas_a_receber AS
SELECT  pa.id,
        pa.pedido_id,
        c.nome                          AS cliente,
        pa.numero,
        pa.valor,
        pa.vencimento,
        GREATEST(CURRENT_DATE - pa.vencimento, 0) AS dias_atraso,
        CASE WHEN pa.vencimento < CURRENT_DATE THEN 'ATRASADA' ELSE 'A VENCER' END AS situacao
FROM parcela pa
JOIN pedido  p ON p.id = pa.pedido_id
JOIN cliente c ON c.id = p.cliente_id
WHERE pa.data_pagamento IS NULL
  AND p.status <> 'CANCELADO';
