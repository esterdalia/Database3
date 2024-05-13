CREATE PROCEDURE RegistrarCompras
AS
BEGIN
    SET NOCOUNT ON;

    -- Inserir na tabela de Compras os pedidos não atendidos em sua totalidade
    INSERT INTO Compras (ID_pedido, ID_produto, Quantidade)
    SELECT p.ID_pedido, ip.sku, ip.Quantidade
    FROM pedido p
    INNER JOIN Itens_Pedido ip ON p.ID_pedido = ip.ID_pedido
    LEFT JOIN movimentacao_estoque me ON ip.ID_pedido = me.ID_pedido
    GROUP BY p.ID_pedido, ip.sku, ip.Quantidade
    HAVING SUM(ISNULL(me.Quantidade, 0)) < ip.Quantidade;
END;