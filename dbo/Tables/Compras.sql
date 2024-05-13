CREATE TABLE [dbo].[Compras] (
    [ID_compra]  INT          IDENTITY (1, 1) NOT NULL,
    [ID_pedido]  INT          NULL,
    [ID_produto] VARCHAR (50) NULL,
    [Quantidade] INT          NULL,
    PRIMARY KEY CLUSTERED ([ID_compra] ASC),
    CONSTRAINT [FK_Compras_Pedido] FOREIGN KEY ([ID_pedido]) REFERENCES [dbo].[pedido] ([ID_pedido]),
    CONSTRAINT [FK_Compras_Produto] FOREIGN KEY ([ID_produto]) REFERENCES [dbo].[produto] ([sku])
);

