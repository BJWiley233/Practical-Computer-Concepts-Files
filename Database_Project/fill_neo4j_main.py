#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Nov  9 01:43:17 2020

@author: coyote
"""

import logging
from neo4j import GraphDatabase
from neo4j.exceptions import ServiceUnavailable

import create_mysql_db
from create_mysql_db import *
import pandas as pd
import numpy as np

"""
merops & intact
"""


userMySQL='root'
passwordMySQL='**'
hostMySQL='127.0.0.1'
dbMySQL = 'protTest'

cnx = connect(userMySQL, passwordMySQL, hostMySQL)
cursor = cnx.cursor(dictionary=True)
use_database(cnx, cursor, dbMySQL)

from queries import query_merops
cursor.execute(query_merops)
merops_sel = cursor.fetchall()
merops = pd.DataFrame([[i['interactorA'], i['interactorB'], 
                        i["interactionID"], i['uniProtID']] for i in merops_sel])
merops
merops.columns = ['interactorA','interactorB',"interactionID", 'uniProtID']


from queries import query_psp
cursor.execute(query_psp)
psp_sel = cursor.fetchall()
psp = pd.DataFrame([[i['interactorA'], i['interactorB'], 
                     i["interactionID"], i['uniProtID']] for i in psp_sel])
psp
psp.columns = ['interactorA','interactorB',"interactionID", 'uniProtID']


from queries import query_ppase
cursor.execute(query_ppase)
ppase_sel = cursor.fetchall()
ppase = pd.DataFrame([[i['interactorA'], i['interactorB'], 
                       i["interactionID"], i['uniProtID']] for i in ppase_sel])
ppase
ppase.columns = ['interactorA','interactorB',"interactionID", 'uniProtID']

np.unique([merops['interactorA'], merops['interactorB']])
np.unique([psp['interactorA'], psp['interactorB']])
np.unique([ppase['interactorA'], ppase['interactorB']])

get_uniprot = np.unique((merops['interactorA'].tolist() + 
                         merops['interactorB'].tolist() +
                         psp['interactorA'].tolist() +
                         psp['interactorB'].tolist() +
                         ppase['interactorA'].tolist() + 
                         ppase['interactorB'].tolist() +
                         merops['uniProtID'].tolist() +
                         psp['uniProtID'].tolist() +
                         ppase['uniProtID'].tolist()))

get_intact = np.unique((merops['interactionID'].tolist() + 
                         psp['interactionID'].tolist() +
                         ppase['interactionID'].tolist()))

len(get_uniprot)
len(get_intact)

query_up = """
    SELECT u.geneNamePreferred, u.uniProtID, u.proteinName, u.organism,
    	u.taxid, u.geneNamesAlternative, u.alternateNames, u.headProteinFamily
    FROM proteinsUniprot u
    WHERE u.uniProtID IN (%s);
"""


query_intact = """
SELECT i.interactionID, i.interactorA, i.interactorB, i.taxidA, i.taxidB,
	i.geneNamePreferredA as nameA, i.geneNamePreferredB as nameB, i.organismA, i.organismB,
    i.alternateNamesA as altProtNamesA, i.alternateNamesB as altProtNamesB, 
    i.geneNamesAlternativeA as altGeneNamesA, i.geneNamesAlternativeB as altGeneNamesB,
    i.pubmedID, i.detectionMethod, i.interactionType, sourceDB,
    CASE
		WHEN i.interactorA REGEXP "^EBI-" THEN "Molecule"
        WHEN i.interactorA REGEXP "^[0-9]" THEN "Molecule"
        ELSE "Protein"
	END as nodeTypeA,
    CASE
		WHEN i.interactorB REGEXP "^EBI-" THEN "Molecule"
        WHEN i.interactorB REGEXP "^[0-9]" THEN "Molecule"
        ELSE "Protein"
	END as nodeTypeB, lower(i.direction) as direction
FROM protTest.intact i
WHERE interactionID IN (%s)
"""

# desktop version
#uri = "neo4j://localhost:11003"
# some times needs this
uri = 'neo4j://localhost:7687'
user = 'neo4j'
# you'll need a password after you start 
password = '**'
db = 'protTest'



#https://stackoverflow.com/questions/589284/imploding-a-list-for-use-in-a-python-mysqldb-in-clause
format_strings = ','.join(['%s'] * len(get_uniprot))
cursor.execute(query_up % format_strings, tuple(get_uniprot))
uniprot_data = cursor.fetchall()

format_strings_intact = ','.join(['%s'] * len(get_intact))
cursor.execute(query_intact % format_strings_intact, tuple(get_intact))
intact_data = cursor.fetchall()




from fill_neo4j import ProteinExample
prot_db = ProteinExample(uri, user, password)
#prot_db.create_db(db)
#prot_db._drop(db)
prot_db.use_database(db)
prot_db.database

prot_db.create_proteins(uniprot_data)


#uniprot_data[0]['geneNamesAlternative']
prot_db.create_intact_interactions(intact_data)
@TODO
"""
prot_db.create_merops_interactions(merops_data)
prot_db.create_psp_interactions(psp_data)
prot_db.create_ppase_interactions(ppase_data)
"""
