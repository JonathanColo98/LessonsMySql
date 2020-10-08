############################################################################
################   Interrogazioni sul database Premiere    #################
############################################################################

#1 Elencare numero, descrizione e pezzi disponibili degli articoli per i quali
# il numero dei pezzi disponibili e' superiore alla disponibilita' media degli articoli.

select NumArt, descrizione, giacenza
from Articoli
where giacenza > (select avg(giacenza) from Articoli);

#2 Trovare gli articoli meno e piu' costosi. Risolvere la query con  e senza union.

-- con union
select * from Articoli
where PrzUnitario=(select min(przunitario) from Articoli)
union
select * from Articoli
where PrzUnitario=(select max(przunitario) from Articoli);

-- senza union
select * from Articoli
where PrzUnitario=(select min(przunitario) from Articoli) or PrzUnitario =(select max(przunitario) from Articoli);


#3 Trovare  numero, cognome e nome di ogni cliente che non ha emesso ordini il 5 settembre 2002.

select CodC, cognome, nome
from clienti
where CodC not in (select codC from ordini where data='2002-09-05');


#4 Trovare gli ordini in cui sono presenti tutti articoli con prezzo unitario maggiore di 20.
# Risolvere la query con l'operatore NOT EXISTS.

select * from Ordini O where not exists
(select * from dettagliordini D natural join articoli A
where O.numordine=D.Numordine and Przunitario <=20);


#5 Trovare nome e cognome dei clienti che hanno sempre ordinato  articoli in quantita' maggiore di 1.
# Risolvere la query con l'operatore NOT EXISTS e con NOT IN

create view ClientiConOrdini as
select distinct CodC, nome, cognome from clienti natural join Ordini;

-- con NOT EXISTS
select CodC, nome, cognome from ClientiConOrdiniC where not exists
(select * from ordini O natural join dettagliordini D
where Qtaord <=1 and C.CodC=O.CodC);

-- con NOT IN
select CodC, nome, cognome from ClientiConOrdini C where C.CodC not in
(select CodC from Clienti natural join Ordini natural join dettagliordini where Qtaord<=1);


#6 Trovare il codice dei clienti che hanno fatto almeno un ordine con tutti articoli in quantita' maggiore di 1.
# Risolvere la query con l'operatore NOT EXISTS

select distinct CodC from Ordini O where not exists
(select * from  dettagliordini D
where Qtaord <=1 and O.numordine=D.Numordine);


#7 Trovare il codice dei clienti che hanno fatto un ordine con almeno un articolo in quantita' maggiore di 2.
# Risolvere la query con l'operatore EXISTS

select distinct CodC from Ordini O where exists
(select * from  dettagliordini D
where Qtaord >2 and O.numordine=D.Numordine);



/*8 Scrivere la vista GrandiClienti che selezioni i
 clienti della tabella Clienti che hanno un saldo maggiore o uguale a
 500. Provare ad aggiornare la vista con e senza l'opzione WITH
 LOCAL CHECK OPTION. Sperimentare anche l'opzione WITH
CASCADED CHECK OPTION.*/

DROP VIEW IF EXISTS Grandiclienti;
CREATE VIEW GrandiClienti AS
select * from clienti where saldo>= 500
WITH local CHECK OPTION;

#Se si prova ad inserire o aggiornare (con update) un cliente con saldo<500 tramite la vista,
#con l'opzione  WITH LOCAL CHECK OPTION la modifica viene rifiutata.

#Se si toglie l'opzione WITH LOCAL CHECK OPTION e si riprova ad inserire o aggiornare
#lo stesso cliente, tramite la vista, la modifica verra' fatta nella tabella Clienti ma ovviamente non
#apparira' nella vista.

#Per sperimentare l'opzione WITH cascaded CHECK OPTION e' necessario definire una vista sulla vista Grandiclienti


/*9 Scrivere una vista che permetta di realizzare il seguente vincolo sulla tabella Articoli:
la giacenza di un articolo deve sempre essere maggiore di 1 e il prezzo unitario non puo' essere una quantita' minore o uguale a zero;
unica eccezione per gli articoli della categoria elettrodomestici per i quali e' ammesso che la giacenza possa essere 0. */

CREATE VIEW CHECKArticoli as
select * from Articoli
where (giacenza>1 and PrzUnitario >0) or (categoria='el' and giacenza>=0 and PrzUnitario >0)
WITH local CHECK OPTION;






############################################################################
################  Interrogazioni sul database NegoziDischi #################
############################################################################


# 1) Partita iva dei negozi che del disco di codice 3 hanno venduto piu' di 2 copie

select p_iva from Vendita where disco_id=3 and copie>2;

# 2) Nome, indirizzo e citta' dei negozi che del disco di codice 3 hanno venduto piu' di 2 copie

select nome, indirizzo, citta from Negozio natural join Vendita where disco_id=3 and copie>2;


# 3) Nome, indirizzo e citta' dei negozi che hanno venduto piu' di 2 copie di un disco di titolo 'Titolo3'

select nome, indirizzo, citta from Negozio natural join Vendita natural join Disco
where titolo='Titolo3' and copie>2;


# 4) Partita iva dei negozi che hanno venduto piu' di 4 copie di un qualche disco

select distinct p_iva from Vendita where copie>4;


# 5) Partita iva dei negozi che hanno venduto 4 copie, o meno di 4 copie, di un qualche disco


select distinct p_iva from Vendita where copie<=4;


# 6) Partita iva dei negozi che di ogni disco che hanno venduto, ne hanno venduto piu' di 2 copie, o in altre parole
# partita iva dei negozi che non hanno mai venduto 2 copie, o meno, di nessun disco


select distinct p_iva from Vendita where p_iva not in (select distinct p_iva from Vendita where copie<=2);


# 7) I titoli dei dischi di cui almeno un autore e' di nazionalita 'Nazione2'

select * from Disco join Composto_da on disco_id=disco join Autore on autore=autore_id;

select titolo from Disco join Composto_da on disco_id=disco join Autore on autore=autore_id
where nazionalita='Nazione2';


# 8) I codici dei dischi di cui almeno un autore ha nazionalita' diversa da 'Nazione2'

select distinct disco from Composto_da join Autore on autore=autore_id where nazionalita<>'Nazione2';

# 9) I codici dei dischi di cui tutti gli autori hanno nazionalita 'Nazione2'
# (da tutti i dischi vengono tolti quelli per cui almeno un autore ha nazionalita' diversa da 'Nazione2')


select disco_id from Disco where disco_id not in (select distinct disco from Composto_da
join Autore on autore=autore_id where nazionalita<>'Nazione2');


# 10) Si vuole il valore massimo che compare nella colonna copie della tabella Vendita

# Soluzione con max

select max(copie) from Vendita;

# Soluzione senza max: da tutti i valori presenti nella colonna si tolgono quelli che sono minori di qualcun altro

create view Vendita2 as select p_iva as P_iva2, disco_id as disco_id2, copie as copie2 from Vendita;

select distinct copie from Vendita join Vendita2 on copie<copie2;

select copie from Vendita where copie not in (select distinct copie from Vendita join Vendita2 on copie<copie2);


# 11) L’elenco di tutti i negozi (che hanno venduto dischi) insieme ai dischi venduti

select * from Negozio natural join Vendita;


# 12) L’elenco di tutti i dischi insieme alle informazioni che riguardano i loro autori


select * from Disco join Composto_da on disco_id=disco join Autore on autore=autore_id;


# 13) La partita iva dei negozi che hanno venduto qualche disco

select distinct p_iva from Vendita;

# 14) La partita iva dei negozi che non hanno venduto nessun disco

select p_iva from Negozio where p_iva not in (select distinct p_iva from Vendita);

# 15) La partita iva e la città dei negozi che non hanno venduto nessun disco


select p_iva,citta from Negozio where p_iva not in (select distinct p_iva from Vendita);


# 16) La partita iva dei negozi che non hanno venduto tutti i dischi dell’elenco

create view CoppiePivaId as select p_iva,disco_id from (select p_iva from Negozio) as PivaN join (select disco_id from Disco) as IdDisco;

select p_iva from CoppiePivaId as C where not exists (select p_iva,disco_id from vendita where p_iva=C.p_iva and disco_id=C.disco_id);


create view  PivaDiscoV as select distinct p_iva, disco_id from Vendita;

select p_iva from PivaDiscoV group by p_iva having count(disco_id)<(SELECT count(*) FROM disco)
union select p_iva from Negozio where p_iva not in (select p_iva from vendita);


# 17) La partita iva dei negozi che hanno venduto tutti i dischi dell’elenco

select p_iva from VendutePivaDisco group by p_iva having count(disco_id)=(SELECT count(*) FROM disco);


#  18) La partita iva dei negozi che hanno venduto più di un tipo di disco, ovvero la partita iva dei negozi che
# hanno venduto almeno due dischi diversi, ovvero la partita iva dei negozi che compaiono nella tabella VENDITA almeno due volte;
# l'attributo copie non interessa


create view Vendi as select p_iva,disco_id  from Vendita;
create view Xvendi as select p_iva,disco_id as Xdisco_id  from Vendita;
create view Coppie as select * from vendi natural join Xvendi;
select p_iva from Coppie where disco_id<Xdisco_id;



select p_iva from Vendita group by p_iva having count(disco_id)>2;


# 19) La partita iva dei negozi che hanno venduto un solo tipo di disco, ovvero la partita iva dei negozi che
# compaiono nella tabella VENDITA una sola volta.

# Sono tutti i negozi (che hanno venduto qualcosa) meno quelli che hanno venduto almeno due dischi diversi.


select p_iva from Vendita group by p_iva having count(disco_id)=1;

select p_iva from Vendita where p_iva not in (select p_iva from Coppie where disco_id<>Xdisco_id);



# 20) Le citta' dei negozi che hanno venduto un solo tipo di disco


select distinct citta from Negozio where p_iva in(select p_iva from Vendita group by p_iva having count(disco_id)=1);


# 21) Il codice dei dischi venduti solo nella citta' Citta1

select disco_id from Vendita where disco_id not in (select distinct disco_id from Vendita natural join Negozio where citta<>'Citta1');




############################################################################
################   Interrogazioni sul database Persone     #################
############################################################################


-- 1) Trovare i nomi delle persone con entrambi i genitori.

select * from paternita natural join maternita;

select Nome, Padre, Madre
from Paternita, Persone, Maternita
where Paternita.figlio=Nome and Maternita.figlio=Nome;

create view PadreFiglio as select padre,figlio from Paternita join Persone on Paternita.figlio=Nome ;
select * from PadreFiglio natural join Maternita;



-- 2) Trovare il nome e l'eta' dei figli di Anna.

select figlio,eta from persone join maternita on nome=figlio where madre='Anna';


-- 3) Trovare i nomi delle persone che guadagnano piu'
-- della propria madre, mostrando anche il reddito della madre.


select P2.Nome, P2.Reddito as Reddito, P1.Reddito as RM
from Persone P1, Maternita, Persone P2
where P1.Nome=Madre and Figlio=P2.Nome
and P2.Reddito>P1.reddito;


-- 4) Trovare i nomi delle persone con almeno due figli. Risolvere la query in due modi: a) con join e senza l'uso
-- di operatori aggregati e b) con gli opertori aggregati.


create view Padrecon2 as select P1.padre as genitore,P1.figlio as figlio1 ,P2.figlio as figlio2
from paternita P1,paternita P2
where P1.padre=P2.padre and P1.figlio<P2.figlio;

create view Madrecon2 as select M1.madre as genitore,M1.figlio as figlio1,M2.figlio as figlio2
from maternita M1,maternita M2
where M1.madre=M2.madre and M1.figlio<M2.figlio;

select genitore from Padrecon2 union select genitore from Madrecon2;


-- 5) Trovare i nomi delle persone il cui padre guadagna piu' della madre.


create view PaternitaReddito as select padre,figlio,reddito as redditoP
from Paternita,Persone where padre=nome;
create view MaternitaReddito as select madre,figlio,reddito as redditoM
from Maternita,Persone where madre=nome;

select Figlio from PaternitaReddito natural join MaternitaReddito where redditoP>redditoM;


-- 6) Trovare i nomi delle donne che hanno avuto figli con padri diversi.

insert into paternita values
('tizio','maria'),
('caio','luigi');


select A.madre from
(select  madre,count(distinct padre) as NumP from paternita natural join maternita group by madre) as  A
where A.NumP>1;


create view PM as select distinct padre,madre from paternita natural join maternita;
select distinct PM1.madre from PM as PM1,PM as PM2 where PM1.madre=PM2.madre and PM1.padre<>PM2.padre;


-- 7) Trovare i nomi delle donne che hanno avuto un figlio prima dei 30 anni.

select distinct madre from persone M,maternita,persone F
where M.nome=madre and F.nome=figlio and (M.eta-F.eta<30);

-- 8) Trovare le coppie nipote/nonno-materno.

select padre,maternita.figlio from paternita,maternita where paternita.figlio=madre;

