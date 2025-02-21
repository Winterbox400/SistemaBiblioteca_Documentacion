CREATE DATABASE PruebaBiblioteca_WinterForma
GO

CREATE TABLE Libros(
IdLibro INT PRIMARY KEY IDENTITY,
Titulo VARCHAR(30) NOT NULL,
ISBN VARCHAR(20) NOT NULL
)
GO

CREATE TABLE Movimientos(
IdMovimiento INT PRIMARY KEY IDENTITY,
Activo BIT
)
GO

CREATE TABLE LibroMovimiento(
IdLibroMovimiento INT PRIMARY KEY IDENTITY,
IdLibro INT FOREIGN KEY REFERENCES Libros(IdLibro),
IdMovimiento INT FOREIGN KEY REFERENCES Movimientos(IdMovimiento),
Cantidad INT NOT NULL
)
GO

CREATE TABLE Encabezados(
IdEncabezado INT PRIMARY KEY IDENTITY,
NombreBiblioteca VARCHAR(50) NOT NULL,
RUC VARCHAR(50) NOT NULL
)GO

CREATE TABLE DetalleMovimientos(
IdDetalleMovimiento INT PRIMARY KEY IDENTITY,
IdEncabezado INT FOREIGN KEY REFERENCES Encabezados(IdEncabezado),
IdMovimiento INT FOREIGN KEY REFERENCES Movimientos(IdMovimiento),
TipoMovimiento VARCHAR(10) NOT NULL, --Entrada o salida, etc... en el original lo tengo en otra tabla
)
GO

CREATE TABLE InventarioLibros(
--COMO DEBERIA HACERLO?
)
GO

CREATE TABLE (

)GO