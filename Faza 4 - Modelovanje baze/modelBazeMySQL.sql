
CREATE TABLE Autor
(
	KorIme VARCHAR(20) NOT NULL ,
	ImePrezime VARCHAR(40) NOT NULL ,
	DatumRodjenja DATE NOT NULL ,
	Biografija VARCHAR(1000) NOT NULL 
);

ALTER TABLE Autor
	ADD  CONSTRAINT XPKAutor PRIMARY KEY  ( KorIme ASC );

CREATE TABLE IzdavackaKuca
(
	KorIme VARCHAR(20) NOT NULL ,
	Naziv VARCHAR(40) NOT NULL ,
	Istorija VARCHAR(1000) NULL ,
	Adresa VARCHAR(60) NOT NULL 
);

ALTER TABLE IzdavackaKuca
	ADD  CONSTRAINT XPKIzdavackaKuca PRIMARY KEY  ( KorIme ASC );

CREATE TABLE Knjiga
(
	ISBN VARCHAR(20) NOT NULL ,
	Naziv VARCHAR(40) NOT NULL ,
	Slika BLOB NULL ,
	Opis VARCHAR(100) NULL ,
	ProsecnaOcena DECIMAL(5,2)  DEFAULT 0 CONSTRAINT IzmedjuNulaPet_1456810939 CHECK (ProsecnaOcena BETWEEN 0 AND 5) NOT NULL ,
	IDIzdKuca VARCHAR(20) NOT NULL 
);

ALTER TABLE Knjiga
	ADD  CONSTRAINT XPKKnjiga PRIMARY KEY  ( ISBN ASC );

CREATE TABLE Kolekcija
(
	KorIme VARCHAR(20) NOT NULL ,
	ISBN VARCHAR(20) NOT NULL 
);

ALTER TABLE Kolekcija
	ADD  CONSTRAINT XPKKolekcija PRIMARY KEY  ( KorIme ASC, ISBN ASC );

CREATE TABLE Korisnik
(
	KorIme VARCHAR(20) NOT NULL ,
	ImePrezime VARCHAR(40) NOT NULL ,
	DatumRodjenja DATE NOT NULL ,
	Admin boolean NOT NULL 
);

ALTER TABLE Korisnik
	ADD  CONSTRAINT XPKKorisnik PRIMARY KEY  ( KorIme ASC );

CREATE TABLE Licitacija
(
	IDLicitacija INTEGER NOT NULL ,
	NazivDela VARCHAR(40) NOT NULL ,
	PDF BLOB NOT NULL ,
	DatumPocetka DATETIME NOT NULL ,
	DatumKraja DATETIME NOT NULL ,
	PocetnaCena INTEGER CONSTRAINT VeceJednakoOdNula_1976295580 CHECK (PocetnaCena >= 0) NOT NULL ,
	TrenutniIznos INTEGER  DEFAULT 0 CONSTRAINT VeceJednakoOdNula_232792837 CHECK (TrenutniIznos >= 0) NOT NULL ,
	IDAutor VARCHAR(20) NOT NULL ,
	IDPobednik VARCHAR(20) NULL 
);

ALTER TABLE Licitacija
	ADD  CONSTRAINT XPKLicitacija PRIMARY KEY  ( IDLicitacija ASC );

CREATE TABLE NajpopularnijiMesec
(
	IDOcenjenog VARCHAR(20) NOT NULL ,
	ProsecnaOcena DECIMAL(5,2) CONSTRAINT IzmedjuNulaPet_2045329637 CHECK (ProsecnaOcena BETWEEN 0 AND 5) NOT NULL ,
	Tip CHAR CONSTRAINT TipPopularan_609004974 CHECK (Tip IN ('K', 'I', 'A')) NOT NULL 
);

ALTER TABLE NajpopularnijiMesec
	ADD  CONSTRAINT XPKNajpopularnijiMesec PRIMARY KEY  ( IDOcenjenog ASC );

CREATE TABLE Napisao
(
	IDAutor VARCHAR(20) NOT NULL ,
	ISBN VARCHAR(20) NOT NULL 
);

ALTER TABLE Napisao
	ADD  CONSTRAINT XPKNapisao PRIMARY KEY  ( IDAutor ASC, ISBN ASC );

CREATE TABLE Objava
(
	IDObjava INTEGER NOT NULL ,
	Sadrzaj VARCHAR(1000) NOT NULL ,
	DatumObjave DATETIME NOT NULL ,
	Slika BLOB NULL ,
	KorIme VARCHAR(20) NOT NULL 
);

ALTER TABLE Objava
	ADD  CONSTRAINT XPKObjava PRIMARY KEY  ( IDObjava ASC );

CREATE TABLE Ponuda
(
	IDPonuda INTEGER NOT NULL ,
	Iznos INTEGER CONSTRAINT VeceJednakoOdNula_1477657929 CHECK (Iznos >= 0) NOT NULL ,
	IDLicitacija INTEGER NOT NULL ,
	IDIzdKuca VARCHAR(20) NOT NULL 
);

ALTER TABLE Ponuda
	ADD  CONSTRAINT XPKPonuda PRIMARY KEY  ( IDPonuda ASC );

CREATE TABLE Povezani
(
	IDAutor VARCHAR(20) NOT NULL ,
	IDIzdKuca VARCHAR(20) NOT NULL 
);

ALTER TABLE Povezani
	ADD  CONSTRAINT XPKPovezani PRIMARY KEY  ( IDAutor ASC, IDIzdKuca ASC );

CREATE TABLE Prati
(
	IDPratilac VARCHAR(20) NOT NULL ,
	IDPracen VARCHAR(20) NOT NULL 
);

ALTER TABLE Prati
	ADD  CONSTRAINT XPKPrati PRIMARY KEY  ( IDPratilac ASC, IDPracen ASC );

CREATE TABLE ProdajnaMesta
(
	IDIzdKuca VARCHAR(20) NOT NULL ,
	Adresa VARCHAR(60) NOT NULL 
);

ALTER TABLE ProdajnaMesta
	ADD  CONSTRAINT XPKProdajnaMesta PRIMARY KEY  ( IDIzdKuca ASC, Adresa ASC );

CREATE TABLE Recenzija
(
	IDRec INTEGER NOT NULL ,
	Ocena INTEGER CONSTRAINT IzmedjuNulaPet_728450822 CHECK (Ocena BETWEEN 0 AND 5) NOT NULL ,
	DatumObjave DATETIME NOT NULL ,
	Tekst VARCHAR(1000) NOT NULL ,
	IDDavalac VARCHAR(20) NOT NULL ,
	IDPrimalacUloga VARCHAR(20) NULL ,
	IDPrimalacKnjiga VARCHAR(20) NULL 
);

ALTER TABLE Recenzija
	ADD  CONSTRAINT XPKRecenzija PRIMARY KEY  ( IDRec ASC );

CREATE TABLE Uloga
(
	KorIme VARCHAR(20) NOT NULL ,
	Sifra VARCHAR(40) NOT NULL ,
	Email VARCHAR(40) NOT NULL ,
	Slika BLOB NULL ,
	BrPratilaca INTEGER  DEFAULT 0 CONSTRAINT VeceJednakoOdNula_161082788 CHECK (BrPratilaca >= 0) NOT NULL ,
	ProsecnaOcena DECIMAL(5,2)  DEFAULT 0 CONSTRAINT IzmedjuNulaPet_1037513072 CHECK (ProsecnaOcena BETWEEN 0 AND 5) NOT NULL ,
	Tip CHAR CONSTRAINT TipUloga_2006560910 CHECK (Tip IN ('A', 'K', 'I')) NOT NULL ,
	Banovan boolean  DEFAULT False NOT NULL 
);

ALTER TABLE Uloga
	ADD  CONSTRAINT XPKUloga PRIMARY KEY  ( KorIme ASC );

ALTER TABLE Autor
	ADD  CONSTRAINT R_1 FOREIGN KEY (KorIme) REFERENCES Uloga (KorIme)
		ON DELETE CASCADE 
		ON UPDATE CASCADE ;

ALTER TABLE IzdavackaKuca
	ADD  CONSTRAINT R_5 FOREIGN KEY (KorIme) REFERENCES Uloga (KorIme)
		ON DELETE CASCADE 
		ON UPDATE CASCADE ;

ALTER TABLE Knjiga
	ADD  CONSTRAINT R_11 FOREIGN KEY (IDIzdKuca) REFERENCES IzdavackaKuca (KorIme)
		ON DELETE NO ACTION 
		ON UPDATE NO ACTION ;

ALTER TABLE Kolekcija
	ADD  CONSTRAINT R_14 FOREIGN KEY (KorIme) REFERENCES Uloga (KorIme)
		ON DELETE NO ACTION 
		ON UPDATE NO ACTION ;

ALTER TABLE Kolekcija
	ADD  CONSTRAINT R_15 FOREIGN KEY (ISBN) REFERENCES Knjiga (ISBN)
		ON DELETE NO ACTION 
		ON UPDATE NO ACTION ;

ALTER TABLE Korisnik
	ADD  CONSTRAINT R_2 FOREIGN KEY (KorIme) REFERENCES Uloga (KorIme)
		ON DELETE CASCADE 
		ON UPDATE CASCADE ;

ALTER TABLE Licitacija
	ADD  CONSTRAINT R_20 FOREIGN KEY (IDAutor) REFERENCES Autor (KorIme)
		ON DELETE NO ACTION 
		ON UPDATE NO ACTION ;

ALTER TABLE Licitacija
	ADD  CONSTRAINT R_21 FOREIGN KEY (IDPobednik) REFERENCES IzdavackaKuca (KorIme)
		ON DELETE NO ACTION 
		ON UPDATE NO ACTION ;

ALTER TABLE Napisao
	ADD  CONSTRAINT R_12 FOREIGN KEY (IDAutor) REFERENCES Autor (KorIme)
		ON DELETE NO ACTION 
		ON UPDATE NO ACTION ;

ALTER TABLE Napisao
	ADD  CONSTRAINT R_13 FOREIGN KEY (ISBN) REFERENCES Knjiga (ISBN)
		ON DELETE NO ACTION 
		ON UPDATE NO ACTION ;

ALTER TABLE Objava
	ADD  CONSTRAINT R_19 FOREIGN KEY (KorIme) REFERENCES Uloga (KorIme)
		ON DELETE NO ACTION 
		ON UPDATE NO ACTION ;

ALTER TABLE Ponuda
	ADD  CONSTRAINT R_22 FOREIGN KEY (IDLicitacija) REFERENCES Licitacija (IDLicitacija)
		ON DELETE NO ACTION 
		ON UPDATE NO ACTION ;

ALTER TABLE Ponuda
	ADD  CONSTRAINT R_23 FOREIGN KEY (IDIzdKuca) REFERENCES IzdavackaKuca (KorIme)
		ON DELETE NO ACTION 
		ON UPDATE NO ACTION ;

ALTER TABLE Povezani
	ADD  CONSTRAINT R_8 FOREIGN KEY (IDAutor) REFERENCES Autor (KorIme)
		ON DELETE NO ACTION 
		ON UPDATE NO ACTION ;

ALTER TABLE Povezani
	ADD  CONSTRAINT R_9 FOREIGN KEY (IDIzdKuca) REFERENCES IzdavackaKuca (KorIme)
		ON DELETE NO ACTION 
		ON UPDATE NO ACTION ;

ALTER TABLE Prati
	ADD  CONSTRAINT R_6 FOREIGN KEY (IDPratilac) REFERENCES Uloga (KorIme)
		ON DELETE NO ACTION 
		ON UPDATE NO ACTION ;

ALTER TABLE Prati
	ADD  CONSTRAINT R_7 FOREIGN KEY (IDPracen) REFERENCES Uloga (KorIme)
		ON DELETE NO ACTION 
		ON UPDATE NO ACTION ;

ALTER TABLE ProdajnaMesta
	ADD  CONSTRAINT R_10 FOREIGN KEY (IDIzdKuca) REFERENCES IzdavackaKuca (KorIme)
		ON DELETE NO ACTION 
		ON UPDATE NO ACTION ;

ALTER TABLE Recenzija
	ADD  CONSTRAINT R_16 FOREIGN KEY (IDDavalac) REFERENCES Uloga (KorIme)
		ON DELETE NO ACTION 
		ON UPDATE NO ACTION ;

ALTER TABLE Recenzija
	ADD  CONSTRAINT R_17 FOREIGN KEY (IDPrimalacUloga) REFERENCES Uloga (KorIme)
		ON DELETE NO ACTION 
		ON UPDATE NO ACTION ;

ALTER TABLE Recenzija
	ADD  CONSTRAINT R_18 FOREIGN KEY (IDPrimalacKnjiga) REFERENCES Knjiga (ISBN)
		ON DELETE NO ACTION 
		ON UPDATE NO ACTION ;