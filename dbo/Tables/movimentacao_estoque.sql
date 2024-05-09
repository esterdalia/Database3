CREATE TABLE [dbo].[movimentacao_estoque] (
    [ID_movimentacao]  INT          NOT NULL,
    [ID_produto]       INT          NULL,
    [DataMovimentacao] DATETIME     NULL,
    [Quantidade]       INT          NULL,
    [TipoMovimentacao] VARCHAR (20) NULL,
    PRIMARY KEY CLUSTERED ([ID_movimentacao] ASC)
);





