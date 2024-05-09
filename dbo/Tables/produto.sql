CREATE TABLE [dbo].[produto] (
    [ID_produto] INT             NOT NULL,
    [nome]       VARCHAR (50)    NULL,
    [descricao]  VARCHAR (80)    NULL,
    [valor]      DECIMAL (10, 2) NULL,
    [estoque]    INT             NULL,
    CONSTRAINT [PK__produto__FD71723BEFCD1F55] PRIMARY KEY CLUSTERED ([ID_produto] ASC),
    CONSTRAINT [CHK_estoque_nao_negativo] CHECK ([estoque]>=(0))
);


GO
CREATE NONCLUSTERED INDEX [idx_nome_produto]
    ON [dbo].[produto]([nome] ASC);

