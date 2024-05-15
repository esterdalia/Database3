CREATE TABLE [dbo].[movimentacao_estoque] (
    [sku_produto]      VARCHAR (50) NULL,
    [DataMovimentacao] DATETIME     NULL,
    [Quantidade]       INT          NULL,
    [TipoMovimentacao] VARCHAR (20) NULL,
    [ID_movimentacao]  INT          IDENTITY (1, 1) NOT NULL,
    [ID_pedido]        INT          NULL,
    PRIMARY KEY CLUSTERED ([ID_movimentacao] ASC)
);









