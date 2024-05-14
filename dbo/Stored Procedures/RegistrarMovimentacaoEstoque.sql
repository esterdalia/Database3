CREATE PROCEDURE RegistrarMovimentacaoEstoque
AS
BEGIN
    SET NOCOUNT ON;

    -- Atualizar estoque para pedidos atendidos
    UPDATE produto
    SET estoque = estoque - me.Quantidade
    FROM movimentacao_estoque me
    INNER JOIN produto pr ON me.sku_produto = pr.sku
    WHERE me.TipoMovimentacao = 'Saída' AND pr.estoque >= me.Quantidade;

    -- Registrar compras para pedidos parcialmente atendidos
    INSERT INTO Compras (ID_pedido, ID_produto, Quantidade)
    SELECT p.ID_pedido, ip.sku, ip.Quantidade - ISNULL(SUM(me.Quantidade), 0) AS Quantidade_Comprada
    FROM pedido p
    INNER JOIN Itens_Pedido ip ON p.ID_pedido = ip.ID_pedido
    LEFT JOIN movimentacao_estoque me ON ip.ID_pedido = me.ID_pedido AND ip.sku = me.sku_produto
    GROUP BY p.ID_pedido, ip.sku, ip.Quantidade
    HAVING SUM(me.Quantidade) < ip.Quantidade;

    -- Atualizar estoque para produtos comprados
    UPDATE produto
    SET estoque = estoque + c.Quantidade
    FROM Compras c
    INNER JOIN produto pr ON c.ID_produto = pr.sku;

    -- Limpar registros de movimentação de estoque para pedidos atendidos
    DELETE FROM movimentacao_estoque
    WHERE TipoMovimentacao = 'Saída' AND ID_pedido IN (SELECT ID_pedido FROM Compras);
END;