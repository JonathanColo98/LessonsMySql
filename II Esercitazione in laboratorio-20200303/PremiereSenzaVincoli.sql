

create table if not exists Articoli(
NumArt char(4) primary key,
descrizione char(20),
giacenza int,
categoria char (2),
magazzino char (1),
PrzUnitario decimal(6,2)
);



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
);



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
CodR char(2) not null
);



create table if not exists Ordini(
NumOrdine char(6) primary key,
data date,
CodC char(4)				
);



create table if not exists DettagliOrdini(
NumOrdine char(6) not null,
NumArt char(4) not null,
primary key(NumOrdine,NumArt),
QtaOrd int,
Prezzo decimal(6,2) 
);
