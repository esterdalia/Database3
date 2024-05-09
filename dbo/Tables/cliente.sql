CREATE TABLE [dbo].[cliente] (
    [nome]     VARCHAR (50)  NOT NULL,
    [endereco] VARCHAR (80)  NULL,
    [telefone] VARCHAR (35)  NOT NULL,
    [email]    VARCHAR (100) NOT NULL,
    CONSTRAINT [PK__cliente__9BB2655B9B95A261] PRIMARY KEY CLUSTERED ([email] ASC),
    CONSTRAINT [UQ_email] UNIQUE NONCLUSTERED ([email] ASC)
);







