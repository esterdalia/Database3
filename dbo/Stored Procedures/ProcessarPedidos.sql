CREATE PROCEDURE [dbo].[ProcessarPedidos]
AS
BEGIN
    SET NOCOUNT ON;

    -- Inserir novos clientes
    INSERT INTO cliente (nome, endereco, telefone, email)
	SELECT DISTINCT cp.buyer_name, cp.ship_address_1, cp.buyer_phone_number, cp.buyer_email
    FROM CargaPedido cp 
	WHERE NOT EXISTS (SELECT 1 FROM cliente WHERE cliente.email=cp.buyer_email);
	
;

    ---- Inserir novos produtos
    INSERT INTO produto (nome, valor, estoque, sku)
    SELECT DISTINCT cp.product_name, cp.item_price, 0, cp.sku
    FROM CargaPedido cp
    LEFT JOIN produto pr ON cp.sku = pr.sku
    WHERE pr.sku IS NULL;

    -- Inserir pedidos
	
INSERT INTO pedido (ID_pedido, Data_Pedido, email, Status_Pedido, Tipo_Frete, Valor_Total)
SELECT DISTINCT cp.order_id, cp.purchase_date, c.email, 'Novo', cp.ship_service_level, SUM(cp.item_price * cp.quantity_purchased)
FROM CargaPedido cp
INNER JOIN cliente c ON cp.buyer_email = c.email
WHERE NOT EXISTS (
    SELECT 1 FROM pedido p WHERE p.ID_pedido = cp.order_id
)
GROUP BY cp.order_id, cp.purchase_date,  cp.ship_service_level, c.email;

-- Atualizar tabela Itens_Pedido
INSERT INTO Itens_Pedido (ID_pedido, sku, Quantidade)
SELECT p.ID_pedido, pr.sku, cp.quantity_purchased
FROM CargaPedido cp
INNER JOIN pedido p ON cp.order_id = p.ID_pedido
INNER JOIN produto pr ON cp.sku = pr.sku;

 
 -- Registro de movimentação de estoque e atualização do estoque do produto


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

        -- Atualização do estoque do produto
        UPDATE produto
        SET estoque = estoque - ip.Quantidade
        FROM produto p
        INNER JOIN Itens_Pedido ip ON p.sku = ip.sku
        WHERE ip.ID_pedido = @PedidoID;

        FETCH NEXT FROM PedidosCursor INTO @PedidoID, @ValorTotal;
    END;

    CLOSE PedidosCursor;
    DEALLOCATE PedidosCursor;
END;