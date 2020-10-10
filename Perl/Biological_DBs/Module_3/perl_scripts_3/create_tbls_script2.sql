DROP TABLE IF EXISTS UniProt;

CREATE TABLE IF NOT EXISTS UniProt (
    UniProtID CHAR(15) PRIMARY KEY UNIQUE, 
    name TEXT NOT NULL,
    recommendedName TEXT,
    organism TEXT NOT NULL,
    taxid INT NOT NULL
);


DROP TABLE IF EXISTS Structures;

CREATE TABLE IF NOT EXISTS Structures (
    PDBID CHAR (5) PRIMARY KEY UNIQUE,
    UniProtID CHAR(15) NOT NULL, 
    method TEXT NOT NULL,
    CONSTRAINT fk_UniProt
        FOREIGN KEY(UniProtID) REFERENCES UniProt(UniProtID)
);


DROP TABLE IF EXISTS Go;

CREATE TABLE IF NOT EXISTS Go (
    GOID CHAR (15) PRIMARY KEY UNIQUE,
    UniProtID CHAR(15) NOT NULL,
    term TEXT,
     CONSTRAINT fk_UniProt
        FOREIGN KEY(UniProtID) REFERENCES UniProt(UniProtID)
);

SELECT u.UniProtID, u.name, u.organism, s.PDBID, s.method
FROM UniProt u INNER JOIN Structures s
    USING(UniProtID);
    
SELECT COUNT(DISTINCT(UniProtID)) 
FROM Structures;

SELECT u.recommendedName, COUNT(PDBID)
FROM Structures s INNER JOIN UniProt u
    ON s.UniProtID = u.UniProtID
GROUP BY (s.UniProtID);