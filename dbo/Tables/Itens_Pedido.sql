CREATE TABLE [dbo].[Itens_Pedido] (
    [ID_pedido]  INT          NULL,
    [sku]        VARCHAR (50) NULL,
    [Quantidade] INT          NULL,
    CONSTRAINT [FK__Itens_Ped__ID_pe__7B5B524B] FOREIGN KEY ([ID_pedido]) REFERENCES [dbo].[pedido] ([ID_pedido]),
    CONSTRAINT [FK_ProdutoSku] FOREIGN KEY ([sku]) REFERENCES [dbo].[produto] ([sku])
);


GO
ALTER TABLE [dbo].[Itens_Pedido] NOCHECK CONSTRAINT [FK__Itens_Ped__ID_pe__7B5B524B];


GO
ALTER TABLE [dbo].[Itens_Pedido] NOCHECK CONSTRAINT [FK_ProdutoSku];







