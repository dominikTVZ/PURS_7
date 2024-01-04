-- izrada i odabir baze
DROP DATABASE IF EXISTS lvj6;
CREATE DATABASE IF NOT EXISTS lvj6;
USE lvj6;

-- izrada tablice temperatura i upis

CREATE TABLE temperatura (
	id INT auto_increment PRIMARY KEY,
    datum DATE,
    vrijednost INT
    
);

INSERT INTO temperatura(datum, vrijednost)
VALUES
	('2023-10-10 00:00:00', 20),
    ('2023-10-11 00:00:00', 21),
    ('2023-10-12 00:00:00', 29),
    ('2023-10-13 00:00:00', 5),
    ('2023-15-04 12:05:55', 11),
    ('2023-10-14 17:38:00', 3),
    ('2023-06-02 13:40:00', -4),
    ('2023-12-01 12:05:55', 0);



CREATE TABLE ovlasti (
	id INT auto_increment PRIMARY KEY,
    naziv VARCHAR(100)
);

INSERT INTO ovlasti(naziv)
VALUES
	('Administrator'),
    ('Korisnik');


CREATE TABLE korisnik(
	id INT auto_increment PRIMARY KEY,
    ime CHAR(50),
    prezime CHAR(50),
    username VARCHAR(50),
    password VARCHAR(50),
    id_ovlasti INT,
    FOREIGN KEY (id_ovlasti) REFERENCES ovlasti(id) ON UPDATE CASCADE
);


INSERT INTO korisnik (ime, prezime, username, password, id_ovlasti)
VALUES
    ('Ladislav', 'Kovac', 'lkovac','1234', 1),
    ('Valentina', 'Ilic', 'vilic', 'abcd', 1), 
    ('Danko', 'Kovac', 'dkovac','ab12', 2),
    ('Katija', 'Kolar', 'kkolar','12ab', 2);
    
    
CREATE TABLE korisnikove_temperature (
    id_korisnika INT NOT NULL,
    id_temperature INT NOT NULL,
    FOREIGN KEY (id_korisnika) REFERENCES korisnik(id),
    FOREIGN KEY (id_temperature) REFERENCES temperatura(id),
    PRIMARY KEY (id_korisnika, id_temperature)
);

INSERT INTO korisnikove_temperature (id_korisnika, id_temperature)
VALUES
-- ZA KORISNIKA S ID=1 (lkovac)
    (1, 1),
    (1, 4),
    (1, 3),
    (1, 2),
-- ZA KORISNIKA S ID = 2(vilic)
    (2, 1),
    (2, 2),
    (2, 4),
    
    -- ZA KORISNIKA S ID=3 (dkovac)
    (3, 6),
    (3, 7),
    (3, 8),
    (3, 2),
-- ZA KORISNIKA S ID = 2(vilic)
    (4, 1),
    (4, 2),
    (4, 5),
    (4, 6);
    
    

