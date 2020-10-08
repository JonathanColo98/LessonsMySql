
############################################################################
################        CREAZIONE DATABASE E TABELLE       #################
############################################################################

/*drop database if exists NegoziDischi;
create database if not exists NegoziDischi;
use NegoziDischi;*/

DROP TABLE IF EXISTS Vendita;
DROP TABLE IF EXISTS Negozio;
DROP TABLE IF EXISTS Composto_da;
DROP TABLE IF EXISTS Autore;
DROP TABLE IF EXISTS Disco;


CREATE TABLE Disco(
disco_id INT PRIMARY KEY auto_increment,
titolo CHAR(20),
casa_disc CHAR(10),
genere CHAR(10)
) ENGINE=INNODB;


CREATE TABLE Autore(
autore_id INT PRIMARY KEY auto_increment,
nome CHAR(20),
nazionalita CHAR(10)
) ENGINE=INNODB;


CREATE TABLE Composto_da(
disco INT,
autore INT,
FOREIGN KEY(disco) REFERENCES Disco(disco_id),
FOREIGN KEY(autore) REFERENCES Autore(autore_id)
) ENGINE=INNODB;



CREATE TABLE Negozio(
p_iva CHAR(10) PRIMARY KEY,
nome CHAR(20),
indirizzo CHAR(20),
citta CHAR(10)
) ENGINE=INNODB;



CREATE TABLE Vendita(
p_iva CHAR(10),
disco_id INT,
copie INT,
INDEX (p_iva),
INDEX (disco_id),
FOREIGN KEY(p_iva) REFERENCES Negozio(p_iva),
FOREIGN KEY(disco_id) REFERENCES Disco(disco_id)
) ENGINE=INNODB;


INSERT INTO Disco(titolo,casa_disc,genere) VALUES
('Titolo1', 'Casa1', 'Genere1'),
('Titolo2', 'Casa1', 'Genere2'),
('Titolo3', 'Casa2', 'Genere2'),
('Titolo4', 'Casa1', 'Genere1'),
('Titolo5', 'Casa3', 'Genere2'),
('Titolo6', 'Casa1', 'Genere3'),
('Titolo7', 'Casa3', 'Genere2'),
('Titolo8', 'Casa2', 'Genere3'),
('Titolo9', 'Casa3', 'Genere1'),
('Titolo10', 'Casa2', 'Genere1');


INSERT INTO Autore(nome,nazionalita) VALUES
('Nome1', 'Nazione1'),
('Nome2', 'Nazione2'),
('Nome3', 'Nazione3'),
('Nome4', 'Nazione1'),
('Nome5', 'Nazione2'),
('Nome6', 'Nazione3'),
('Nome7', 'Nazione1'),
('Nome8', 'Nazione2'),
('Nome9', 'Nazione3'),
('Nome10', 'Nazione1');


INSERT INTO Composto_da(disco,autore) VALUES
(1,2),
(2,1),
(2,2),
(3,7),
(3,10),
(4,4),
(5,8),
(6,1),
(7,2),
(7,6),
(8,9),
(9,2),
(10,5),
(10,7),
(10,9);


INSERT INTO Negozio(p_iva,nome,indirizzo,citta) VALUES
('Piva1','Negozio1','Indirizzo1','Citta1'),
('Piva2','Negozio2','Indirizzo2','Citta2'),
('Piva3','Negozio3','Indirizzo3','Citta1'),
('Piva4','Negozio4','Indirizzo4','Citta3'),
('Piva5','Negozio5','Indirizzo5','Citta2'),
('Piva6','Negozio6','Indirizzo6','Citta3');




INSERT INTO Vendita(p_iva,disco_id,copie) VALUES
('Piva1',1,3),
('Piva1',3,2),
('Piva2',2,1),
('Piva3',4,4),
('Piva4',5,2),
('Piva5',6,3),
('Piva1',7,1),
('Piva2',8,5),
('Piva3',9,3),
('Piva4',10,2),
('Piva5',2,6),
('Piva2',3,7),
('Piva3',6,5),
('Piva4',7,3),
('Piva5',3,5),
('Piva5',10,5);
