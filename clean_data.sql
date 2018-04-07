/* create tradedata1 excluding
- records where taxon is at genus level
- duplicated lines
- records where importer and exporter are the same
*/


DROP TABLE IF EXISTS parrotcites.tradedata1;
CREATE TABLE parrotcites.tradedata1
(tradedata1ID integer not null auto_increment primary key)
SELECT distinct
    Year,
    Appendix,
    taxonID,
    taxon,
    Class,
	  'Order',
    Family,
    Genus,
    Importer,
    Exporter,
    Origin,
    Imp_quant,
    Exp_quant,
    Term,
    Unit,
    Purpose,
    Source
FROM
    parrotcites.tradedata
WHERE
    importer <> exporter and taxon  not like '%spp.';

ALTER TABLE parrotcites.tradedata1 ADD COLUMN h_quant int AFTER Exp_quant;

UPDATE parrotcites.tradedata1 SET h_quant = GREATEST(Imp_quant, Exp_quant);


/* create table with only one origin */
DROP TABLE IF EXISTS tradedata1_origin;

CREATE TABLE tradedata1_origin  ENGINE=INNODB
SELECT * FROM tradedata1;

ALTER TABLE tradedata1_origin
        ADD COLUMN exporter_origin VARCHAR(2) AFTER exporter;

UPDATE tradedata1_origin
    SET
        exporter_origin = exporter;

UPDATE tradedata1_origin
    SET
        exporter_origin = origin
    WHERE
        origin REGEXP '^[A-Z]';

/* SUm records by year */
DROP TABLE IF EXISTS parrotcites.tradeYear;
CREATE TABLE parrotcites.tradeYear
(tradeYearID integer not null auto_increment primary key)
SELECT
    year,
    Appendix,
    taxonID,
    taxon,
    Class,
    'Order',
    Family,
    Genus,
    Importer,
    exporter_origin,
    SUM(Imp_quant) AS Imp_quant,
    SUM(Exp_quant) AS Exp_quant,
    SUM(h_quant) AS h_quant,
    Term,
    Unit,
    Purpose,
    Source
FROM
    tradedata1_origin
GROUP BY year , Appendix , taxonID , taxon , Class , 'Order' , Family , Genus , Importer , exporter_origin , Term , Unit , Purpose , Source;
