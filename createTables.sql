/*create new database parrotcites*/
CREATE DATABASE parrotcites;

USE parrotcites;

/* create empty table from  previous database*/
DROP TABLE IF EXISTS parrotcites.tradedata;

CREATE TABLE parrotcites.tradedata 
(tradedataID integer not null auto_increment primary key,
Year INT,
Appendix VARCHAR(3),
Taxon VARCHAR(255),
Class VARCHAR(50),
`Order` VARCHAR(50),
Family VARCHAR(50),
Genus VARCHAR(50),
Importer VARCHAR(2),
Exporter VARCHAR(2),
Origin VARCHAR(2),
Imp_quant INT,
Exp_quant INT,
Term VARCHAR(20),
Unit VARCHAR(20),
Purpose VARCHAR(1),
Source VARCHAR(1));

/*load tradedata from CITES*/
LOAD DATA LOCAL INFILE '/Users/rfigueira/Documents/projectos/aves/parrots/comptab_2018-01-22 22_14_comma_separated.csv' INTO TABLE parrotcites.tradedata FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n' IGNORE 1 LINES (Year, Appendix, Taxon, Class, `Order`, Family, Genus, Importer, Exporter, Origin, Imp_quant, Exp_quant, Term, Unit, Purpose, Source);

/* create empty country table from  previous database*/
DROP TABLE IF EXISTS parrotcites.country;

CREATE TABLE parrotcites.country (countryID varchar(2) not null primary key)
SELECT * FROM birdcites.country;


INSERT INTO country (countryID, country, continent, biogeo1, biogeo2, biogeo_paleo, isEU) 
VALUES ("KV", "KOSOVO", "Europe", "Palearctic", "", "Western-Palearctic", 0, 1);

INSERT INTO country (countryID, country, continent, biogeo1, biogeo2, biogeo_paleo, isEU)
VALUES ("BL", "", "", "","", "", 0, 1);

/* create empty country table from  previous database*/
DROP TABLE IF EXISTS parrotcites.taxon;

CREATE TABLE parrotcites.taxon 
SELECT * FROM birdcites.taxon;

ALTER TABLE parrotcites.taxon ADD PRIMARY KEY (taxonID);
ALTER TABLE parrotcites.taxon MODIFY COLUMN taxonID INT NOT NULL AUTO_INCREMENT;

/* Add species from tradedata that do not occur in taxon*/
INSERT INTO parrotcites.taxon (taxon, ordem, family) SELECT
    td.Taxon, 'Psittaciformes', 'Psittacidae'
FROM
    parrotcites.tradedata td
        LEFT JOIN
    parrotcites.taxon tx ON td.Taxon = tx.taxon
WHERE
    tx.taxon IS NULL
        AND td.Taxon NOT LIKE '%spp.'
GROUP BY td.Taxon;

DELETE FROM taxon
WHERE
    ordem NOT LIKE 'Psittaciformes';
