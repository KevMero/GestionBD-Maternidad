-- CREACION DE CURSOR

-- ESTE CURSOR MOSTRARÁ REGISTROS DE LA TABLA AUDITORIA EN EL ESQUEMA ADMIN

CREATE OR REPLACE FUNCTION cursorAuditoria() RETURNS void AS
$$
DECLARE
-- DECLARACION DE VARIABLES
		consulta Record;
		cursor_auditoria Cursor for SELECT * FROM admin.auditoria;
BEGIN

-- SE RECORRE EL CURSOR MEDIANTE UN CICLO, EN ESTE CASO SE USARÁ UN FOR
for consulta in cursor_auditoria loop

-- mostrar datos por consola
RAISE NOTICE 

'Se: % | Valor Anterior: % | Valor Nuevo: %', 
consulta.operacion, consulta.valoranterior, consulta.valornuevo;
end loop;

END $$

LANGUAGE 'plpgsql';

-- EJECUTAR CURSOR (VER RESPUESTA EN LA PESTAÑA Messages)
SELECT cursorAuditoria()