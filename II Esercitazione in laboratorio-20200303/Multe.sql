/*
drop database if exists Multe;
create database if not exists Multe;
use Multe;
*/

drop table if exists infrazioni;
drop table if exists auto;
drop table if exists agenti;


create table agenti(
matricola int primary key,
codfiscale char(16),
cognome char(10),
nome char(8)
) ENGINE=INNODB;



create table auto(
prov char(2),
numero char(6),
primary key(prov,numero),
proprietario char (20),
indirizzo char(15)
) ENGINE=INNODB;



create table infrazioni(
codice int auto_increment primary key,
data DATE,
agente int,
articolo int,
prov char(2),
numero char(6),
foreign key (agente) references agenti(matricola),
foreign key (prov,numero) references auto(prov,numero)
) ENGINE=INNODB;