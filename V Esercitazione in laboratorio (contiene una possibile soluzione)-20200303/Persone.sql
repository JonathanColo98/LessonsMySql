/*drop database if exists persone;
create database if not exists persone;
use persone;*/

drop table if exists paternita;
drop table if exists maternita;
drop table if exists persone;


create table if not exists persone(
nome char(15) primary key,
eta int,
reddito int
) ENGINE=INNODB;

insert into persone values
('andrea',27,21),
('aldo',25,15),
('maria',55,42),
('anna',50,35),
('filippo',26,30),
('luigi',50,40),
('franco',60,20),
('olga',30,41),
('sergio',85,35),
('luisa',75,87);


create table if not exists maternita(
madre char(15),
figlio char(15)
) ENGINE=INNODB;

insert into maternita values
('luisa','maria'),
('luisa','luigi'),
('anna','olga'),
('anna','filippo'),
('maria','andrea'),
('maria','aldo');


create table if not exists paternita(
padre char(15),
figlio char(15)
) ENGINE=INNODB;


insert into paternita values
('sergio','franco'),
('luigi','olga'),
('luigi','filippo'),
('franco','andrea'),
('franco','aldo');



