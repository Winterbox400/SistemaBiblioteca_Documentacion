/*Procedimiento Almacenados UsuarioSucursal*/

/*Referencia de Tabla UsuarioSucursal*/
--CREATE TABLE UsuariosSucursales(
--	IdUsuarioSucursal INT PRIMARY KEY IDENTITY,
--	IdUsuario INT FOREIGN KEY REFERENCES Usuarios(IdUsuario),
--	IdSucursal INT FOREIGN KEY REFERENCES Sucursales(IdSucursal),
--	Activo BIT NOT NULL DEFAULT 1
--)
--GO

USE BD_ControlBiblioteca
GO

CREATE PROCEDURE AgregarSucursalUsuario
@IdUsuario INT,
@IdSucursal INT
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY
		BEGIN TRANSACTION;
			IF EXISTS(SELECT 1 FROM UsuariosSucursales
						WHERE IdUsuario = @IdUsuario AND IdSucursal = @IdSucursal AND Activo = 0)
			BEGIN
				UPDATE UsuariosSucursales
					SET Activo = 1
					WHERE IdUsuario = @IdUsuario AND IdSucursal = @IdSucursal;
			END
			ELSE
			BEGIN
				INSERT INTO UsuariosSucursales(IdUsuario, IdSucursal)
					VALUES(@IdUsuario, @IdSucursal)
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

CREATE PROCEDURE QuitarSucursalUsuario
@IdUsuario INT,
@IdSucursal INT
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY
		BEGIN TRANSACTION;
			IF EXISTS(SELECT 1 FROM UsuariosSucursales
						WHERE IdUsuario = @IdUsuario AND IdSucursal = @IdSucursal AND Activo = 1)
			BEGIN
				UPDATE UsuariosSucursales
					SET Activo = 0
					WHERE IdUsuario = @IdUsuario AND IdSucursal = @IdSucursal
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
			ROLLBACK TRANSACTION
		END;
		THROW
	END CATCH
END
GO
		
				
				