#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Nov  9 02:11:04 2020

@author: coyote
"""

query_merops = """
(SELECT  DISTINCT u.geneNamePreferred, u.uniProtID, u.headProteinFamily, i.interactorA,
	i.geneNamePreferredA, i.interactorB, i.geneNamePreferredB, i.interactionType, 
    i.direction, i.interactionID, m.proteaseUniprot
FROM proteinsUniprot u
INNER JOIN intact i 
	ON u.uniProtID = i.interactorA AND i.interactorB IN (SELECT u.uniProtID FROM proteinsUniprot u)
JOIN 
	( SELECT sel.Substrate_name as substrateName, prot.geneNamePreferred as substrateGenePreferred,
			sel.substrateUniprot, sel.substrateOrganism, 
			sel.protease, sel.`code`, sel.proteaseUniprot, sel.geneNamePreferred as proteaseGenePreferred,
			sel.proteinName as proteaseName, sel.alternateNames as proteaseAltNames, 
			sel.taxid as proteaseTaxId, sel.organism as proteaseOrganism
		FROM
		(SELECT s.Substrate_name, s.Uniprot AS substrateUniprot, s.organism as substrateOrganism, 
			s.protease, s.`code`, p.uniProtID as proteaseUniprot, p.geneNamePreferred, p.proteinName, 
			p.alternateNames, p.taxid, p.organism
		FROM protTest.Substrate_search s
		INNER JOIN 
			proteinsUniprot p
			ON p.meropsID = s.`code` AND s.organism LIKE CONCAT('%', p.organism, '%')
		WHERE p.uniProtID IN
			( SELECT i.interactorA
			  FROM intact i 
			  GROUP BY i.interactorA)
		) as sel
		LEFT JOIN
			proteinsUniprot prot
			ON sel.substrateUniprot = prot.uniProtID 
	) as m
    ON u.uniProtID = m.proteaseUniprot
ORDER BY RAND()
LIMIT 10)

UNION ALL

(SELECT DISTINCT u.geneNamePreferred, u.uniProtID, u.headProteinFamily, i.interactorA,
	i.geneNamePreferredA, i.interactorB, i.geneNamePreferredB, i.interactionType, 
    i.direction, i.interactionID, m.proteaseUniprot
FROM proteinsUniprot u
INNER JOIN intact i 
	ON u.uniProtID = i.interactorB AND i.interactorA IN (SELECT u.uniProtID FROM proteinsUniprot u)
JOIN 
	( SELECT sel.Substrate_name as substrateName, prot.geneNamePreferred as substrateGenePreferred,
			sel.substrateUniprot, sel.substrateOrganism, 
			sel.protease, sel.`code`, sel.proteaseUniprot, sel.geneNamePreferred as proteaseGenePreferred,
			sel.proteinName as proteaseName, sel.alternateNames as proteaseAltNames, 
			sel.taxid as proteaseTaxId, sel.organism as proteaseOrganism
		FROM
		(SELECT s.Substrate_name, s.Uniprot AS substrateUniprot, s.organism as substrateOrganism, 
			s.protease, s.`code`, p.uniProtID as proteaseUniprot, p.geneNamePreferred, p.proteinName, 
			p.alternateNames, p.taxid, p.organism
		FROM protTest.Substrate_search s
		INNER JOIN 
			proteinsUniprot p
			ON p.meropsID = s.`code` AND s.organism LIKE CONCAT('%', p.organism, '%')
		WHERE p.uniProtID IN
			( SELECT i.interactorB
			  FROM intact i 
			  GROUP BY i.interactorB)
		) as sel
		LEFT JOIN
			proteinsUniprot prot
			ON sel.substrateUniprot = prot.uniProtID 
	) as m
   ON u.uniProtID = m.proteaseUniprot
ORDER BY RAND()
LIMIT 10);
"""

query_psp = """
(SELECT DISTINCT u.geneNamePreferred, u.uniProtID, u.headProteinFamily, i.interactorA,
	i.geneNamePreferredA, i.interactorB, i.geneNamePreferredB, i.interactionType, 
    i.direction, i.interactionID, k.uniProtIDKin
FROM proteinsUniprot u
INNER JOIN intact i 
	ON u.uniProtID = i.interactorA AND i.interactorB IN (SELECT u.uniProtID FROM proteinsUniprot u)
JOIN 
	( SELECT DISTINCT uniProtIDKin
      FROM kinasePhosphoSitePlus 
	) as k
    ON u.uniProtID = k.uniProtIDKin
LIMIT 10)

UNION ALL

(SELECT DISTINCT u.geneNamePreferred, u.uniProtID, u.headProteinFamily, i.interactorA,
	i.geneNamePreferredA, i.interactorB, i.geneNamePreferredB, i.interactionType, 
    i.direction, i.interactionID, k.uniProtIDKin
FROM proteinsUniprot u
INNER JOIN intact i 
	ON u.uniProtID = i.interactorB AND i.interactorA IN (SELECT u.uniProtID FROM proteinsUniprot u)
JOIN 
	( SELECT DISTINCT uniProtIDKin
      FROM kinasePhosphoSitePlus 
	) as k
    ON u.uniProtID = k.uniProtIDKin
LIMIT 10);
"""

query_ppase = """
(SELECT DISTINCT u.geneNamePreferred, u.uniProtID, u.headProteinFamily, i.interactorA,
	i.geneNamePreferredA, i.interactorB, i.geneNamePreferredB, i.interactionType, 
    i.direction, i.interactionID, d.uniProtIDPPase
FROM proteinsUniprot u
INNER JOIN intact i 
	ON u.uniProtID = i.interactorA AND i.interactorB IN (SELECT u.uniProtID FROM proteinsUniprot u)
JOIN 
	( SELECT DISTINCT d.uniProtIDPPase
      FROM depodPhosphatase d 
	) as d
    ON u.uniProtID = d.uniProtIDPPase
ORDER BY RAND()
LIMIT 10) 

UNION ALL

(SELECT DISTINCT u.geneNamePreferred, u.uniProtID, u.headProteinFamily, i.interactorA,
	i.geneNamePreferredA, i.interactorB, i.geneNamePreferredB, i.interactionType, 
    i.direction, i.interactionID, d.uniProtIDPPase
FROM proteinsUniprot u
INNER JOIN intact i 
	ON u.uniProtID = i.interactorB AND i.interactorA IN (SELECT u.uniProtID FROM proteinsUniprot u)
JOIN 
	( SELECT DISTINCT d.uniProtIDPPase
      FROM depodPhosphatase d 
	) as d
    ON u.uniProtID = d.uniProtIDPPase
ORDER BY RAND()
LIMIT 10);
"""