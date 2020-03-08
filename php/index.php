<?php
    $pdo = new \PDO('mysql:host=test4_db_1;dbname=test_db', 'devuser', 'devpass');
    $res = $pdo->query('select name, last_name from users');
    foreach ($res as $user) {
        echo '<p>' . $user[0] . ' - ' . $user[1];
    }
?>
