/*Procedimiento Almacenados Libros*/

/*Referencia de Tabla Libros*/
--CREATE TABLE Movimientos(
--	IdMovimiento INT PRIMARY KEY IDENTITY,
--	IdTipoMovimiento INT FOREIGN KEY REFERENCES TipoMovimientos(IdTipoMovimiento),
--	IdConceptoMovimiento INT FOREIGN KEY REFERENCES ConceptoMovimientos(IdConceptoMovimiento),
--	IdSucursal INT FOREIGN KEY REFERENCES Sucursales(IdSucursal),
--	Activo BIT DEFAULT 1 NOT NULL,
--	IdUsuarioRegistra INT NOT NULL,
--	FechaRegistro DATETIME DEFAULT GETDATE() NOT NULL, --Usar en vista tambien para FechaMovimiento
--	IdUsuarioActualiza INT NULL,
--	FechaActualizacion DATETIME NULL
--)
--GO

USE BD_ControlBiblioteca
GO

/*Insertar un nuevo Movimiento*/
CREATE PROCEDURE InsertMovimiento
@IdTipoMovimiento INT,
@IdConceptoMovimiento INT,
@IdSucursal INT,
@IdUsuarioRegistra INT
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY
		BEGIN TRANSACTION;
			INSERT INTO Movimientos(IdTipoMovimiento, IdConceptoMovimiento, IdSucursal, IdUsuarioRegistra)
				VALUES(@IdTipoMovimiento, @IdConceptoMovimiento, @IdSucursal, @IdUsuarioRegistra)
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

/*Cambiar un Movimiento*/
CREATE PROCEDURE UpdateMovimiento
@IdMoviemiento INT,
@IdTipoMovimiento INT,
@IdConceptoMovimiento INT,
@IdSucursal INT,
@IdUsuarioActualiza INT
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY
		BEGIN TRANSACTION;
			UPDATE Movimientos
				SET IdTipoMovimiento = @IdTipoMovimiento, IdConceptoMovimiento = @IdConceptoMovimiento,
					IdSucursal = @IdSucursal, IdUsuarioActualiza = @IdUsuarioActualiza
				WHERE IdMovimiento = @IdMoviemiento AND Activo = 1;
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

/*Eliminar un Movimiento*/
CREATE PROCEDURE DeleteMovimiento
@IdMoviemiento INT,
@IdUsuarioActualiza INT
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY
		BEGIN TRANSACTION;
			UPDATE Movimientos
				SET Activo = 0, IdUsuarioActualiza = @IdUsuarioActualiza
				WHERE IdMovimiento = @IdMoviemiento AND Activo = 1;
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