CREATE TABLE [dbo].[Compras] (
    [ID_compra]   INT          IDENTITY (1, 1) NOT NULL,
    [NomeProduto] VARCHAR (50) NULL,
    [ID_produto]  VARCHAR (50) NULL,
    [ID_pedido]   INT          NULL,
    [Quantidade]  INT          NULL,
    CONSTRAINT [PK__Compras__50078BB156E59BD2] PRIMARY KEY CLUSTERED ([ID_compra] ASC),
    CONSTRAINT [FK_Compras_Pedido] FOREIGN KEY ([ID_pedido]) REFERENCES [dbo].[pedido] ([ID_pedido]),
    CONSTRAINT [FK_Compras_Produto] FOREIGN KEY ([ID_produto]) REFERENCES [dbo].[produto] ([sku])
);


GO
ALTER TABLE [dbo].[Compras] NOCHECK CONSTRAINT [FK_Compras_Pedido];


GO
ALTER TABLE [dbo].[Compras] NOCHECK CONSTRAINT [FK_Compras_Produto];



