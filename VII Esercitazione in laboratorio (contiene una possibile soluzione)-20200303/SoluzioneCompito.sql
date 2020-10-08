############################################################################
################     II  prova intermedia 2013-2014        #################
############################################################################
#
# Cognome:
# Nome:
# Matricola:
#
############################################################################







############################################################################
################                 Query                     #################
############################################################################

-- 1) Per ogni visita effettuata nel 2014, trovare nome e cognome del paziente e la data e la descrizione della diagnosi.

select Pe.nome,Pe.cognome,Vi.des,Vi.data from Persone Pe, Pazienti Pa, Visite Vi
where Pe.codice_fiscale=Pa.cf_paziente and Pa.codice_assistito=Vi.codice_assistito and
Year(Vi.data)='2014' order by cognome;


-- 2) Trovare nome e cognome dei medici che hanno prescritto almeno una volta l'Aspirina.


select Pe.nome,Pe.cognome from persone Pe, pazienti Pa, visite Vi, ricette Ri where
Pe.codice_fiscale=Pa.cf_medico and Pa.codice_assistito=Vi.Codice_assistito and Vi.Idricetta=Ri.codice
and farmaco like '%Aspirina%';


-- 3) Per ogni ricetta con codice diverso da 0, elencare in un'unica tupla la data della prescrizione e
-- la descrizione di tutti i farmaci prescritti (suggerimento: usare la funzione GROUP_CONCAT).

select Codice, Data, Group_concat(farmaco order by farmaco separator ', ') as FarmaciPrescritti
from Ricette join Visite on Idricetta=Codice
group by Codice
having Codice<>0;



-- 4) Selezionare cognome e nome dei pazienti specificando se hanno gia' effettuato una visita (Visita si)
-- oppure no (Visita no).*/

select distinct Pe.nome, Pe.cognome, case
  when Vi.des is NULL then 'Visita no'
  else 'Visita si' end as StatoVisite
from Persone Pe join Pazienti Pa on Pe.codice_fiscale=Pa.cf_paziente left join Visite Vi
on Pa.codice_assistito=Vi.codice_assistito;


-- 5) Trovare i farmaci che sono stati prescritti in maggiore quantita' (SENZA USARE la funzione max e
-- SENZA USARE le opzioni order by e limit ma procedendo come in algebra relazionale)

-- Con le funzioni aggregate
select farmaco from ricette where quantita=(select max(quantita) from ricette);


create view Ricette2 as select codice as codice2, farmaco as farmaco2, quantita as quantita2
from Ricette;

select * from Ricette where quantita not in (select distinct quantita from Ricette join Ricette2 on Quantita<Quantita2);


-- 6) Selezionare il nome e cognome delle persone caratterizzate dal piu' elevato numero medio di confezioni di farmaci prescritti
-- durante le visite fatte col proprio medico (se necessario, usate una vista)

create view mediaconfezioni as select codice_assistito, avg(quantita) as media from visite join ricette on codice=idricetta group by codice_assistito;

select Pe.nome,Pe.cognome from persone Pe,pazienti Pa where Pe.codice_fiscale= Pa.cf_paziente
and Pa.codice_assistito in (select codice_assistito from mediaconfezioni
where media=(select max(media) from mediaconfezioni));


-- 7) Trovare il nome e il cognome dei pazienti che non hanno ancora effettuato una visita

-- not in

select nome, cognome from persone where codice_fiscale in
(select cf_paziente from pazienti where codice_assistito not in (select distinct codice_assistito from visite));

-- not exists


elect nome, cognome from persone Pe,pazienti  where codice_fiscale=cf_paziente and not exists
(select distinct codice_assistito,cf_paziente from pazienti natural join visite where cf_paziente=Pe.codice_fiscale);



-- 8) Trovare nome e cognome dei medici che ogni paziente visitato,  lo hanno visitato almeno 2 volte.

select nome,cognome from Persone join Pazienti on codice_fiscale=cf_medico where cf_medico not in
(select distinct cf_medico
from pazienti natural join visite group by codice_assistito
having count(*)<2);

-- 9) Trovare il farmaci che sono stati prescritti in almeno due ricette distinte senza utilizzare le funzioni aggregate.

-- Con le funzioni aggregate
select farmaco, group_concat(convert(codice,char)) from ricette group by farmaco having count(*)>=2;

select R1.farmaco from Ricette R1 join Ricette R2 on R1.farmaco=R2.farmaco where R1.codice<R2.codice;


-- 10) Trovare i farmaci che sono stati prescritti in almeno tre ricette distinte senza utilizzare le funzioni aggregate.

select R1.farmaco from Ricette R1 join Ricette R2 on R1.farmaco=R2.farmaco join Ricette R3 on R2.farmaco=R3.farmaco
where R1.codice<R2.codice and R2.codice<R3.codice;



############################################################################
################              Vista                        #################
############################################################################

-- Tramite l'uso di una vista, filtrare l'inserimento di una ricetta nella tabella Ricette in modo che non sia
-- possibile inserire la prescrizione di un farmaco corrispondente ad una quantita <0 oppure >4.


create view VistaRicette as
select codice, farmaco,quantita from Ricette
where quantita>=0 and quantita<=4
with local check option;



############################################################################
################             Funzione                      #################
############################################################################

-- Scrivere una funzione che dati in input il codice fiscale di una persona e un'anno
-- di riferimento restituisca il numero di visite effettuate dalla persona in quell'anno.



DELIMITER $$

CREATE FUNCTION Numero_Visite(cf VARCHAR(16), y YEAR)
RETURNS INT
BEGIN
 DECLARE num INT DEFAULT 0;
 SELECT count(*) into num from Visite natural join Pazienti where cf_paziente=cf and Year(data)=y;
 RETURN num;
END $$

DELIMITER ;



############################################################################
################              Procedura                    #################
############################################################################



DELIMITER $$

CREATE PROCEDURE Gestione_Dottore(cf VARCHAR(16), n VARCHAR(20), c VARCHAR(20), dn DATE, s CHAR(1))
BEGIN
 DECLARE d INT DEFAULT 0;
 IF (cf NOT IN (SELECT CF FROM Persone WHERE Persone.codice_fiscale=cf))
 THEN
	INSERT INTO Persone(codice_fiscale,nome,cognome,data_di_nascita,sesso) VALUES (cf,n,c,dn,s);
	ELSE UPDATE Persone SET nome=n, cognome=c, data_di_nascita=dn, sesso=s WHERE codice_fiscale=cf;
 END IF;
 SELECT count(*) into d FROM Dottori WHERE Dottori.codice_fiscale=cf;
 IF d=0
 THEN
	INSERT INTO Dottori(codice_fiscale) VALUES (cf);
 END IF;
END $$

DELIMITER ;


