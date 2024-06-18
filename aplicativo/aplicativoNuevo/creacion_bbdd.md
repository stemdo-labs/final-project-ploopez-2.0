El propósito de este proyecto es crear una base de datos en MySQL llamada concierto, la cual contiene dos tablas: entradas y tipo_entradas. La tabla entradas almacena información sobre las entradas vendidas para un concierto, mientras que la tabla tipo_entradas almacena los diferentes tipos de entradas disponibles y sus respectivos precios.

Proceso de Creación
Creación de la base de datos:
Se creó una base de datos denominada concierto mediante PhpMyAdmin.

Creación de la tabla tipo_entradas:
Se definió una tabla para almacenar los tipos de entradas y sus precios. La tabla tiene tres columnas: id (UUID), tipo (texto de 30 caracteres), y precio (decimal).

Creación de la tabla entradas:
Se definió una tabla para almacenar las entradas vendidas, con los campos id, fecha, nombre, apellidos, telefono, tipo_entrada, cantidad, y precio. La columna tipo_entrada es una clave foránea que referencia la columna id de la tabla tipo_entradas.

Inserción de datos en tipo_entradas:
Se insertaron manualmente tres registros en la tabla tipo_entradas para los tipos de entradas: Menor, Adulto y Jubilado, con sus respectivos precios.

Conclusión
La base de datos concierto se ha creado exitosamente con las tablas entradas y tipo_entradas. La relación entre ambas tablas se ha establecido mediante una clave foránea en entradas, permitiendo así mantener la integridad referencial de los datos.