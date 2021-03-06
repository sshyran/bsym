SPARQL
DEFINE input:inference <http://schema.ga-group.nl/symbology#>
PREFIX gas: <http://schema.ga-group.nl/symbology#>
PREFIX figi: <http://openfigi.com/id/>
PREFIX bps: <http://bsym.bloomberg.com/pricing_source/>
PREFIX figi-gii: <http://www.omg.org/spec/FIGI/GlobalInstrumentIdentifiers/>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX skos: <http://www.w3.org/2004/02/skos/core#>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX prov: <http://www.w3.org/ns/prov#>

-- Issuers, strictly speaking, only issue securities at the share class level
-- however common data sources, more often than not, present issuer data
-- alongside particular listings (shares at an exchange, bonds at an exch)
-- This snippet detects different issuer assignments amongst siblings
-- of a composite

SELECT ?figi1 ?issr1 ?figi2 ?issr2 WHERE {
	?figi1 gas:componentOf+ ?cfigi .
	?figi2 gas:componentOf+ ?cfigi .
	?figi1 gas:issuedBy ?issr1 .
	?figi2 gas:issuedBy ?issr2 .
	## only inconsistent ones
	FILTER (?issr1 != ?issr2)
	## stick with the symbology
	?issr1 gas:symbolOf ?symb .
	?issr2 gas:symbolOf ?symb .
	## make sure they are not just reclassifications
	FILTER NOT EXISTS { ?figi2 gas:issuedBy ?issr1 }
	FILTER NOT EXISTS { ?figi1 gas:issuedBy ?issr2 }
};
