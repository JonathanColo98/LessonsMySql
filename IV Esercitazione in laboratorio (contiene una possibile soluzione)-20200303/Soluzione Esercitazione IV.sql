
###########################################################################################
################        Interrogazioni semplici  su Premiere              #################
###########################################################################################

#1) Elencare il codice cliente, il codice rappresentante e il saldo di ogni cliente, ordinando
# il risultato in base al numero del rappresentante.

SELECT codc,codr, saldo FROM clienti c order by codr;


#2) Trovare eventuali articoli per i quali la descrizione non sia nota.

select NumArt
from Articoli
where descrizione is NULL;


#3) Elencare i primi 5 articoli ordinati in base alla descrizione.

select *
from articoli
order by descrizione
limit 5;


#4 Elencare numero e descrizione di ciascun articolo la cui classe sia 'cs' o 'sp' (usare in)

select NumArt, descrizione
from Articoli
where categoria in('cs','sp');


#5) Trovare  codice, cognome e nome di ogni cliente che non ha emesso ordini il 5 settembre 2002.

select CodC, cognome, nome
from clienti
where CodC not in (select codC from ordini where data='2002-09-05');



#6) Elencare, in caratteri maiuscoli (si usi la funzione upper), nome e cognome di tutti i clienti
# il cui cognome inizia per 'D' o il cui nome termina con 'n'.

select upper(nome),upper(cognome) from Clienti
where cognome like 'D%' or nome like'%n';


#7) Elencare nome e cognome di tutti i clienti che hanno la terza cifra del CAP uguale a '2' (si usi la funzione substring).

select nome,cognome from Clienti
where substring(cap,3,1)='2';


#8) Elencare descrizione e categoria degli articoli la cui descrizione inizia con la lettera 'f'.

SELECT descrizione, categoria FROM articoli where descrizione like 'f%';

#9) Elencare, per ogni cliente, la lunghezza totale del suo nome e cognome (si usi la funzione length).

select nome,cognome,(length(nome)+length(cognome)) Totlettere
from Clienti;


#10) Elencare il codice articolo, la categoria, il prezzo unitario e la giacenza
# degli articoli ordinandoli per categoria e descrizione.

SELECT numart, categoria, przunitario, giacenza from articoli order by categoria, descrizione asc;

#11) Trovare il numero di articoli in ogni categoria

SELECT count(*), categoria from articoli group by categoria;

#12) Elencare la somma dei saldi di tutti i clienti di ogni rappresentante, ordinando  il risultato
#in base al numero del rappresentante.

select CodR, sum(saldo)
from Clienti
group by CodR
order by CodR;


#13) Elencare il codice del rappresentante, il numero di clienti e
# il saldo medio dei clienti che hanno lo stesso rappresentante.

SELECT codR, count(*), avg(saldo) from clienti group by codR;


#14) Elencare le categorie degli articoli e  il prezzo complessivo   del valore dei pezzi disponibili.

select categoria, sum(giacenza*przunitario)
from Articoli
group by categoria;


#15) Quanti clienti ci sono nel database?

select count(*)
from Clienti;

#16) Trovare nome, cognome e fido dei clienti che hanno un fido minore del fido medio di tutti i clienti

select  nome, cognome, fido from clienti where fido <= (select avg(fido) from clienti);


#17) Trovare nome, cognome e fido dei clienti che hanno un cognome che termina con la lettera 's'.
# e un fido minore del fido medio di tutti i clienti.

select  nome, cognome, fido from clienti where cognome like '%s' and fido <= (select avg(fido) from clienti);



#18)  Elencare numero, descrizione e giacenza dagli articoli per i quali
# la giacenza è superiore alla giacenza media

select NumArt, descrizione, giacenza
from Articoli
where giacenza > (select avg(giacenza) from Articoli);


#19) Trovare l'articolo meno costoso

select * from Articoli
where PrzUnitario=(select min(przunitario) from Articoli);

#20) Trovare l'articolo più costoso

select * from Articoli
where PrzUnitario =(select max(przunitario) from Articoli);


#21) Elencare il codice e il totale di ciascun ordine.
# Attenzione, il Prezzo in dettagliordini non e' quello unitario, come si vede dalla tabella articoli

SELECT NumOrdine, SUM(Prezzo)
FROM DettagliOrdini
GROUP BY NumOrdine;


#22) Elencare il codice e il totale di ciascun ordine contenente almeno due articoli diversi.

SELECT NumOrdine, SUM(Prezzo), count(*)
FROM DettagliOrdini
GROUP BY NumOrdine
having count(*)>=2;


#23) Per ogni categoria di articolo elencare in un'unica tupla ListaArticoli, la descrizione degli articoli
# in ordine lessicografico (usare la funzione group_concat).


SELECT categoria, group_concat(descrizione order by descrizione) as ListaArticoli FROM  articoli group by categoria;


###########################################################################################
################     Interrogazioni semplici con join su Premiere         #################
###########################################################################################

#1) Per ogni ordine, elencare numero ordine e data ordine insieme al codice,
# cognome e nome del cliente che ha emesso l'ordine.

#1.a) join naturale
select O.NumOrdine,O.Data, C.CodC,C.cognome,C.nome
from ordini O natural join clienti C;

#1.b) join esplicito
select O.NumOrdine,O.Data, C.CodC,C.cognome,C.nome
from ordini O join clienti C on O.codc = C.codc ;

#1.c) join implicito
select O.numordine,O.data,O.codc,C.cognome,C.nome
from ordini O, clienti C where O.codc = C.codc;


#2) Per ogni ordine emesso il 5/9/2002, elencare numero ordine e data ordine insieme al codice,
# cognome e nome del cliente che ha emesso l'ordine.


select O.NumOrdine,O.Data, C.CodC,C.cognome,C.nome
from ordini O natural join clienti C
where O.data ='2002-09-05';

#3) Per ogni ordine, elencare numero ordine, data ordine, numero articolo, quantita ordinata
# e prezzo  per ciascuna riga che compone l'ordine.

select NumOrdine,data, NumArt,QtaOrd, Prezzo
from ordini natural join dettagliordini;


#4) Per ogni ordine, elencare numero ordine, data ordine, numero articolo, descrizione articolo
#e categoria articolo per ciascun articolo che compone l'ordine.

select NumOrdine, data, NumArt, descrizione, categoria
from ordini natural join dettagliordini natural join articoli;


#5) Trovare codice, cognome e nome di ogni cliente  che al momento ha un ordine per un ferro da stiro.

select distinct(CodC), cognome, nome
from clienti natural join ordini natural join dettagliordini natural join articoli
where descrizione='ferro da stiro';




