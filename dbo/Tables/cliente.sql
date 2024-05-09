CREATE TABLE [dbo].[cliente] (
    [ID_cliente] INT          NOT NULL,
    [nome]       VARCHAR (50) NOT NULL,
    [endereco]   VARCHAR (80) NOT NULL,
    [telefone]   VARCHAR (35) NOT NULL,
    [email]      VARCHAR (40) NOT NULL,
    [sexo]       VARCHAR (1)  NOT NULL,
    CONSTRAINT [PK__cliente__9BB2655B9B95A261] PRIMARY KEY CLUSTERED ([ID_cliente] ASC),
    CONSTRAINT [UQ_email] UNIQUE NONCLUSTERED ([email] ASC)
);

