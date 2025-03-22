ALTER USER postgres WITH PASSWORD 'Nueva_Clave_123'

/*Se crean perfiles de acceso a la base de datos: Rol de lectura y Rol de administracion*/

CREATE ROLE lector WITH LOGIN PASSWORD 'Clave_Lector';
GRANT CONNECT ON DATABASE elecciones TO lector;
GRANT USAGE ON SCHEMA public TO lector;
GRANT SELECT ON ALL TABLES IN SCHEMA public To lector;

CREATE ROLE admin_bd WITH LOGIN PASSWORD 'Clave_Admin';
ALTER ROLE admin_bd CREATEDB CREATEROLE;
GRANT ALL PRIVILEGES ON DATABASE elecciones TO admin_bd;

/*Creacion de usuarios*/ Aquii

CREATE USER usulector WITH PASSWORD 'clave_segura' IN ROLE lector;
CREATE USER usuAdmin WITH PASSWORD 'clave_segura' IN ROLE admin_bd;

/*Copia de seguridad de Backup*/

Get-Service -Name postgresql*

/*hacer backup de la Bd*/

/*Una copia de seguridad en PostgreSQL se puede hacer 
usando el comando pg_dump, que permite extraer los datos 
y estructuras de la base de datos para su posterior restauración.*/

/*En la termina de powersell*/

"C:\Program Files\PostgreSQL\17\bin\pg_dump.exe" -U postgres -F c -b -v -f "C:\Users\leidy\backup_elecciones.dump" elecciones

/*Restaura la bd en otro servidor Esto generará un archivo backup.sql con todas las sentencias*/

/*En la terminal de powerssell*/

"C:\Program Files\PostgreSQL\17\bin\pg_restore.exe" -U postgres -W -d elecciones "C:\Users\leidy\Documents\02. Proyectos\PostgreSQL\backup_elecciones.dump"

/*Otras opciones de seguridad*/

Asegurarse de que el usuario postgres tenga una contraseña segura.
Crear roles y permisos específicos para cada tipo de usuario
Realizar backups automáticos
Encriptar datos sensibles
