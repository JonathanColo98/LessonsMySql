/*drop database if exists Premiere;
create database if not exists Premiere;
use Premiere;
*/

-- Creazione

drop table if exists DettagliOrdini;
drop table if exists Ordini;
drop table if exists Clienti;
drop table if exists Rappresentanti;
drop table if exists Articoli;


create table if not exists Articoli(
NumArt char(4) primary key,
descrizione char(20),
giacenza int,
categoria char (2),
magazzino char (1),
PrzUnitario decimal(6,2)
) ENGINE=INNODB;



create table if not exists Rappresentanti(
CodR char(2) primary key,
cognome char(10),
nome char(8),
via char (15),
citta char(15),
prov char(2),
cap char (5),
TotProvv decimal(6,2),
PerProvv decimal(6,2)
) ENGINE=INNODB;



create table if not exists Clienti(
CodC char(4) primary key,
cognome char(10),
nome char(8),
via char (15),
citta char(15),
prov char(2),
cap char (5),
saldo decimal(6,2),
fido decimal(6,2),
CodR char(2) not null,
foreign key (CodR) references Rappresentanti(CodR)
) ENGINE=INNODB;



create table if not exists Ordini(
NumOrdine char(6) primary key,
data date,
CodC char(4),
foreign key (CodC) references clienti(CodC) on delete cascade				
) ENGINE=INNODB;



create table if not exists DettagliOrdini(
NumOrdine char(6) not null,
NumArt char(4) not null,
primary key(NumOrdine,NumArt),
foreign key(NumOrdine) references Ordini(NumOrdine),
foreign key(NumArt) references Articoli(NumArt),
QtaOrd int,
Prezzo decimal(6,2) 
) ENGINE=INNODB;


-- Popolamento

                     
insert into Articoli values
('AX12','ferro da stiro',104,'cs','3',24.95),
('AZ52','freccette',20,'sp','2',12.95),
('BA74','pallone',40,'sp','1',29.95),
('BH22','tritatutto',05,'cs','3',24.95),
('BT04','forno',11,'el','2',149.49),
('BZ66','lavatrice',52,'el','3',399.99),
('CA14','setaccio',78,'cs','3',39.99),
('CB03','bicicletta',44,'sp','1',299.99),
('CX11','frullino',142,'cs','3',22.95),
('CZ81','tavola pesi',68,'sp','2',349.95);

insert into Rappresentanti values
('03','Jones','Mary','123 Main','Grant','MI','49219',215,5),
('06','Smith','William','102 Raymond','Ada','MI','49441',4912.5,7),
('12','Diaz','Miguel','419 Harper','Lansing','MI','49224',2150,5);

insert into Clienti values
('124','Adams','Sally','481Oak','Lansing','MI','49224',818.75,1000,'03'),
('256','Samuel','Ann','215Pete','Grant','MI','49219',21.5,1500,'06'),
('311','Charles','Don','48College','Ira','MI','49034',825.75,1000,'12'),
('315','Daniels','Tom','914Charry','Kent','MI','48391',770.75,750,'06'),
('405','Williams','Al','519Watson','Grant','MI','49219',402.75,1500,'12'),
('412','Adams','Sally','16Elm','Lansing','MI','49224',1817.5,2000,'03'),
('522','Nelson','Mary','108Pine','Ada','MI','49441',98.75,1500,'12'),
('567','Dinh','Tran','808Ridge','Harper','MI','48421',402.4,750,'06'),
('587','Galvez','Mara','512Pine','Ada','MI','49441',114.6,1000,'06'),
('622','Martin','Dan','419Chip','Grant','MI','49219',1045.75,1000,'03');

insert into  Ordini values
('12489','2002-09-02','124'),
('12491','2002-09-02','311'),
('12494','2002-09-04','315'),
('12495','2002-09-04','256'),
('12498','2002-09-05','522'),
('12500','2002-09-05','124'),
('12504','2002-09-05','522');

insert into DettagliOrdini values
('12489','AX12',11,274.45),
('12491','BT04',1,149.99),
('12491','BZ66',1,399.99),
('12494','CB03',4,1199.99),
('12495','CX11',2,45.90),
('12498','AZ52',2,25.90),
('12498','BA74',4,119.80),
('12500','BT04',1,149.49),
('12504','CZ81',2,699.90);