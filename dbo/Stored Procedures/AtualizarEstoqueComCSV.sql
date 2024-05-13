CREATE PROCEDURE AtualizarEstoqueComCSV
AS
BEGIN
    SET NOCOUNT ON;

    -- Ler arquivo CSV e atualizar estoque
    BULK INSERT produto
    FROM 'C:\Users\ester\source\repos\Database3\arquivosCSV\controleEstoque.csv'
    WITH (
        FIELDTERMINATOR = ',',  -- Delimitador de campo do arquivo CSV
        ROWTERMINATOR = '\n',   -- Delimitador de linha do arquivo CSV
        FIRSTROW = 2            -- Pular a primeira linha que é o cabeçalho
    );
END;