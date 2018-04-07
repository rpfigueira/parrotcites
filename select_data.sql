/*
Select all data, merging trade and trait variables
- Each row containts the total of traded live animals per species per year
- live eggs are included
*/

SELECT
    ty.tradeYearID,
    ty.year,
    ty.Appendix,
    ty.taxonID,
    ty.taxon,
    ty.Class,
    ty.Order,
    ty.Family,
    ty.Genus,
    c.country AS importer,
    c1.country AS exporter_origin,
    ty.h_quant AS quantity,
    ty.Term,
    ty.Purpose,
    ty.Source,
    trs.SpecID,
    trs.tipLabel,
    trs.speciesEnglish,
    trs.IUCN2012,
    trs.BreedingRangeCellCount,
    trs.EvolDistictMedian,
    trs.EDGE,
    trs.Broods,
    trs.LogClutchSize,
    trs.LogBodySize,
    trs.broodValue,
    trs.LogLifespanMax,
    trs.LogLifespanWild,
    trs.bodyMassBrain,
    trs.brainMass,
    trs.nbSubspecies,
    trs.beautyScore,
    trs.intraspColorVariation,
    trs.sexualDichromatism,
    trs.HBW_nomenclature_if_different
FROM
    tradeYear ty
        INNER JOIN
    traits trs ON ty.taxonID = trs.taxonID
        INNER JOIN
    country c ON ty.importer = c.countryID
        INNER JOIN
    country c1 ON ty.Importer = c1.countryID
WHERE
    term IN ('eggs (live)' , 'live')
        AND purpose IN ('T' , 'P'); /Q2*/
