CREATE PROCEDURE [dbo].[ProcessarPedidos]
AS
BEGIN
    SET NOCOUNT ON;

    -- Inserir novos clientes
    INSERT INTO cliente (nome, endereco, telefone, email)
	SELECT DISTINCT cp.buyer_name, cp.ship_address_1, cp.buyer_phone_number, cp.buyer_email
    FROM CargaPedido cp 
	WHERE NOT EXISTS (SELECT 1 FROM cliente WHERE cliente.email=cp.buyer_email);
	

    ---- Inserir novos produtos
    INSERT INTO produto (nome, valor, estoque, sku, moeda)
    SELECT DISTINCT cp.product_name, cp.item_price, 0, cp.sku, cp.currency
    FROM CargaPedido cp
    LEFT JOIN produto pr ON cp.sku = pr.sku
    WHERE pr.sku IS NULL;


    -- Inserir pedidos
	INSERT INTO pedido (ID_pedido, Data_Pedido, email, Tipo_Frete, Valor_Total)
	SELECT DISTINCT cp.order_id, cp.purchase_date, c.email, cp.ship_service_level, SUM(cp.item_price * cp.quantity_purchased)
	FROM CargaPedido cp
	INNER JOIN cliente c ON cp.buyer_email = c.email
	WHERE NOT EXISTS (
    SELECT 1 FROM pedido p WHERE p.ID_pedido = cp.order_id
)
	GROUP BY cp.order_id, cp.purchase_date,  cp.ship_service_level, c.email;


	--Atualizar tabela Itens_Pedido
	INSERT INTO Itens_Pedido (ID_pedido, sku, Quantidade)
	SELECT p.ID_pedido, pr.sku, cp.quantity_purchased
	FROM CargaPedido cp
	INNER JOIN pedido p ON cp.order_id = p.ID_pedido
	INNER JOIN produto pr ON cp.sku = pr.sku;

 
 END;