-- izrada i odabir baze
DROP DATABASE IF EXISTS lvj6;
CREATE DATABASE lvj6;
USE lvj6;


DROP USER IF EXISTS app;
CREATE USER app@'%' IDENTIFIED BY '1234';
GRANT SELECT, INSERT, UPDATE, DELETE ON lvj6.* TO app@'%';

-- izrada tablice temperatura i upis

CREATE TABLE temperatura (
	id INT PRIMARY KEY auto_increment,
    datum DATE,
    vrijednost INT
    
);

INSERT INTO temperatura (datum, vrijednost)
VALUES
    ('2023-10-10 00:00:00', 20),
    ('2023-10-11 00:00:00', 21),
    ('2023-10-12 00:00:00', 29),
    ('2023-10-13 00:00:00', 5),
    ('2023-10-15 12:05:55', 11),
    ('2023-10-14 17:38:00', 3),
    ('2023-12-06 13:40:00', 4),
    ('2023-11-21 12:05:55', 0);




CREATE TABLE ovlasti (
	id INT auto_increment PRIMARY KEY,
    naziv VARCHAR(100)
);

INSERT INTO ovlasti(naziv)
VALUES
	('Administrator'),
    ('Korisnik');


CREATE TABLE korisnik(
	id INT PRIMARY KEY auto_increment ,
    ime CHAR(50),
    prezime CHAR(50),
    username VARCHAR(50),
    password BINARY(32),
    id_ovlasti INT,
    FOREIGN KEY (id_ovlasti) REFERENCES ovlasti(id) ON UPDATE CASCADE 
);


INSERT INTO korisnik (ime, prezime, username, password, id_ovlasti)
VALUES
    ('Ladislav', 'Kovac', 'lkovac', UNHEX(SHA2('1234', 256)), 1),
    ('Valentina', 'Ilić', 'vilic', UNHEX(SHA2('abcd', 256)), 1), 
    ('Danko', 'Kovac', 'dkovac', UNHEX(SHA2('ab12', 256)), 2),
    ('Katija', 'Kolar', 'kkolar', UNHEX(SHA2('12ab', 256)), 2);
    
    
CREATE TABLE korisnikove_temperature (
    id_korisnika INT NOT NULL,
    id_temperature INT NOT NULL,
    FOREIGN KEY (id_korisnika) REFERENCES korisnik(id)  ON UPDATE CASCADE,
    FOREIGN KEY (id_temperature) REFERENCES temperatura(id)  ON UPDATE CASCADE ,
    PRIMARY KEY (id_korisnika, id_temperature)
);

INSERT INTO korisnikove_temperature (id_korisnika, id_temperature)
VALUES
    (1, 1),
    (1, 4),
    (1, 3),
    (1, 2),

    (2, 1),
    (2, 2),
    (2, 4),
    
    
    (3, 6),
    (3, 7),
    (3, 8),
    (3, 2),

    (4, 1),
    (4, 2),
    (4, 5),
    (4, 6);
    
    
CREATE TABLE vlaga (
	id INT auto_increment PRIMARY KEY,
    datum DATE,
    vrijednost INT
    
);

INSERT INTO vlaga(datum, vrijednost)
VALUES
	('2023-10-10 00:00:00', 65),
    ('2023-10-11 00:00:00', 61),
    ('2023-10-12 00:00:00', 54),
    ('2023-10-13 00:00:00', 53),
    ('2023-12-15 12:05:55', 57),
    ('2023-10-14 17:38:00', 62),
    ('2023-12-06 13:40:00', 55),
    ('2023-11-21 12:05:55', 60);


CREATE TABLE korisnikove_vlage (
	id_korisnika INT,
    id_vlage INT,
    FOREIGN KEY (id_korisnika) REFERENCES korisnik(id) ON DELETE CASCADE,
    FOREIGN KEY (id_vlage) REFERENCES vlaga(id) ON DELETE CASCADE,
    PRIMARY KEY (id_korisnika, id_vlage)
);

INSERT INTO korisnikove_vlage (id_korisnika, id_vlage) VALUES

    (1, 1),
    (1, 4),
    (1, 3),
    (1, 2),

    (2, 1),
    (2, 2),
    (2, 4),
    

    (3, 6),
    (3, 7),
    (3, 8),
    (3, 2),

    (4, 1),
    (4, 2),
    (4, 5),
    (4, 6);


