insert into agenti values
(567,'RSSM','Rossi','Mario'),
(456,'NREL','Neri','Luigi'),
(638,'NREP','Neri','Piero');

insert into auto values
('FI','2F7643','Verdi Piero','Via Tigli'),
('FI','1A2396','Verdi Piero','Via Tigli'),
('FI','4E5432','Bini Luca','Via Aceri'),
('MI','2F7643','Bianchi Gino','Via Aceri');

insert into infrazioni(data,agente,articolo,prov,numero) values
('2005-10-25',567,44,'FI','4E5432'),
('2005-10-26',456,34,'FI','4E5432'),
('2005-10-26',456,34,'FI','2F7643'),
('2005-10-15',456,53,'MI','2F7643'),
('2005-10-12',567,44,'MI','2F7643');