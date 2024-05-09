CREATE TABLE [dbo].[Itens_Pedido] (
    [ID_item]    INT NOT NULL,
    [ID_pedido]  INT NULL,
    [ID_produto] INT NULL,
    [Quantidade] INT NULL,
    PRIMARY KEY CLUSTERED ([ID_item] ASC),
    FOREIGN KEY ([ID_pedido]) REFERENCES [dbo].[pedido] ([ID_pedido]),
    CONSTRAINT [FK__Itens_Ped__ID_pr__5165187F] FOREIGN KEY ([ID_produto]) REFERENCES [dbo].[produto] ([ID_produto])
);

