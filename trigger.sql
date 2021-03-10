-- TRIGGER PARA AUDITORIA - ADMINISTRADOR

-- crear un nuevo esquema en la bd
Create schema admin;

-- ingresar a ese nuevo esquema
set search_path to admin;

-- crear tabla para ingresar datos con el trigger
CREATE TABLE auditoria (
  id_auditoria serial NOT NULL,
  NombreTabla character(20) NOT NULL,
  Operacion character(10) NOT NULL,
  ValorAnterior text,
  ValorNuevo text,
  Fecha timestamp without time zone NOT NULL,
  Usuario character(45) NOT NULL,
  CONSTRAINT id_auditoria PRIMARY KEY (id_auditoria)
)


-- crear trigger
CREATE OR REPLACE FUNCTION auditoriaTablas() RETURNS trigger AS
$$
BEGIN
-- se valida para cuando se ELIMINE un registro de una tabla
  IF (TG_OP = 'DELETE') THEN
    INSERT INTO auditoria (NombreTabla, Operacion, ValorAnterior, ValorNuevo, Fecha, Usuario)
           VALUES (TG_TABLE_NAME, 'ELIMINÓ', OLD, NULL, now(), USER);
    RETURN OLD;
	
-- se valida para cuando se ACTUALICE un registro de una tabla
  ELSIF (TG_OP = 'UPDATE') THEN
    INSERT INTO auditoria (NombreTabla, Operacion, ValorAnterior, ValorNuevo, Fecha, Usuario)
           VALUES (TG_TABLE_NAME, 'ACTUALIZÓ', OLD, NEW, now(), USER);
    RETURN NEW;
	
-- se valida para cuando se INSERTE un registro de una tabla
  ELSIF (TG_OP = 'INSERT') THEN
    INSERT INTO auditoria (NombreTabla, Operacion, ValorAnterior, ValorNuevo, Fecha, Usuario)
           VALUES (TG_TABLE_NAME, 'INSERTÓ', NULL, NEW, now(), USER);
    RETURN NEW;
  END IF;
  RETURN NULL;
END;
$$
LANGUAGE 'plpgsql' VOLATILE COST 100;


-- crea el trigger en una tabla
CREATE TRIGGER triggerAuditoria AFTER INSERT OR UPDATE OR DELETE
ON public.paciente FOR EACH ROW EXECUTE PROCEDURE auditoriaTablas();


-- insertar dato tabla paciente
insert into public.paciente (id, nombre, apellido, fecha_nacimiento, cedula, estatura, email) 
values (14, 'LUISA', 'GOMEZ', '1996-04-04', '1321605001', '1.60','luisaa@gmail.com')

-- modificar dato tabla paciente
update public.paciente SET nombre='MARIA' WHERE id = 14;

-- eliminar dato tabla paciente
delete from public.paciente WHERE id = 14;


select * from public.paciente

select * from admin.auditoria