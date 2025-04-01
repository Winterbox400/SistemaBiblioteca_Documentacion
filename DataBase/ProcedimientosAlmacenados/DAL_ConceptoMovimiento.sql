/*Procedimiento Almacenados Libros*/

/*Referencia de Tabla Libros*/
--CREATE TABLE ConceptoMovimientos(
--	IdConceptoMovimiento INT PRIMARY KEY IDENTITY,
--	Concepto VARCHAR(50) NOT NULL,
--	Activo BIT DEFAULT 1 NOT NULL
--)
--GO

USE BD_ControlBiblioteca
GO

/*Insertar un nuevo Concepto de Movimiento*/
CREATE PROCEDURE InsertConceptoMovimiento
@Concepto VARCHAR(50)
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY
		BEGIN TRANSACTION;
			INSERT INTO ConceptoMovimientos(Concepto)
				VALUES(@Concepto)
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

/*Cambiar un Concepto de Movimiento*/
CREATE PROCEDURE UpdateConceptoMovimiento
@IdConcepto INT,
@Concepto VARCHAR(50)
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY
		BEGIN TRANSACTION;
			UPDATE ConceptoMovimientos
				SET Concepto = @Concepto
				WHERE IdConceptoMovimiento = @IdConcepto AND Activo = 1
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

/*Eliminar un Concepto de Movimiento*/
CREATE PROCEDURE DeleteConceptoMovimiento
@IdConcepto INT
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY
		BEGIN TRANSACTION;
			UPDATE ConceptoMovimientos
				SET Activo = 0
				WHERE IdConceptoMovimiento = @IdConcepto AND Activo = 1
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