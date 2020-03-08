TEST DOCKER 
ENTORNO DOCKER PHP MYSQL
Configuración inicial
Lo primero será crear una estructura de directorios donde se pondrá tanto el código fuente, como los ficheros de configuración que se usarán. La ruta base que usaré será ./  y a partir de ella se crearán los siguiente directorios:

•	./ Directorio principal donde se almacenara el archivo docker-compose
•	./php: Se almacena el Dockerfile del servidor de aplicaciones y el index.php
•	mysql/data: Directorio donde se almacenarán los datos de MySql

CONTENEDOR PHP_WEB
Para obtener un contenedor con PHP instalado vamos a acceder a Hub Docker donde podemos encontrar multitud de contenedores disponibles para descargar y arrancar. También puedes crearte una cuenta gratuita y subir tus propios contenedores. En nuestro caso vamos a utilizar la última versión disponible en este momento de PHP 7.2.2-Apache.

Para conectarnos a mysql desde php vamos a utilizar el driver pdo_mysql, pero la imagen oficial de Docker no tiene este driver instalado, así que tendremos que crear nuestra propia imagen a partir de la oficial y añadir el driver. Para ello, vamos a la carpeta principal, crearemos un directorio al que llamaremos php y dentro de este un fichero Dockerfile con el siguiente contenido:

FROM php:7.2.2-apache
RUN apt-get update && docker-php-ext-install mysqli pdo pdo_mysql

CONTENEDOR MYSQL
Para el último contenedor, de nuevo seguiremos los mismos pasos que hasta ahora, ir a Hub Docker y buscar en este caso la imagen oficial de MySql. En este momento la última versión es la 5.7 que es la que usaremos. Es interesante darle un vistazo a la documentación ya que se utilizarán algunas de las opciones que se indican a la hora de crear el contenedor.
Una vez iniciado el contenerdor, deberemos ingresar al mismo mediante el siguiente comando:

# docker container exec -it test4_db_1 bash

Una vez en la linea de commandos deberemos ingresar a la consola de de mysql:

# mysql -u devuser –p

Posteriormente deberá introducir el password : devpass

Y nos saldrá la línea de comandos de mysql
Mysql>

Una vez arrancado el contenedor tendremos la línea de comandos de MySql disponible desde la cual podremos ejecutar comando, crear bases de datos, tablas … Para ver si la base de datos que hemos indicado docker_sample se ha creado, ejecutaremos la siguiente sentencia:
1
	show databases;

Vamos ahora a ejecutar varios comandos para crear una tabla y unos cuantos datos en ella:
1
2
3
4
5
6
7
8
9
10
11
12
13
14
	use test_db;

create table users (
    id int not null auto_increment primary key,
    name varchar(100) not null,
    last_name varchar(250) not null
);

insert into users (name, last_name) VALUES
    ("Jose", "Hernández"),
    ("Emilio", "García"),
    ("Marta", "Gómez"),
    ("Luis", "López"),
    ("Laura", "Moreno");

PONIENDO EN FUNCIONAMIENTO LOS 2 CONTENEDORES
Lo primero que vamos a hacer es crear un script PHP que acceda a nuestra base de datos, recupere información de los usuario y se la muestre al cliente en el navegador.
Volvemos a editar el fichero index.php que se encuentra en la ruta de la aplicación (./php), lo borramos por completo y escribimos el siguiente código:
<?php
    $pdo = new \PDO('mysql:host=test4_db_1;dbname=test_db', 'devuser', 'devpass');
    $res = $pdo->query('select name, last_name from users');
    foreach ($res as $user) {
        echo '<p>' . $user[0] . ' - ' . $user[1];
    }
?>

NOTA: en mysql:host se debe cambiar por el nombre del CONTAINER 
Docker compose para arrancar todos los contenedores a la vez
Para mejorar este proceso vamos a utilizar Docker compose.
Docker compose es una herramienta que permite definir y arrancar multiples contenedores a la vez. Para ello en un fichero se definen los contenedores y a través de él se arrancan y paran los contenedores.
Este fichero lo llamaremos docker_compose.yml y lo crearemos dentro de la carpeta principal ./ de nuestro directorio de trabajo. Su contenido será el siguiente:

# ./docker-compose.yml
version: '3'
services:
  db:
    image: mysql:5.7
    container_name:test4_db_1
    environment:
      MYSQL_ROOT_PASSWORD: my_secret_pw_shh
      MYSQL_DATABASE: test_db
      MYSQL_USER: devuser
      MYSQL_PASSWORD: devpass
    ports:
      - "9906:3306"
  web:
    build: './php/'
    container_name: php_web
    depends_on:
      - db
    volumes:
      - ./php/:/var/www/html/
    ports:
      - "8100:80"
    stdin_open: true
    tty: true

Una vez creado este fichero, vamos con un terminal a la ruta donde está y arrancamos todos los contenedores con el siguiente comando:
> docker-compose up -d

