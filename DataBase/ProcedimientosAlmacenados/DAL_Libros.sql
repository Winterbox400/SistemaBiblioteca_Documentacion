/*Procedimiento Almacenados Libros*/

/*Referencia de Tabla Libros*/
--CREATE TABLE Libros(
--	IdLibro INT PRIMARY KEY IDENTITY,
--	Titulo VARCHAR(100) NOT NULL,
--	IdAutor INT FOREIGN KEY REFERENCES Autores(IdAutor),
--	IdEditorial INT FOREIGN KEY REFERENCES Editoriales(IdEditorial),
--	FechaPublicacion DATETIME NOT NULL,
--	IdClasificacion INT FOREIGN KEY REFERENCES Clasificaciones(IdClasificacion),
--	ISBN VARCHAR(20) NOT NULL UNIQUE,
--	Ubicacion VARCHAR(20),
--	Activo BIT NOT NULL DEFAULT 1,
--	IdUsuarioRegistro INT NOT NULL,
--	FechaRegistro DATETIME DEFAULT GETDATE() NOT NULL,
--	IdUsuarioActualiza INT NULL,
--	FechaActualizacion DATETIME NULL,
--)
--GO
/*Referencia de Tabla AlmacenLibros*/
--CREATE TABLE AlmacenLibros(
--	IdAlmacenLibro INT PRIMARY KEY IDENTITY,
--	IdLibro INT FOREIGN KEY REFERENCES Libros(IdLibro),
--	IdSucursal INT FOREIGN KEY REFERENCES Sucursales(IdSucursal),
--	StockTotal INT NOT NULL DEFAULT 0,
--	StockDisponible INT NOT NULL DEFAULT 0,
--	Activo BIT NOT NULL DEFAULT 1,
--	IdUsuarioRegistra INT NOT NULL,
--	IdFechaRegistro DATETIME DEFAULT GETDATE() NOT NULL,
--	IdUsuarioActualiza INT NULL,
--	FechaActualizacion DATETIME NULL
--)
--GO

USE BD_ControlBiblioteca
GO

/*Insertar un nuevo Libros al Catalogo y Almacen
Cuando el usuario realice el registro de un nuevo libro, el procedimiento almacenado
realizará la consulta y tambien tomara el Id de dicho registro, para finalmente generar un registro
en el almacen por cada sucursal Existente.
*/
CREATE PROCEDURE InsertLibro
@Titulo VARCHAR(100),
@IdAutor INT,
@IdEditorial INT,
@FechaPublicacion DATETIME,
@IdClasificacion INT,
@ISBN VARCHAR(20),
@Ubicacion VARCHAR(20),
@IdUsuarioRegistro INT
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY
		BEGIN TRANSACTION;
			INSERT INTO Libros(Titulo, IdAutor, IdEditorial, FechaPublicacion, IdClasificacion, ISBN, Ubicacion, IdUsuarioRegistro)
				VALUES(@Titulo, @IdAutor, @IdEditorial, @FechaPublicacion, @IdClasificacion, @ISBN, @Ubicacion, @IdUsuarioRegistro)

			-- Obtener el IdLibro recién insertado
			DECLARE @IdLibro INT = SCOPE_IDENTITY();

			-- Insertar automáticamente en AlmacenLibros para todas las sucursales
			INSERT INTO AlmacenLibros(IdLibro, IdSucursal, IdUsuarioRegistra)
			SELECT @IdLibro, IdSucursal, @IdUsuarioRegistro
			FROM Sucursales;
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

/*Cambiar un Libro*/
CREATE PROCEDURE UpdateLibro
@IdLibro INT,
@Titulo VARCHAR(100),
@IdAutor INT,
@IdEditorial INT,
@FechaPublicacion DATETIME,
@IdClasificacion INT,
@ISBN VARCHAR(20),
@Ubicacion VARCHAR(20),
@IdUsuarioActualiza INT
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY
		BEGIN TRANSACTION;
			UPDATE Libros
				SET Titulo = @Titulo, IdAutor = @IdAutor, IdEditorial = @IdEditorial,
					IdClasificacion = @IdClasificacion, ISBN = @ISBN, Ubicacion = @Ubicacion,
					IdUsuarioActualiza = @IdUsuarioActualiza, FechaActualizacion = GETDATE()
				WHERE IdLibro = @IdLibro AND Activo = 1;
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

/*Eliminar un Libro del catalogo y Almacen*/
CREATE PROCEDURE DeleteLibro
@IdLibro INT,
@IdUsuarioActualiza INT
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY
		BEGIN TRANSACTION;
			UPDATE Libros
				SET Activo = 0, IdUsuarioActualiza = @IdUsuarioActualiza, FechaActualizacion = GETDATE()
				WHERE IdLibro = @IdLibro AND Activo = 1;

			UPDATE AlmacenLibros
				SET Activo = 0, IdUsuarioActualiza = @IdUsuarioActualiza, FechaActualizacion = GETDATE()
				WHERE IdLibro = @IdLibro AND Activo = 1;
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