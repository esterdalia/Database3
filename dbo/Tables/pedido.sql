CREATE TABLE [dbo].[pedido] (
    [ID_pedido]   INT             NOT NULL,
    [Data_Pedido] DATE            NULL,
    [email]       VARCHAR (100)   NOT NULL,
    [Tipo_Frete]  VARCHAR (50)    NULL,
    [Valor_Total] DECIMAL (10, 2) NULL,
    PRIMARY KEY CLUSTERED ([ID_pedido] ASC),
    CONSTRAINT [FK__pedido__ID_Clien__4D94879B] FOREIGN KEY ([email]) REFERENCES [dbo].[cliente] ([email])
);


GO
ALTER TABLE [dbo].[pedido] NOCHECK CONSTRAINT [FK__pedido__ID_Clien__4D94879B];









