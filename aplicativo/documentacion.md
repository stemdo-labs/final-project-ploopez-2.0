PRIMERA PARTE 

El aplicativo se divide en 3 partes, cada una de ellas dockerizada (contenida), en  un contenedor.

Lo primero fue crear la tabla y los campos dentro de la base de datos, luego arreglar el aplicativo que nos habían pasado para que se pudiera conectar correctamente a la base de datoss.

Luego creé un dockerfile, que define una imagen de contenedor para una aplicación web PHP que utiliza Apache como servidor web y se conecta a una base de datos MySQL  y configuraciones para reescritura de URL y chequeos de salud.

También he creado un Docker-Compose, define un entorno de desarrollo con tres servicios: una base de datos (db), un servidor web PHP (web) y una instancia de phpMyAdmin (phpmyadmin). Mapea el puerto 80 del contenedor al puerto 80 del host, permitiendo el acceso al servidor web desde el navegador y le añado una dependencia del servicio de la base datos, asegurando que el contenedor de la base de datos esté en funcionamiento antes de iniciar el contenedor web. Por último, está el contenedor del servicio phpmyadmin, el  cual utiliza una imagen oficial del phpmmyadmin, en la que se definen variaables de entorno para configurar phpmyadmin, incluyendo el host de la base de datos, el puerto y la contraseña del root (PMA_HOST, PMA_PORT, MYSQL_ROOT_PASSWORD).Mapea el puerto 80 del contenedor al puerto 8080 del host, permitiendo el acceso a phpMyAdmin desde el navegador y define un volumen nombrado db_data para ser utilizado por el servicio de la base de datos, permitiendo que los datos persistan entre reinicios del contenedor de la base de datos.