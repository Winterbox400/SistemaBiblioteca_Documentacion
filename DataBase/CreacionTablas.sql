CREATE DATABASE BD_ControlBiblioteca
GO

USE BD_ControlBiblioteca
GO

CREATE TABLE Autores(
	IdAutor INT PRIMARY KEY IDENTITY,
	Nombre VARCHAR(50) NOT NULL,
	Activo BIT NOT NULL DEFAULT 1
)
GO

CREATE TABLE Editoriales(
	IdEditorial INT PRIMARY KEY IDENTITY,
	Nombre VARCHAR(50) NOT NULL,
	Activo BIT NOT NULL DEFAULT 1
)
GO

CREATE TABLE Clasificaciones(
	IdClasificacion INT PRIMARY KEY IDENTITY,
	Clasificacion VARCHAR(50) NOT NULL,
	Activo BIT NOT NULL DEFAULT 1
)
GO

CREATE TABLE Libros(
	IdLibro INT PRIMARY KEY IDENTITY,
	Titulo VARCHAR(100) NOT NULL,
	IdAutor INT FOREIGN KEY REFERENCES Autores(IdAutor),
	IdEditorial INT FOREIGN KEY REFERENCES Editoriales(IdEditorial),
	FechaPublicacion DATETIME NOT NULL,
	IdClasificacion INT FOREIGN KEY REFERENCES Clasificaciones(IdClasificacion),
	ISBN VARCHAR(20) NOT NULL UNIQUE,
	Ubicacion VARCHAR(20),
	Activo BIT NOT NULL DEFAULT 1,
	IdUsuarioRegistro INT NOT NULL,
	FechaRegistro DATETIME DEFAULT GETDATE() NOT NULL,
	IdUsuarioActualiza INT NULL,
	FechaActualizacion DATETIME NULL,
)
GO

CREATE TABLE Roles(--Roles no puede recibir nuevas inserciones desde la App.
	IdRol INT PRIMARY KEY IDENTITY,
	Rol VARCHAR(30) NOT NULL,
	Activo BIT NOT NULL DEFAULT 1
)
GO

CREATE TABLE Sucursales(
	IdSucursal INT PRIMARY KEY IDENTITY,
	Nombre VARCHAR(50) NOT NULL,
	Activo BIT NOT NULL DEFAULT 1
)
GO

CREATE TABLE Usuarios(
	IdUsuario INT PRIMARY KEY IDENTITY,
	Nombre VARCHAR(50) NOT NULL,
	Nametag VARCHAR(15) NOT NULL UNIQUE, --Winterbox400
	Contrasena VARBINARY(MAX) NOT NULL, --Es porque SHA2_512 genera un Hash de 64 bytes
	IdRol INT FOREIGN KEY REFERENCES Roles(IdRol),
	Activo BIT NOT NULL DEFAULT 1,
	IdUsuarioRegistro INT NOT NULL,
	FechaRegistro DATETIME DEFAULT GETDATE() NOT NULL,
	IdUsuarioActualiza INT NULL,
	FechaActualizacion DATETIME NULL
)
GO

CREATE TABLE UsuariosSucursales(
	IdUsuarioSucursal INT PRIMARY KEY IDENTITY,
	IdUsuario INT FOREIGN KEY REFERENCES Usuarios(IdUsuario),
	IdSucursal INT FOREIGN KEY REFERENCES Sucursales(IdSucursal),
	Activo BIT NOT NULL DEFAULT 1
)
GO

CREATE TABLE AlmacenLibros(
	IdAlmacenLibro INT PRIMARY KEY IDENTITY,
	IdLibro INT FOREIGN KEY REFERENCES Libros(IdLibro),
	IdSucursal INT FOREIGN KEY REFERENCES Sucursales(IdSucursal),
	StockTotal INT NOT NULL DEFAULT 0,
	StockDisponible INT NOT NULL DEFAULT 0,
	Activo BIT NOT NULL DEFAULT 1,
	IdUsuarioRegistra INT NOT NULL,
	IdFechaRegistro DATETIME DEFAULT GETDATE() NOT NULL,
	IdUsuarioActualiza INT NULL,
	FechaActualizacion DATETIME NULL
)
GO

CREATE TABLE TipoMovimientos(
	IdTipoMovimiento INT PRIMARY KEY IDENTITY,
	Tipo VARCHAR(10) NOT NULL,
	Activo BIT DEFAULT 1 NOT NULL
)
GO

CREATE TABLE ConceptoMovimientos(
	IdConceptoMovimiento INT PRIMARY KEY IDENTITY,
	Concepto VARCHAR(50) NOT NULL,
	Activo BIT DEFAULT 1 NOT NULL
)
GO

CREATE TABLE Movimientos(
	IdMovimiento INT PRIMARY KEY IDENTITY,
	IdTipoMovimiento INT FOREIGN KEY REFERENCES TipoMovimientos(IdTipoMovimiento),
	IdConceptoMovimiento INT FOREIGN KEY REFERENCES ConceptoMovimientos(IdConceptoMovimiento),
	IdSucursal INT FOREIGN KEY REFERENCES Sucursales(IdSucursal),
	Activo BIT DEFAULT 1 NOT NULL,
	IdUsuarioRegistra INT NOT NULL,
	FechaRegistro DATETIME DEFAULT GETDATE() NOT NULL, --Usar en vista tambien para FechaMovimiento
	IdUsuarioActualiza INT NULL,
	FechaActualizacion DATETIME NULL
)
GO

CREATE TABLE DetalleMovimientos(--Me quede aquí maquetanto los StoreProcedureDAL
	IdDetalleMovimiento INT PRIMARY KEY IDENTITY,
	IdLibro INT FOREIGN KEY REFERENCES Libros(IdLibro),
	IdMovimiento INT FOREIGN KEY REFERENCES Movimientos(IdMovimiento),
	Cantidad INT NOT NULL
)
GO

CREATE TABLE Clientes(
	IdCliente INT PRIMARY KEY IDENTITY,
	Nombre VARCHAR(50) NOT NULL,
	Correo VARCHAR(50) NOT NULL UNIQUE,
	Telefono VARCHAR(20) NOT NULL,
	Cedula VARCHAR(20) NOT NULL UNIQUE,
	Direccion VARCHAR(200) NOT NULL,
	DisponibilidadPrestamo BIT DEFAULT 1 NOT NULL, --Si es 1 puede prestar libros
	Activo BIT DEFAULT 1 NOT NULL,
	IdUsuarioRegistra INT NOT NULL,
	FechaRegistro DATETIME DEFAULT GETDATE() NOT NULL,
	IdUsuarioActualiza INT NULL,
	FechaActualizacion DATETIME NULL
)
GO

CREATE TABLE Encabezados(
	IdEncabezado INT PRIMARY KEY IDENTITY,
	Titulo VARCHAR(50) NOT NULL,
	Direccion VARCHAR(200) NOT NULL,
	IdSucursal INT FOREIGN KEY REFERENCES Sucursales(IdSucursal),
	Telefono VARCHAR(20) NOT NULL,
	Activo BIT DEFAULT 1 NOT NULL
)
GO

CREATE TABLE EstadoPrestamos(
	IdEstadoPrestamo INT PRIMARY KEY IDENTITY,
	Estado VARCHAR(10) NOT NULL,
	Activo BIT DEFAULT 1 NOT NULL
)
GO

CREATE TABLE Prestamos(
	IdPrestamo INT PRIMARY KEY IDENTITY,
	IdEncabezado INT FOREIGN KEY REFERENCES Encabezados(IdEncabezado),
	IdClinte INT FOREIGN KEY REFERENCES Clientes(IdCliente),
	IdMovimiento INT FOREIGN KEY REFERENCES Movimientos(IdMovimiento),
	FechaPrestamo DATETIME DEFAULT GETDATE() NOT NULL,
	FechaDevolucionEsperada DATETIME DEFAULT DATEADD(DAY, 15, GETDATE()) NOT NULL,
	FechaDevolucionReal DATETIME NULL,
	IdEstadoPrestamo INT FOREIGN KEY REFERENCES EstadoPrestamos(IdEstadoPrestamo),
	Observacion VARCHAR(200) NULL,
	Activo BIT DEFAULT 1 NOT NULL,
	IdUsuarioRegistra INT NOT NULL,
	FechaRegistro DATETIME DEFAULT GETDATE() NOT NULL,
	IdUsuarioActualiza INT NULL,
	FechaActualizacion DATETIME NULL
)
GO

/*INSERCIONES INICIALES*/
INSERT INTO Roles(Rol)
	VALUES('Administrador')
GO
