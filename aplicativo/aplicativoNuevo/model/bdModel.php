<?php
class bd {
    protected $bbdd;    
    protected $username;
    protected $password;
    protected $host;
    protected $conexion;

    public function __construct() {
        // Obtener variables de entorno
        $this->bbdd = 'concierto';
        $this->username = 'plopez';
        $this->password = '1234';
        //$this->host = 'db';
        $this->host = '10.0.1.4';

        try {
            // Conectar a MySQL sin especificar la base de datos
            //$this->conexion = new PDO('mysql:host=db;dbname='.$this->bbdd, $this->username, $this->password);
            $this->conexion = new PDO('mysql:host=' . $this->host . ';port=3306', $this->username, $this->password);
            $this->conexion->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

            // Crear la base de datos si no existe
            $this->conexion->exec("CREATE DATABASE IF NOT EXISTS `$this->bbdd`");

            // Establecer una nueva conexión a la base de datos específica
            $this->conexion = new PDO('mysql:host=' . $this->host . ';dbname=' . $this->bbdd, $this->username, $this->password);
            $this->conexion->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

            // Crear la tabla tipo_entradas
            $this->conexion->exec("
                CREATE TABLE IF NOT EXISTS tipo_entradas (
                    id VARCHAR(36) PRIMARY KEY,
                    tipo VARCHAR(30) NOT NULL,
                    precio DECIMAL(10,2) NOT NULL
                )
            ");

            // Crear la tabla entradas
            $this->conexion->exec("
                CREATE TABLE IF NOT EXISTS entradas (
                    id VARCHAR(36) PRIMARY KEY,
                    fecha DATE NOT NULL,
                    nombre VARCHAR(15) NOT NULL,
                    apellidos VARCHAR(30) NOT NULL,
                    telefono VARCHAR(9) NOT NULL,
                    tipo_entrada VARCHAR(36),
                    cantidad INT NOT NULL,
                    precio DECIMAL(10,2) NOT NULL,
                    FOREIGN KEY (tipo_entrada) REFERENCES tipo_entradas(id)
                )
            ");

            // Insertar datos en la tabla tipo_entradas si no existen
            $this->insertarDatosTipoEntradas();

        } catch (PDOException $e) {
            echo 'Connection failed: ' . $e->getMessage();
            exit;
        }
    }

    private function insertarDatosTipoEntradas() {
        // Verificar si ya existen datos en la tabla tipo_entradas
        $stmt = $this->conexion->query("SELECT COUNT(*) FROM tipo_entradas");
        $count = $stmt->fetchColumn();

        if ($count == 0) {
            // Insertar datos iniciales en la tabla tipo_entradas
            $this->conexion->exec("
                INSERT INTO tipo_entradas (id, tipo, precio) VALUES 
                (UUID(), 'Menor', 10.00),
                (UUID(), 'Adulto', 5.00),
                (UUID(), 'Jubilado', 7.00)
            ");
        }
    }
}
?>
