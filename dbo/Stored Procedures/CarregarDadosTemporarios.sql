CREATE PROCEDURE [dbo].[CarregarDadosTemporarios]

AS
BEGIN
    SET NOCOUNT ON;

    TRUNCATE TABLE CargaPedido; -- Limpa a tabela temporária antes de carregar os novos dados

    BULK INSERT CargaPedido
    FROM 'C:\Users\ester\source\repos\Database3\arquivosCSV\carga.csv'
    WITH (
        FIELDTERMINATOR = ';', -- Delimitador de campo do arquivo CSV
        ROWTERMINATOR = '\n',-- Delimitador de linha do arquivo CSV
        FIRSTROW = 2 -- Pular a primeira linha q é o cabeçalho
    );
END;
