/*Procedimiento Almacenados Sucursales*/

/*Referencia de Tabla Sucursales*/
--CREATE TABLE Sucursales(
--	IdSucursal INT PRIMARY KEY IDENTITY,
--	Nombre VARCHAR(50) NOT NULL,
--	Activo BIT NOT NULL DEFAULT 1
--)
--GO

USE BD_ControlBiblioteca
GO

/*Insertar una nueva Sucursal*/
CREATE PROCEDURE InsertSucursal
@Nombre VARCHAR(50),
@IdUsuariosRegistro INT
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY
		BEGIN TRANSACTION;
			DECLARE @BatchSize INT = 1000;--Tamaño de los bath por iteración
			DECLARE @Offset INT = 0;--Inicio de los registros a insertar

			INSERT INTO Sucursales(Nombre)
				VALUES(@Nombre)

			DECLARE @IdSucursal INT = SCOPE_IDENTITY();

			WHILE(1 = 1)
			BEGIN
				INSERT INTO AlmacenLibros(IdLibro, IdSucursal, IdUsuarioRegistra)
					SELECT IdLibro, @IdSucursal, @IdUsuariosRegistro
					FROM Libros
					ORDER BY IdLibro
					OFFSET @Offset ROWS FETCH NEXT @BatchSize ROWS ONLY;

					IF @@ROWCOUNT = 0 BREAK;

					SET @Offset = @Offset +	@BatchSize;
			END
		COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH
		PRINT ERROR_MESSAGE();

		IF XACT_STATE() = 1
		BEGIN
			ROLLBACK TRANSACTION;
		END
		ELSE IF XACT_STATE() = -1
		BEGIN
			ROLLBACK TRANSACTION;
		END;
		THROW
	END CATCH
END
GO

/*Cambiar una Sucursal*/
CREATE PROCEDURE UpdateSucursal
@Nombre VARCHAR(50),
@IdSucursal INT
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY
		BEGIN TRANSACTION;
			UPDATE Sucursales
				SET Nombre = @Nombre
				WHERE IdSucursal = @IdSucursal AND Activo = 1;
		COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH
		PRINT ERROR_MESSAGE();

		IF XACT_STATE() = 1
		BEGIN
			ROLLBACK TRANSACTION;
		END
		ELSE IF XACT_STATE() = -1
		BEGIN
			ROLLBACK TRANSACTION;
		END;
		THROW
	END CATCH
END
GO

/*Eliminar una Sucursal*/
CREATE PROCEDURE DeleteSucursal
@IdSucursal INT,
@IdUsuarioActualiza INT
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY
		BEGIN TRANSACTION;
			UPDATE Sucursales
				SET Activo = 0
				WHERE IdSucursal = @IdSucursal AND Activo = 1;

			UPDATE AlmacenLibros
				SET Activo = 0, IdUsuarioActualiza = @IdUsuarioActualiza, FechaActualizacion = GETDATE()
				WHERE IdSucursal = @IdSucursal AND Activo = 1;
		COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH
		PRINT ERROR_MESSAGE();

		IF XACT_STATE() = 1
		BEGIN
			ROLLBACK TRANSACTION;
		END
		ELSE IF XACT_STATE() = -1
		BEGIN
			ROLLBACK TRANSACTION;
		END;
		THROW
	END CATCH
END
GO