--Creaci�n de Vistas para Formularios de SistemaBiblioteca

USE BD_ControlBiblioteca
GO

/**	Lista Clientes Activos
	Muestra el total de clientes activos dentro del sistema*/
CREATE VIEW Vw_Cliente AS
SELECT 
CL.Nombre,
CL.Correo,
CL.Telefono,
CL.Cedula,
CL.Direccion,
CL.DisponibilidadPrestamo AS 'Disponibilidad Prestamo'
FROM Clientes CL 
WHERE CL.Activo = 1
GO

/**	Lista de Libros Activos
	Esta vista contiene los libros activos dentro del sistema*/
CREATE VIEW Vw_Libros AS
SELECT
L.Titulo,
A.Nombre AS Autor,
E.Nombre AS Editoria,
L.FechaPublicacion AS 'Fecha de Publicaci�n',
CA.Clasificacion,
L.ISBN,
L.Ubicacion
FROM Libros L
INNER JOIN Autores A ON L.IdAutor = A.IdAutor
INNER JOIN Editoriales E ON L.IdEditorial = E.IdEditorial
INNER JOIN Clasificaciones CA ON L.IdClasificacion = CA.IdClasificacion
WHERE L.Activo = 1
GO

/** Lista de Usuarios Activos
Lista de Usuarios activos dentro del sistema con sus roles
Sera utilizada dentro del form para Usuarios en el boton desplegable de Administraci�n
Servira solo para mostrar la lista de usuarios y su rol.
-->Cuando un usuario dentro de esta lista sea clickeado se desplegar� otro formulario
dicho formulario llamara a la vista Vw_InformacionUsaurio y a la vista VwSucursalesUsuario.
*/
CREATE VIEW Vw_Usuarios AS
SELECT
U.Nombre,
U.Nametag,
R.Rol
FROM Usuarios U
INNER JOIN Roles R ON U.IdRol = R.IdRol
WHERE U.Activo = 1
GO

/** Lista informaci�n de Usuario
Esta ser� empleada en un formulario del sistema cuando se clickee un usuario de la vista Vw_Usuario
Una ves esto suceda ser� llamada esta vista con el Id del usuario al que se haya clickeado, mostrando
la informaci�n sobre este usaurios, no como table, sino como rellenador de campos y labels, en otras palabras
mostrara un informe basico del usuario clickeado
*/
CREATE VIEW Vw_InformacionUsaurio AS

GO

/** Lista Sucursales de un Usuario
Esta compartira formulario con la vista Vw_InformacionUsuario, pero esta se encargar� unicamente de mostrar
la lista de sucursales que el usuario tiene acceso y permitido operar.
*/
CREATE VIEW VwSucursalesUsuario AS
GO


Select * from Vw_Usuarios
GO

/** Informaci�n sobre un usuario

*/