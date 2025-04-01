/*Procedimiento Almacenados Usuarios*/

/*Referencia de Tabla Usuarios*/
--CREATE TABLE Usuarios(
--	IdUsuario INT PRIMARY KEY IDENTITY,
--	Nombre VARCHAR(50) NOT NULL,
--	Nametag VARCHAR(15) NOT NULL UNIQUE, --Winterbox400
--	Contrasena VARBINARY(MAX) NOT NULL, --Es porque SHA2_512 genera un Hash de 64 bytes
--	IdRol INT FOREIGN KEY REFERENCES Roles(IdRol),
--	Activo BIT NOT NULL DEFAULT 1,
--	IdUsuarioRegistro INT NOT NULL,
--	FechaRegistro DATETIME DEFAULT GETDATE() NOT NULL,
--	IdUsuarioActualiza INT NULL,
--	FechaActualizacion DATETIME NULL
--)
--GO

USE BD_ControlBiblioteca
GO

/*Insertar un nuevo Usuario*/
CREATE PROCEDURE InsertUsuario--Ya creado
@Nombre VARCHAR(50),
@NameTag VARCHAR(15),
@Contraseña VARBINARY(MAX),
@IdRol INT,
@IdUsuarioRegistro INT
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY
		BEGIN TRANSACTION;
			INSERT INTO Usuarios(Nombre, Nametag, Contrasena, IdRol, IdUsuarioRegistro)
				VALUES(@Nombre, @Nametag, @Contraseña, @IdRol, @IdUsuarioRegistro)
			SELECT SCOPE_IDENTITY();
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

/*Cambiar un Usuario Existente*/
CREATE PROCEDURE UpdateUsuario
@IdUsuario INT,
@Nombe VARCHAR(50),
@Nametag VARCHAR(15),
@Contraseña VARBINARY(MAX),
@IdRol INT,
@IdUsuarioActualiza INT,
@CambiarPassword BIT
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY
		BEGIN TRANSACTION;
			IF(@CambiarPassword = 1)
			BEGIN
				UPDATE Usuarios
					SET Nombre = @Nombe, Nametag = @Nametag, Contrasena = @Contraseña,
						IdRol = @IdRol, IdUsuarioActualiza = @IdUsuarioActualiza,
						FechaActualizacion = GETDATE()
					WHERE IdUsuario = @IdUsuario AND Activo = 1;
				SELECT SCOPE_IDENTITY();
			END
			IF(@CambiarPassword = 0)
			BEGIN
				UPDATE Usuarios
					SET Nombre = @Nombe, Nametag = @Nametag, IdRol = @IdRol,
						IdUsuarioActualiza = @IdUsuarioActualiza, FechaActualizacion = GETDATE()
					WHERE IdUsuario = @IdUsuario AND Activo = 1;
				SELECT SCOPE_IDENTITY();
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

/*Eliminar un Usuario*/
CREATE PROCEDURE DeleteUsuario
@IdUsuario INT,
@IdUsuarioActualiza INT
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY
		BEGIN TRANSACTION;
			UPDATE Usuarios
				SET Activo = 0, IdUsuarioActualiza = @IdUsuarioActualiza
				WHERE IdUsuario = @IdUsuario AND Activo = 1;
			SELECT SCOPE_IDENTITY();
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

/*Metodo Empleado en el Login para validar un parametro*/
CREATE PROCEDURE ExistenciaUsuarioAdmin--Ya creado
AS
BEGIN
SELECT COUNT(U.IdUsuario) FROM Usuarios U
WHERE U.IdRol = 1 AND U.Activo = 1
END
GO

/*Metodo para ValidarLogin*/
CREATE PROCEDURE ValidateLogin --Ya creado
@NameTag VARCHAR(50)
AS
BEGIN
	BEGIN TRY
		SELECT U.Contrasena FROM Usuarios U WHERE U.Nametag = @NameTag AND U.Activo = 1;
	END TRY
	BEGIN CATCH
		THROW --Esto es para que corra el error al C#
	END CATCH
END
GO

--D404559F602EAB6FD602AC7680DACBFAADD13630335E951F097AF3900E9DE176B6DB28512F2E000B9D04FBA5133E8B1C6E8DF59DB3A8AB9D60BE4B97CC9E81DB
--0xD404559F602EAB6FD602AC7680DACBFAADD13630335E951F097AF3900E9DE176B6DB28512F2E000B9D04FBA5133E8B1C6E8DF59DB3A8AB9D60BE4B97CC9E81DB

SELECT * FROM Usuarios
GO