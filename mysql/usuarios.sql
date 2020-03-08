use test_db;

create table users (
    id int not null auto_increment primary key,
    name varchar(100) not null,
    last_name varchar(250) not null
);

insert into users (name, last_name) VALUES
    ("Jose", "Hernandez"),
    ("Emilio", "Garcia"),
    ("Marta", "Gomez"),
    ("Luis", "Lopez"),
    ("Laura", "Moreno");
