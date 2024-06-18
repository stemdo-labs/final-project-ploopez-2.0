<!-- <?php
$errores = [];

if ($_SERVER["REQUEST_METHOD"] == "POST") {
    // Validación del nombre
    if (empty($_POST["nombre"])) {
        $errores[] = "El campo nombre es obligatorio.";
    }

    // Validación de los apellidos
    if (empty($_POST["apellidos"])) {
        $errores[] = "El campo apellidos es obligatorio.";
    }

    // Validación del teléfono
    if (!preg_match("/^\d{9}$/", $_POST["telefono"])) {
        $errores[] = "El teléfono debe tener 9 dígitos numéricos.";
    }

    // Validación de la cantidad
    $cantidad = filter_var($_POST["cantidad"], FILTER_VALIDATE_INT, [
        "options" => [
            "min_range" => 1,
            "max_range" => 10
        ]
    ]);
    if ($cantidad === false) {
        $errores[] = "La cantidad debe ser un número entero mayor que 0 y menor o igual que 10.";
    }

    

}
?>

<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <title>Comprar entradas</title>
        <link rel="stylesheet" href="css/estilos.css">
    </head>
    <body>
        <h1>Comprar entradas</h1>
        <?php if (!empty($errores)): ?>
            <div style="color: red;">
                <?php foreach ($errores as $error): ?>
                    <p><?php echo $error; ?></p>
                <?php endforeach; ?>
            </div>
        <?php endif; ?>
        <form action="comprarentradas.php" method="post">
            <div>
                <label for="nombre">Nombre:</label>
                <input type="text" id="nombre" name="nombre" required>
            </div>
            <div>
                <label for="apellidos">Apellidos:</label>
                <input type="text" id="apellidos" name="apellidos" required>
            </div>
            <div>
                <label for="telefono">Teléfono:</label>
                <input type="tel" id="telefono" name="telefono" pattern="\d{9}" title="El teléfono debe tener 9 dígitos numéricos." required>            </div>
            <div>
                <label for="tipo">Tipo de Entrada:</label>
                <select id="tipo" name="tipo">
                    <option value="general">General</option>
                    <option value="vip">VIP</option>

                </select>
            </div>
            <div>
                <label for="cantidad">Cantidad:</label>
                <input type="number" id="cantidad" name="cantidad" min="1" max="10" required>
            </div>
            <button type="submit" name="comprar">Comprar</button>
        </form>
    </body>
</html> -->
