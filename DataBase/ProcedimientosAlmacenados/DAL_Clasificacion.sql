/*Procedimiento Almacenados Clasificaciones*/

/*Referencia de Tabla Clasificaciones*/
--CREATE TABLE Clasificaciones(
--	IdClasificacion INT PRIMARY KEY IDENTITY,
--	Clasificacion VARCHAR(50) NOT NULL,
--	Activo BIT NOT NULL DEFAULT 1
--)
--GO

USE BD_ControlBiblioteca
GO

/*Insertar una nueva Clasificacion*/
CREATE PROCEDURE InsertClasificacion
@Clasificacion VARCHAR(50)
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY
		BEGIN TRANSACTION;
			INSERT INTO Clasificaciones(Clasificacion)
				VALUES(@Clasificacion)
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

/*Cambiar una Clasificación*/
CREATE PROCEDURE UpdateClasificacion
@Clasificacion VARCHAR(50),
@IdClasificacion INT
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY
		BEGIN TRANSACTION;
			UPDATE Clasificaciones
			SET Clasificacion = @Clasificacion
			WHERE IdClasificacion = @IdClasificacion AND Activo = 1;
		COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH
		PRINT ERROR_MESSAGE();
		
		IF XACT_STATE() = 1
		BEGIN
			ROLLBACK TRANSACTION
		END
		ELSE IF XACT_STATE() = -1
		BEGIN
			ROLLBACK TRANSACTION
		END;
		THROW
	END CATCH
END
GO

/*Eliminar una Calificación*/
CREATE PROCEDURE DeleteClasificacion
@IdClasificacion INT
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY
		BEGIN TRANSACTION;
			UPDATE Clasificaciones
			SET Activo = 0
			WHERE IdClasificacion = @IdClasificacion AND Activo = 1;
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