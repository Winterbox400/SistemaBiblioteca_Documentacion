--CREATE TABLE Movimientos(
--    IdMovimiento INT PRIMARY KEY IDENTITY,
--    TipoMovimiento CHAR(1) CHECK (TipoMovimiento IN ('E', 'S', 'P')), 
--    -- 'E' = Entrada, 'S' = Salida, 'P' = Préstamo
--    FechaMovimiento DATETIME DEFAULT GETDATE()
--);


--CREATE TABLE InventarioLibros(
--	IdInventarioLibros INT PRIMARY KEY IDENTITY,
--    IdLibro INT FOREIGN KEY REFERENCES Libros(IdLibro),
--    StockTotal INT NOT NULL DEFAULT 0,  -- Cantidad total de libros en la biblioteca
--    StockDisponible INT NOT NULL DEFAULT 0 -- Libros disponibles para préstamo
--);


--CREATE TABLE LibroMovimiento(
--    IdLibroMovimiento INT PRIMARY KEY IDENTITY,
--    IdLibro INT FOREIGN KEY REFERENCES Libros(IdLibro),
--    IdMovimiento INT FOREIGN KEY REFERENCES Movimientos(IdMovimiento),
--    Cantidad INT NOT NULL
--);


CREATE TABLE Prestamos(
    IdPrestamo INT PRIMARY KEY IDENTITY,
    IdLibro INT FOREIGN KEY REFERENCES Libros(IdLibro),
    IdCliente INT FOREIGN KEY REFERENCES Clientes(IdCliente),
    FechaPrestamo DATETIME DEFAULT GETDATE(),
    FechaDevolucionEsperada DATETIME,
    FechaDevolucionReal DATETIME NULL, -- Se llena cuando el libro es devuelto
    Estado VARCHAR(10) CHECK (Estado IN ('Prestado', 'Devuelto', 'Retrasado'))
);
