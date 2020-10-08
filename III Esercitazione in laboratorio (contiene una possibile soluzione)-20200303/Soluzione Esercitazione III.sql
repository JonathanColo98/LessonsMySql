

/********************************************************

   Esercizio tratto dalla I prova intermedia del 2013-14

*********************************************************/


DROP DATABASE IF EXISTS VISITEMEDICHE;
CREATE DATABASE IF NOT EXISTS VISITEMEDICHE;
USE VISITEMEDICHE;


DROP TABLE IF EXISTS VISITE;
DROP TABLE IF EXISTS RICETTE;
DROP TABLE IF EXISTS DOTTORI;
DROP TABLE IF EXISTS PAZIENTI;
DROP TABLE IF EXISTS PERSONE;

CREATE TABLE PERSONE(
codice_fiscale VARCHAR(16) PRIMARY KEY,
nome VARCHAR(20) NOT NULL,
cognome VARCHAR(20) NOT NULL,
data_di_nascita DATE,
sesso ENUM('M','F')
) ENGINE=INNODB;


CREATE TABLE DOTTORI(
codice_fiscale VARCHAR(16) PRIMARY KEY,
FOREIGN KEY(codice_fiscale)  REFERENCES PERSONE(codice_fiscale) ON UPDATE CASCADE,
specializzazione VARCHAR(25),
numero_visite INT DEFAULT 0
) ENGINE=INNODB;



CREATE TABLE PAZIENTI(
codice_assistito INT PRIMARY KEY AUTO_INCREMENT,
cf_paziente VARCHAR(16) NOT NULL,
FOREIGN KEY (cf_paziente) REFERENCES PERSONE(codice_fiscale) ON UPDATE CASCADE,
cf_medico VARCHAR(16) NOT NULL,
FOREIGN KEY (cf_medico) REFERENCES DOTTORI(codice_fiscale) ON UPDATE CASCADE
) ENGINE=INNODB;




CREATE TABLE RICETTE(
codice INT,
farmaco VARCHAR(50),
PRIMARY KEY(codice, farmaco),
quantita SMALLINT
) ENGINE=INNODB;



CREATE TABLE VISITE(
data DATE,
codice_assistito INT,
-- FOREIGN KEY(codice_assistito) REFERENCES PAZIENTI(codice_assistito) ON UPDATE CASCADE,
PRIMARY KEY(data, codice_assistito),
des VARCHAR(100),
Idricetta int,
FOREIGN KEY (Idricetta) REFERENCES RICETTE(Codice) ON UPDATE CASCADE
) ENGINE=INNODB;



INSERT INTO PERSONE VALUES
('XYZ1','Paolo','Rossi','1960-06-12','M'),
('XYZ2','Marco','Bianchi','1954-04-18','M'),
('XYZ3','Paola','Blu','1958-03-25','F'),
('ABC1','Sara','Verdi','1972-05-23','F'),
('ABC2','Alice','Rossi','1965-02-16','F'),
('ABC3','Marta','Neri','1953-05-12','F'),
('ABC4','Filippo','Blu','1950-02-15','M'),
('XYZ4','Massimo','Rossi','1966-02-15','M');


INSERT INTO DOTTORI VALUES
('XYZ2','Medicina generale',3),
('ABC2','Pneumologia',4);


INSERT INTO PAZIENTI(cf_paziente,cf_medico) VALUES
('XYZ1','ABC2'),
('ABC1','ABC2'),
('ABC3','XYZ2'),
('XYZ3','XYZ2'),
('XYZ4','ABC2');



load data local infile 'DatiRicette.in'
into table Ricette
fields terminated by '-'
optionally enclosed by'|'
lines terminated by '\n'
ignore 3 lines;




load data local infile 'DatiVisite.csv'
into table VISITE
fields terminated by ','
optionally enclosed by'"'
lines terminated by '\n'
ignore 4 lines;



-- (a)
ALTER TABLE VISITE CHANGE des descrizione VARCHAR(255);

-- (b)
ALTER TABLE VISITE
ADD FOREIGN KEY(codice_assistito) REFERENCES PAZIENTI(codice_assistito) ON UPDATE CASCADE;


-- (c)
CREATE TABLE RICETTEDETTAGLIATE LIKE RICETTE;

ALTER TABLE RICETTEDETTAGLIATE DROP PRIMARY KEY, ADD data DATE, ADD descrizione VARCHAR(255);




-- Trovare le visite effettuate tra gennaio 2014 e marzo 2014

select * from visite where data >='2014-01-01' and data <='2014-03-31';

-- Trovare le visite che corrispondono ad una descrizione con piu di una parola
--  (ovvero, almeno due parole separate da uno spazio).

select * from visite where descrizione like '% %';

-- Trovare le persone il cui codice fiscale termina con '1' oppure con '2';

select * from persone where codice_fiscale like '%1' or codice_fiscale like '%2';

-- Trovare il numero totale di confezioni di farmaci prescritti

select sum(quantita) as confenzioni from ricette;


-- Trovare nome e cognome dei pazienti che hanno fatto una visita dal dottore con codice fiscale 'ABC2'
-- Per la soluzione sono necessari query annidate o join. Query di qesto tipo non
-- ci saranno nella prima prova intermedia.


select nome, cognome from persone where codice_fiscale in
(select cf_paziente from pazienti where cf_medico='ABC2' and codice_assistito in
(select codice_assistito from visite)
);

select nome, cognome from persone where codice_fiscale in
(select distinct cf_paziente from visite natural join pazienti where cf_medico='ABC2');