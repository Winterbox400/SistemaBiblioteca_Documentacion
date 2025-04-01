/*PROCEDIMIENTOS ALMACENADOS PARA BD_ControlBiblioteca*/

USE BD_ControlBiblioteca
GO

/**VALIDAR EXISTE UN ADMINISTRADOR
Será utilizado en el Login del programa
Sí es la primera ves que un usuario se esta registrando devolverá 0:
	De esta manera activando un Metodo para mostrar ciertos campos y
	darle el rol de admin a este usuario
Sí ya hay un administrador, otros usuarios no podrán registrarse sin
	el permiso de un administrador (Osea ingresar sus credenciales)
*/
CREATE PROCEDURE Sp_ValideAdmin AS
BEGIN
	SET NOCOUNT ON;
	SELECT COUNT(U.IdUsuario) FROM Usuarios U
	WHERE U.Activo = 1 AND U.IdRol = 1 --Administrador
END
GO



















EXEC Sp_ValideAdmin
GO

go 
create view vAutores
as
select IdAutor,Nombre from Autores
go

select * from vAutores
go

alter proc SPInsertAutores
@Nombre varchar(100)
as 
begin
insert into Autores (Nombre, Activo) values(@Nombre,1)
select SCOPE_IDENTITY();
end 