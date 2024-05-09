USE [5SBD]
GO

DECLARE	@return_value Int

EXEC	@return_value = [dbo].[ProcessarPedidos]

SELECT	@return_value as 'Return Value'

GO
