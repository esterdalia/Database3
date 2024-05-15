
CREATE PROCEDURE [dbo].[MovimentarEstoque]
	-- Registro de movimentação de estoque e atualização do estoque do produto
	AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @PedidoID INT;
    DECLARE @ValorTotal DECIMAL(10, 2);
	-- Declaração de duas variáveis para armazenar o ID do pedido e o valor total do pedido.


    DECLARE PedidosCursor CURSOR FOR
    SELECT ID_pedido, Valor_Total FROM pedido ORDER BY Valor_Total DESC;
	-- Declaração de um cursor que seleciona o ID do pedido e o valor total de todos os pedidos ordenados pelo valor total em ordem decrescente.


    OPEN PedidosCursor;
    FETCH NEXT FROM PedidosCursor INTO @PedidoID, @ValorTotal;
	-- Captura do primeiro registro do cursor e atribuição dos valores do ID do pedido e do valor total às variáveis declaradas.


    WHILE @@FETCH_STATUS = 0 -- Loop enquanto houver registros no cursor.
    BEGIN
        -- Registro de movimentação de estoque
        INSERT INTO movimentacao_estoque (sku_produto, DataMovimentacao, Quantidade, TipoMovimentacao, ID_pedido)
        SELECT  ip.sku, GETDATE(), ip.Quantidade, 'saída', ip.ID_pedido
        FROM Itens_Pedido ip
        WHERE ip.ID_pedido = @PedidoID;

        

    -- Registrar em compras pedidos nao atendidos devido a quantidade de produto insuficiente no estoque
    INSERT INTO Compras (ID_pedido, NomeProduto, ID_produto, Quantidade)
    SELECT 
		p.ID_pedido, 
		pr.nome AS nomeProduto,
		ip.sku AS ID_produto,
		ISNULL(SUM(me.Quantidade), 0 )- pr.estoque  AS Quantidade
   
   FROM pedido p
    INNER JOIN Itens_Pedido ip ON p.ID_pedido = ip.ID_pedido
    LEFT JOIN movimentacao_estoque me ON ip.ID_pedido = me.ID_pedido AND ip.sku = me.sku_produto
    INNER JOIN produto pr ON ip.sku = pr.sku
    GROUP BY p.ID_pedido, pr.nome, ip.sku, pr.estoque
    HAVING SUM(ISNULL(me.Quantidade, 0)) > pr.estoque;


    -- Limpar registros de movimentação de estoque para pedidos não atendidos
    DELETE FROM movimentacao_estoque
    WHERE TipoMovimentacao = 'Saída' AND ID_pedido IN (SELECT ID_pedido FROM Compras);

     
	 -- Atualizar estoque para pedidos atendidos
    UPDATE produto
    SET estoque = estoque - me.Quantidade
    FROM movimentacao_estoque me
    INNER JOIN produto pr ON me.sku_produto = pr.sku
    WHERE me.TipoMovimentacao = 'Saída' AND pr.estoque >= me.Quantidade;
	 
	 FETCH NEXT FROM PedidosCursor INTO @PedidoID, @ValorTotal;
   END;
    CLOSE PedidosCursor;
    DEALLOCATE PedidosCursor;
	END;