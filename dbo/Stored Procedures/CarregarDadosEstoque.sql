CREATE PROCEDURE [dbo].[CarregarDadosEstoque]
AS
BEGIN
    SET NOCOUNT ON;

	TRUNCATE TABLE CargaEstoque; -- Limpa a tabela antes de carregar os novos dados
    -- Ler arquivo CSV e carrega os dados pra tabela auxiliar
    BULK INSERT CargaEstoque 
    FROM 'C:\Users\ester\source\repos\Database3\arquivosCSV\controleEstoque.csv'
	  WITH (
        FIELDTERMINATOR = ',', -- Delimitador de campo do arquivo CSV
        ROWTERMINATOR = '\n',-- Delimitador de linha do arquivo CSV
        FIRSTROW = 2 -- Pular a primeira linha q é o cabeçalho
    );

    
	-- Atualizar os dados inseridos com os valores corretos para as colunas da tabela movimentacao_estoque
    INSERT INTO movimentacao_estoque (sku_produto, DataMovimentacao, Quantidade, TipoMovimentacao)
    SELECT cargaEstoque.SKU, GETDATE(), cargaEstoque.Estoque, 'ENTRADA'
    FROM cargaEstoque
 
	 -- Atualizar tabela de produtos com novas entradas
	 MERGE INTO produto AS target
		USING (SELECT Nome_produto,Moeda, Valor, SKU, Estoque FROM cargaEstoque) AS source (Nome_produto, Moeda, Valor, SKU, Estoque)
		ON (target.sku = source.sku)
		WHEN MATCHED THEN
			UPDATE SET target.estoque = target.estoque + source.Estoque
		WHEN NOT MATCHED BY TARGET THEN
			INSERT (nome, moeda, valor, sku, estoque) VALUES (source.Nome_Produto, source.Moeda,source.Valor, source.SKU, source.Estoque);

			
	-- Atualizar tabela de compras com as entradas de produtos
 --   UPDATE Compras
 --   SET Quantidade = Quantidade - ISNULL((SELECT SUM(Estoque) FROM produto
	--WHERE SKU = Compras.ID_produto),0) WHERE ID_produto IN (SELECT SKU FROM CargaEstoque);

	--  Excluir linhas da tabela de compras com quantidade negativa, pois nao há mais necessidade de comprar
 --   DELETE FROM Compras
 --   WHERE quantidade <= 0;
	
	END;