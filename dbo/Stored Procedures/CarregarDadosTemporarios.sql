CREATE PROCEDURE CarregarDadosTemporarios

AS
BEGIN
    SET NOCOUNT ON;

    TRUNCATE TABLE CargaPedido; -- Limpa a tabela temporária antes de carregar os novos dados

    BULK INSERT CargaPedido
    FROM 'C:\Users\ester\OneDrive\Documentos\MATERIAS FAETERJ\5SBD\FTP\Amazon\arquivo.csv'
    WITH (
        FIELDTERMINATOR = ';',
        ROWTERMINATOR = '\n',
        FIRSTROW = 2 -- Pular a primeira linha se for cabeçalho
    );
END;
