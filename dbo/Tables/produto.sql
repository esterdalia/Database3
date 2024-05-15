CREATE TABLE [dbo].[produto] (
    [nome]    VARCHAR (50)    NULL,
    [valor]   DECIMAL (10, 2) NULL,
    [estoque] INT             NULL,
    [sku]     VARCHAR (50)    NOT NULL,
    [moeda]   VARCHAR (50)    NULL,
    CONSTRAINT [PK_produto] PRIMARY KEY CLUSTERED ([sku] ASC)
);








GO


