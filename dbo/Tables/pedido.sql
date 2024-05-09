CREATE TABLE [dbo].[pedido] (
    [ID_pedido]     INT             NOT NULL,
    [Data_Pedido]   DATE            NULL,
    [ID_Cliente]    INT             NULL,
    [Status_Pedido] VARCHAR (20)    NULL,
    [Tipo_Frete]    VARCHAR (50)    CONSTRAINT [DF_pedido_Tipo_Frete] DEFAULT ('Economico') NULL,
    [Valor_Total]   DECIMAL (10, 2) NULL,
    PRIMARY KEY CLUSTERED ([ID_pedido] ASC),
    CONSTRAINT [FK__pedido__ID_Clien__4D94879B] FOREIGN KEY ([ID_Cliente]) REFERENCES [dbo].[cliente] ([ID_cliente])
);

