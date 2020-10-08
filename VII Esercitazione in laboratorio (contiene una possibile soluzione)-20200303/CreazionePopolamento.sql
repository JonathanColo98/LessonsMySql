
/*DROP DATABASE IF EXISTS VISITEMEDICHE;
CREATE DATABASE IF NOT EXISTS VISITEMEDICHE;
USE VISITEMEDICHE; */


############################################################################
################              Creazione database           #################
############################################################################


DROP TABLE IF EXISTS VISITE;
DROP TABLE IF EXISTS RICETTE;
DROP TABLE IF EXISTS PAZIENTI;
DROP TABLE IF EXISTS DOTTORI;
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
FOREIGN KEY(codice_assistito) REFERENCES PAZIENTI(codice_assistito) ON UPDATE CASCADE,
PRIMARY KEY(data, codice_assistito),
des VARCHAR(100),
Idricetta int,
FOREIGN KEY (Idricetta) REFERENCES RICETTE(Codice) ON UPDATE CASCADE
) ENGINE=INNODB;



############################################################################
################            Popolamento database           #################
############################################################################

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


INSERT INTO RICETTE VALUES
(0,'Nessuna prescrizione',0),
(10,'Aspirina',1),
(10,'Sciroppo tosse',1),
(20,'Antibiotico',2),
(20,'Aerosol',1),
(30,'Vitamina C',1),
(40,'Aspirina',2),
(40,'Vitamina C',1),
(50,'Paracetamolo',2);



INSERT INTO VISITE VALUES
('2014-02-08',1,'Influenza',10),
('2014-03-08',2,'Bronchite',20),
('2014-04-07',2,'Postumi bronchite',30),
('2014-04-15',2,'Paziente guarito',0),
('2014-03-20',3,'Emicrania',40),
('2014-04-10',3,'Influenza',50),
('2014-04-18',4,'Visita di controllo',0)
;


