SELECT u.UniProtID, u.name, u.organism, s.PDBID, s.method
FROM UniProt u INNER JOIN Structures s
    USING(UniProtID);
    
SELECT COUNT(DISTINCT(UniProtID)) 
FROM Structures;

SELECT u.recommendedName, COUNT(PDBID)
FROM Structures s INNER JOIN UniProt u
    ON s.UniProtID = u.UniProtID
GROUP BY (s.UniProtID);

SELECT u.recommendedName, COUNT(GOID)
FROM GO g INNER JOIN UniProt u
    ON g.UniProtID = u.UniProtID
GROUP BY (g.UniProtID);


SELECT u.UniProtID, u.name, s.PDBID, g.GOID, g.term
FROM Structures s
     INNER JOIN UniProt u ON s.UniProtID = u.UniProtID
     INNER JOIN GO g ON u.UniProtID = g.UniProtID
WHERE s.PDBID = '5TVN'

SELECT u.UniProtID, u.name, s.PDBID
FROM Structures s
     INNER JOIN UniProt u ON s.UniProtID = u.UniProtID
WHERE s.PDBID = '5TVN'