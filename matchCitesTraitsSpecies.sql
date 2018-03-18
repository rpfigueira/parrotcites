/* This scripts aims at matching the two sources of species names: cites tarde data and trait data */

/* Export taxon list from the database */
SELECT
    taxon AS scientificName,
    'Animalia' AS kingdom,
    taxonID AS ID
FROM
    parrotcites.taxon t
WHERE
    (t.taxon NOT LIKE '%spp.'
        AND t.taxon NOT LIKE '%hybrid%');
