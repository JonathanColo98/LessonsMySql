
###########################################################################################
################        Interrogazioni semplici  su Premiere              #################
###########################################################################################

#1) Elencare il codice cliente, il codice rappresentante e il saldo di ogni cliente, ordinando
# il risultato in base al numero del rappresentante.



#2) Trovare eventuali articoli per i quali la descrizione non sia nota.




#3) Elencare i primi 5 articoli ordinati in base alla descrizione.



#4 Elencare numero e descrizione di ciascun articolo la cui classe sia 'cs' o 'sp' (usare in)



#5) Trovare  codice, cognome e nome di ogni cliente che non ha emesso ordini il 5 settembre 2002.





#6) Elencare, in caratteri maiuscoli (si usi la funzione upper), nome e cognome di tutti i clienti
# il cui cognome inizia per 'D' o il cui nome termina con 'n'.




#7) Elencare nome e cognome di tutti i clienti che hanno la terza cifra del CAP uguale a '2' (si usi la funzione substring).




#8) Elencare descrizione e categoria degli articoli la cui descrizione inizia con la lettera 'f'.



#9) Elencare, per ogni cliente, la lunghezza totale del suo nome e cognome (si usi la funzione length).




#10) Elencare il codice articolo, la categoria, il prezzo unitario e la giacenza
# degli articoli ordinandoli per categoria e descrizione.



#11) Trovare il numero di articoli in ogni categoria



#12) Elencare la somma dei saldi di tutti i clienti di ogni rappresentante, ordinando  il risultato
#in base al numero del rappresentante.




#13) Elencare il codice del rappresentante, il numero di clienti e
# il saldo medio dei clienti che hanno lo stesso rappresentante.




#14) Elencare le categorie degli articoli e  il prezzo complessivo   del valore dei pezzi disponibili.




#15) Quanti clienti ci sono nel database?



#16) Trovare nome, cognome e fido dei clienti che hanno un fido minore del fido medio di tutti i clienti




#17) Trovare nome, cognome e fido dei clienti che hanno un cognome che termina con la lettera 's'.
# e un fido minore del fido medio di tutti i clienti.





#18)  Elencare numero, descrizione e giacenza dagli articoli per i quali
# la giacenza è superiore alla giacenza media




#19) Trovare l'articolo meno costoso



#20) Trovare l'articolo più costoso




#21) Elencare il codice e il totale di ciascun ordine.




#22) Elencare il codice e il totale di ciascun ordine contenente almeno due articoli diversi.




#23) Per ogni categoria di articolo elencare in un'unica tupla ListaArticoli, la descrizione degli articoli
# in ordine lessicografico (usare la funzione group_concat).





###########################################################################################
################     Interrogazioni semplici con join su Premiere         #################
###########################################################################################

#1) Per ogni ordine, elencare numero ordine e data ordine insieme al codice,
# cognome e nome del cliente che ha emesso l'ordine.

#1.a) join naturale


#1.b) join esplicito


#1.c) join implicito



#2) Per ogni ordine emesso il 5/9/2002, elencare numero ordine e data ordine insieme al codice,
# cognome e nome del cliente che ha emesso l'ordine.




#3) Per ogni ordine, elencare numero ordine, data ordine, numero articolo, quantita ordinata
# e prezzo  per ciascuna riga che compone l'ordine.



#4) Per ogni ordine, elencare numero ordine, data ordine, numero articolo, descrizione articolo
#e categoria articolo per ciascun articolo che compone l'ordine.




#5) Trovare codice, cognome e nome di ogni cliente  che al momento ha un ordine per un ferro da stiro.






