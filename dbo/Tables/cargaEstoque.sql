CREATE TABLE [dbo].[cargaEstoque] (
    [Nome_Produto] VARCHAR (50)    NOT NULL,
    [Valor]        DECIMAL (10, 2) NOT NULL,
    [Estoque]      INT             NOT NULL,
    [SKU]          VARCHAR (50)    NOT NULL,
    [Moeda]        VARCHAR (50)    NOT NULL
);

