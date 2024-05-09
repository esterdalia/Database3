/*
Script de implantação para 5SBD

Este código foi gerado por uma ferramenta.
As alterações feitas nesse arquivo poderão causar comportamento incorreto e serão perdidas se
o código for gerado novamente.
*/

GO
SET ANSI_NULLS, ANSI_PADDING, ANSI_WARNINGS, ARITHABORT, CONCAT_NULL_YIELDS_NULL, QUOTED_IDENTIFIER ON;

SET NUMERIC_ROUNDABORT OFF;


GO
:setvar DatabaseName "5SBD"
:setvar DefaultFilePrefix "5SBD"
:setvar DefaultDataPath "C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\"
:setvar DefaultLogPath "C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\"

GO
:on error exit
GO
/*
Detecta o modo SQLCMD e desabilita a execução do script se o modo SQLCMD não tiver suporte.
Para reabilitar o script após habilitar o modo SQLCMD, execute o comando a seguir:
SET NOEXEC OFF; 
*/
:setvar __IsSqlCmdEnabled "True"
GO
IF N'$(__IsSqlCmdEnabled)' NOT LIKE N'True'
    BEGIN
        PRINT N'O modo SQLCMD deve ser habilitado para executar esse script com êxito.';
        SET NOEXEC ON;
    END


GO
USE [$(DatabaseName)];


GO
/*
Ignorando a coluna [dbo].[cliente].[ID_cliente]; poderá ocorrer perda de dados.
*/

IF EXISTS (select top 1 1 from [dbo].[cliente])
    RAISERROR (N'Linhas foram detectadas. A atualização de esquema está sendo encerrada porque pode ocorrer perda de dados.', 16, 127) WITH NOWAIT

GO
/*
A coluna email na tabela [dbo].[pedido] deve ser alterada de NULL para NOT NULL. Se a tabela contiver dados, o script ALTER talvez não funcione. Para evitar o problema, você deve adicionar valores a essa coluna para todas as linhas, marcá-la para permitir valores NULL ou habilitar a geração de padrões inteligentes como uma opção de implantação.
*/

IF EXISTS (select top 1 1 from [dbo].[pedido])
    RAISERROR (N'Linhas foram detectadas. A atualização de esquema está sendo encerrada porque pode ocorrer perda de dados.', 16, 127) WITH NOWAIT

GO
/*
A coluna sku na tabela [dbo].[produto] deve ser alterada de NULL para NOT NULL. Se a tabela contiver dados, o script ALTER talvez não funcione. Para evitar o problema, você deve adicionar valores a essa coluna para todas as linhas, marcá-la para permitir valores NULL ou habilitar a geração de padrões inteligentes como uma opção de implantação.
*/

IF EXISTS (select top 1 1 from [dbo].[produto])
    RAISERROR (N'Linhas foram detectadas. A atualização de esquema está sendo encerrada porque pode ocorrer perda de dados.', 16, 127) WITH NOWAIT

GO
PRINT N'A operação a seguir foi gerada de um arquivo de log de refatoração 560575ff-4846-4323-becb-6931da651277';

PRINT N'Renomear [dbo].[pedido].[ID_Cliente] para email';


GO
EXECUTE sp_rename @objname = N'[dbo].[pedido].[ID_Cliente]', @newname = N'email', @objtype = N'COLUMN';


GO
PRINT N'Removendo Chave Estrangeira [dbo].[FK__pedido__ID_Clien__4D94879B]...';


GO
ALTER TABLE [dbo].[pedido] DROP CONSTRAINT [FK__pedido__ID_Clien__4D94879B];


GO
PRINT N'Removendo Restrição Exclusiva [dbo].[UQ_email]...';


GO
ALTER TABLE [dbo].[cliente] DROP CONSTRAINT [UQ_email];


GO
PRINT N'Iniciando a recompilação da tabela [dbo].[cliente]...';


GO
BEGIN TRANSACTION;

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

SET XACT_ABORT ON;

CREATE TABLE [dbo].[tmp_ms_xx_cliente] (
    [nome]     VARCHAR (50)  NOT NULL,
    [endereco] VARCHAR (80)  NULL,
    [telefone] VARCHAR (35)  NOT NULL,
    [email]    VARCHAR (100) NOT NULL,
    [sexo]     VARCHAR (1)   NULL,
    CONSTRAINT [tmp_ms_xx_constraint_PK__cliente__9BB2655B9B95A2611] PRIMARY KEY CLUSTERED ([email] ASC),
    CONSTRAINT [tmp_ms_xx_constraint_UQ_email1] UNIQUE NONCLUSTERED ([email] ASC)
);

IF EXISTS (SELECT TOP 1 1 
           FROM   [dbo].[cliente])
    BEGIN
        INSERT INTO [dbo].[tmp_ms_xx_cliente] ([email], [nome], [endereco], [telefone], [sexo])
        SELECT   [email],
                 [nome],
                 [endereco],
                 [telefone],
                 [sexo]
        FROM     [dbo].[cliente]
        ORDER BY [email] ASC;
    END

DROP TABLE [dbo].[cliente];

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_cliente]', N'cliente';

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_constraint_PK__cliente__9BB2655B9B95A2611]', N'PK__cliente__9BB2655B9B95A261', N'OBJECT';

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_constraint_UQ_email1]', N'UQ_email', N'OBJECT';

COMMIT TRANSACTION;

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;


GO
PRINT N'Alterando Tabela [dbo].[pedido]...';


GO
ALTER TABLE [dbo].[pedido] ALTER COLUMN [email] VARCHAR (100) NOT NULL;


GO
PRINT N'Alterando Tabela [dbo].[produto]...';


GO
ALTER TABLE [dbo].[produto] ALTER COLUMN [sku] VARCHAR (50) NOT NULL;


GO
PRINT N'Criando Chave Estrangeira [dbo].[FK__pedido__ID_Clien__4D94879B]...';


GO
ALTER TABLE [dbo].[pedido] WITH NOCHECK
    ADD CONSTRAINT [FK__pedido__ID_Clien__4D94879B] FOREIGN KEY ([email]) REFERENCES [dbo].[cliente] ([email]);


GO
PRINT N'Alterando Procedimento [dbo].[ProcessarPedidos]...';


GO
SET ANSI_NULLS, QUOTED_IDENTIFIER OFF;


GO
ALTER PROCEDURE ProcessarPedidos
AS
BEGIN
    SET NOCOUNT ON;

    -- Inserir novos clientes
    INSERT INTO cliente ([nome], [endereco], [telefone], [email], [sexo])
	SELECT DISTINCT cp.buyer_name, CONCAT(cp.ship_address_1, ' ', ISNULL(cp.ship_address_2, ''), ' ', ISNULL(cp.ship_address_3, '')), cp.buyer_phone_number, cp.buyer_email, ''
    FROM CargaPedido cp
    LEFT JOIN cliente c ON cp.buyer_email = c.email
    WHERE c.email IS NULL;
;

    -- Inserir novos produtos
    INSERT INTO produto (ID_produto, nome, descricao, valor, estoque, sku)
    SELECT DISTINCT cp.order_item_id , cp.product_name, '', cp.item_price, 0, cp.sku
    FROM CargaPedido cp
    LEFT JOIN produto pr ON cp.sku = pr.sku
    WHERE pr.ID_produto IS NULL;

    -- Inserir pedidos
    INSERT INTO pedido (ID_pedido, email, Status_Pedido, Tipo_Frete, Valor_Total)
    SELECT DISTINCT cp.order_id,cp.purchase_date, c.email, 'Novo', 'Economico', SUM(cp.item_price * cp.quantity_purchased)
    FROM CargaPedido cp
    INNER JOIN cliente c ON cp.buyer_email = c.email 
    GROUP BY cp.purchase_date, c.email;

    -- Inserir itens de pedido
    INSERT INTO Itens_Pedido (ID_pedido, ID_produto, Quantidade)
    SELECT p.ID_pedido, pr.ID_produto, cp.quantity_purchased
    FROM CargaPedido cp
    INNER JOIN pedido p ON cp.purchase_date = p.Data_Pedido
    INNER JOIN cliente c ON cp.buyer_email = c.email
    INNER JOIN produto pr ON cp.sku = pr.sku;
END;
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON;


GO
-- Etapa de refatoração para atualizar o servidor de destino com logs de transação implantados
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = '560575ff-4846-4323-becb-6931da651277')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('560575ff-4846-4323-becb-6931da651277')

GO

GO
PRINT N'Verificando os dados existentes em restrições recém-criadas';


GO
USE [$(DatabaseName)];


GO
ALTER TABLE [dbo].[pedido] WITH CHECK CHECK CONSTRAINT [FK__pedido__ID_Clien__4D94879B];


GO
PRINT N'Atualização concluída.';


GO
