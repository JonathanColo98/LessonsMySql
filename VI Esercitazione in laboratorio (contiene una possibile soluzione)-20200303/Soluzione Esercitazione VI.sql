#####################################################################################
####  Selezioni su Premiere che utilizzano funzioni per il controllo del flusso  ####
#####################################################################################

/*1 Elencare la descrizione di tutti gli articoli con indicazione esplicita della categoria
 di appartenenza (ad esempio 'casalinghi' al posto di 'cs'). Ordinare rispetto a categoria e descrizione. */



select descrizione, case
when categoria='el' then "Elettrodomestici"
when categoria='cs' then "Casalinghi"
when categoria='sp' then "Sportivi"
end as categoria
from Articoli order by categoria,descrizione;

/*2 Scrivere una interrogazione che restituisca per ogni ordine il numero totale di  articoli in ogni  categoria. */


# Provare prima questa query

select NumOrdine,
if(categoria="el", QtaOrd, 0) as Elettrodomestici,
if(categoria="cs", QtaOrd, 0) as Casalinghi,
if(categoria="sp", QtaOrd, 0) as ArticoliSportivi
from dettagliordini natural join articoli order by Numordine;

# e poi questa

select NumOrdine,
sum(if(categoria="el", QtaOrd, 0)) as Elettrodomestici,
sum(if(categoria="cs", QtaOrd, 0)) as Casalinghi,
sum(if(categoria="sp", QtaOrd, 0)) as ArticoliSportivi
from dettagliordini natural join articoli group by Numordine;





######################################################################
##########             PROCEDURE E FUNZIONI                 ##########
######################################################################


/*1 La seguente procedura prende in ingresso una categoria di articoli e restituisce la
descrizione degli articoli corrispondenti. */

DELIMITER $$
DROP PROCEDURE IF EXISTS DescrizioneArticoli $$
CREATE PROCEDURE DescrizioneArticoli(c CHAR(2))
SELECT descrizione
FROM articoli
WHERE categoria = c $$
DELIMITER ;
CALL DescrizioneArticoli('el');


/*2 Scrivere una procedura che dati in ingresso il nome e il cognome di un cliente selezioni la descrizione e la
quantita' degli articoli eventualmente ordinati. La procedura
deve inoltre restituire in un parametro di uscita il numero totale di articoli ordinati dal cliente. */




DELIMITER $$
drop procedure if exists P1$$
CREATE PROCEDURE P1(in n char(8), in c char(10), out qta int)
begin
declare tmp int;
select descrizione,qtaord
from Dettagliordini natural join Articoli natural join Clienti natural join Ordini
where nome=n and cognome=c;
select sum(qtaord) into tmp
from Dettagliordini natural join Articoli natural join Clienti natural join Ordini
where nome=n and cognome=c;
set qta=tmp;
end $$
DELIMITER ;

/*
start transaction;
CALL P1('Sally','Adams',@pp);
select @pp;
*/



/*3 La seguente funzione restituisce la stringa ’My name is Premiere’, nessun parametro
in ingresso.  */


DELIMITER $$
DROP FUNCTION IF EXISTS Provaf $$
CREATE FUNCTION Provaf() RETURNS VARCHAR(30)
RETURN 'My name is Premiere' $$
DELIMITER ;

SELECT Provaf();

/*4 Periodicamente il prezzo degli articoli presenti nel db
Premiere puo' subire un aumento. Scrivere una procedura
che dati in ingresso 1) un parametro stringa  e 2) l'aumento percentuale, aggiorni automaticamente i campi della tabella Articoli e visualizzi il contenuto della tabella cosi' modificata secondo i seguenti criteri: la procedura deve aggiornare  un articolo, se il primo parametro contiene la descrizione di un articolo, deve aggiornare tutti gli articoli di una categoria, se il primo parametro contiene la categoria da aggiornare e, infine, deve aggiornare tutti gli articoli, se il primo parametro e' all. */



/*La procedura aggiorna un articolo se il primo parametro contiene la descrizione di un articolo
(es: call P2('freccette',10);)
Aggiorna tutti gli articoli di una categoria se il primo parametro contiene la categoria da aggiornare
(es: call P2('el',10);)
Aggiorna tutti gli articoli se il primo parametro contiene 'all'
(call P2('all',10);) */

DELIMITER $$
drop procedure if exists P2 $$
CREATE PROCEDURE P2(in descr char(20),in per decimal(6,2))
begin
case descr
when 'el'  then update Articoli set przunitario=przunitario*(1+(per/100)) where categoria=descr;
when 'sp'  then update Articoli set przunitario=przunitario*(1+(per/100)) where categoria=descr;
when 'cs'  then update Articoli set przunitario=przunitario*(1+(per/100)) where categoria=descr;
when 'all' then update Articoli set przunitario=przunitario*(1+(per/100));
else update Articoli set przunitario=przunitario*(1+(per/100)) where descrizione=descr;
end case;
select * from Articoli;
end $$
DELIMITER ;

/*5 Scrivere un procedura che dato in ingresso il parametro data elimini dalle tabelle Ordini e DettagliOrdini
tutti i riferimenti ad ordini effettuati prima di quella data e memorizzi questi valori nelle tabelle BackupOrdini e
BackupDettagli, dopo averle create. */


DELIMITER $$

DROP PROCEDURE IF EXISTS P3 $$
CREATE PROCEDURE P3(in dt date)
begin
-- drop table if exists BackupOrdini;
create table  if not exists BackupOrdini like Ordini;
-- drop table if exists BackupDettagli;
create table  if not exists BackupDettagli like Dettagliordini;
insert into BackupOrdini select * from Ordini where data<dt;
insert into BackupDettagli select BackupOrdini.numordine,numart,qtaord,prezzo from BackupOrdini natural join Dettagliordini;
delete from Dettagliordini where numordine in (select numordine from Ordini where data<dt);
delete from Ordini where data<dt;
end $$

DELIMITER ;




/*6 Scrivere una procedura che permetta di inserire nuovi clienti nella tabella Clienti. Nella procedura deve essere definito un handler di tipo exit per l'errore SQLSTATE '23000' (Cannot add or update a child row: a foreign key constraint fails) in modo da gestire la violazione del vincolo di integrita' referenziale tra la tabella Clienti e la tabella Rappresentanti. */


DELIMITER $$

DROP PROCEDURE IF EXISTS P5 $$
CREATE PROCEDURE P5(in codc char(4),in cogn char(10),in nom char(8),in via char(15),in cit char(15),
in prov char(2),in cap char(5),in sal decimal(6,2),in fid decimal(6,2),in codr char(2))
begin
declare exit handler for SQLSTATE '23000'
	select concat(current_date,': inserimento rifiutato,violazione vincolo di integrita referenziale') as Errore;
insert into clienti values(codc,cogn,nom,via,cit,prov,cap,sal,fid,codr);
end $$

DELIMITER ;

#Soluzione alternativa

/*
DROP TABLE IF EXISTS Error;
CREATE TABLE Error (msg char(100))
engine=innodb;


DELIMITER $$

DROP PROCEDURE IF EXISTS P5 $$

CREATE PROCEDURE P5(coC char(4), cog char(10), nom char(8), v char(15), cit char(15),
 pro char(2), c char(5), sal decimal(6,2), fid decimal(6,2), coR char(2))
begin
declare EXIT handler for sqlstate '23000'
	insert into error values(concat('Il rappresentante ',coR,' non esiste'));
insert into clienti values(coC, cog, nom, v, cit, pro, c, sal, fid, coR);

end$$

DELIMITER ;
*/



/*7 stato di errore dell'esercizio 4) corrisponde anche al codice di errore MySQL numero 1452. Modificare la procedura del punto 4) facendo riferimento a questo codice invece che al
 codice SQLSTATE. */


DELIMITER $$

DROP PROCEDURE IF EXISTS P6 $$
CREATE PROCEDURE P6(in codc char(4),in cogn char(10),in nom char(8),in via char(15),
 in cit char(15),in prov char(2),in cap char(5),in sal decimal(6,2),in fid decimal(6,2),in codr char(2))
begin
declare exit handler for 1452
	select concat(current_date,': inserimento rifiutato,violazione vincolo di integrita referenziale') as Errore;
insert into clienti values(codc,cogn,nom,via,cit,prov,cap,sal,fid,codr);
end $$

DELIMITER ;


/*8 MySQL e' possibile assegnare un qualsiasi altro nome ad
 uno stato di errore SQLSTATE o ad un codice di errore MySQL.
Modificare la procedura del punto 4) definendo l'handler
dopo aver assegnato allo stato di errore SQLSTATE '23000'
il nome 'Violazione vincolo'. */


DELIMITER $$

DROP PROCEDURE IF EXISTS P7 $$
CREATE PROCEDURE P7(in codc char(4),in cogn char(10),in nom char(8),in via char(15),
 in cit char(15),in prov char(2),in cap char(5),in sal decimal(6,2),in fid decimal(6,2),in codr char(2))
begin
declare Violazione_vincolo condition for sqlstate '23000';
declare exit handler for Violazione_vincolo
	select concat(current_date,': inserimento rifiutato,violazione vincolo di integrita referenziale') as Errore;
insert into clienti values(codc,cogn,nom,via,cit,prov,cap,sal,fid,codr);
end $$

DELIMITER ;






######################################################################
##########                     TRIGGER                      ##########
######################################################################


/*1 Definire i trigger Check_prezzo_ins e
Check_prezzo_upd sulla tabella Articoli che assegnino valore 0 al PrzUnitario qualora si tenti di inserire o aggiornare  tale campo con un valore negativo. */


DROP TRIGGER IF EXISTS Check_prezzo_ins;
DELIMITER $$
CREATE TRIGGER Check_prezzo_ins
BEFORE INSERT ON Articoli
FOR EACH ROW
IF (NEW.PrzUnitario < 0) THEN SET NEW.PrzUnitario=0;
END IF $$
DELIMITER ;


DROP TRIGGER IF EXISTS Check_prezzo_upd;
DELIMITER $$
CREATE TRIGGER Check_prezzo_upd
BEFORE UPDATE ON Articoli
FOR EACH ROW
IF (NEW.PrzUnitario < 0) THEN SET NEW.PrzUnitario=0;
END IF $$
DELIMITER ;

/*2 Si vuole tenere un'anagrafica di tutte le scritture sulla tabella Articoli.
Si definisca la tabella LogArt con i seguenti attributi:
- un identificatore univoco;
- data e ora della scrittura;
- identificativo univoco del record cui si riferisce la scrittura;
- operazione effettuata: I=Inserimento, M=Modifica, C=Cancellazione.
Definire quindi i trigger Ana_Art_I, Ana_Art_U, Ana_Art_D
che inseriscano una nuova riga nella tabella LogArt in corrispondenza di
operazioni di inserimento, aggiornamento e cancellazione sulla
tabella Articoli. (Si usi la funzione NOW() per inserire data e ora della scrittura). */



DROP TABLE IF EXISTS LogArt;
CREATE TABLE IF NOT EXISTS LogArt(
Id int auto_increment PRIMARY KEY,
data datetime,
NumArt char(4),
op char(1) )
ENGINE=INNODB;


DROP TRIGGER IF EXISTS Ana_Art_I;
CREATE TRIGGER Ana_Art_I
AFTER INSERT ON Articoli
FOR EACH ROW
INSERT INTO LogArt(data,NumArt,op)
VALUES(NOW(), NEW.NumArt, 'I');


DROP TRIGGER IF EXISTS Ana_Art_U;
CREATE TRIGGER Ana_Art_U
AFTER UPDATE ON Articoli
FOR EACH ROW
INSERT INTO LogArt(data,NumArt,op)
VALUES(NOW(), OLD.NumArt, 'M');


DROP TRIGGER IF EXISTS Ana_Art_D;
CREATE TRIGGER Ana_Art_D
AFTER DELETE ON Articoli
FOR EACH ROW
INSERT INTO LogArt(data,NumArt,op)
VALUES(NOW(), OLD.NumArt, 'C');