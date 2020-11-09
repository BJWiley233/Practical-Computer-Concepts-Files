#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Nov  4 20:56:38 2020

@author: coyote
"""

import create_mysql_db
from create_mysql_db import *
import pandas as pd
from io import StringIO
#import requests
import numpy as np
import json
#import xml.etree.ElementTree as ET
import re



user='root'
password='Swimgolf1212**'
host='127.0.0.1'
db_name = "protTest"

cnx = connect(user, password, host)
cursor = cnx.cursor()
use_database(cnx, cursor, db_name)
cnx.database


TABLES = {}

TABLES['kinasePhosphoSitePlus'] = (
    "CREATE TABLE kinasePhosphoSitePlus ("
    "    uniProtIDKin CHAR(15) NOT NULL,"
    "    geneNamePreferredKin VARCHAR(45),"
    "    kinTaxid INT,"
    "    kinOrganism VARCHAR(45),"
    "    uniProtIDSub CHAR(15) NOT NULL,"
    "    geneNamePreferredSub VARCHAR(45),"
    "    geneNameAltSub VARCHAR(45),"
    "    subTaxid INT,"
    "    subOrganism VARCHAR(45),"
    "    subModSite CHAR(10),"
    "    sitePlusMinus7AA CHAR(20),"
    "    inVivo BOOLEAN,"
    "    inVitro BOOLEAN,"
    "    UNIQUE(uniProtIDKin, uniProtIDSub, subModSite, inVivo, inVitro)"
    ") ENGINE=InnoDB"
);

TABLES['depodPhosphatase'] = (
    "CREATE TABLE depodPhosphatase ("
    "    uniProtIDPPase CHAR(15) NOT NULL,"
    "    geneNamePreferredPPase VARCHAR(45),"
    "    ppaseTaxid INT,"
    "    ppaseOrganism VARCHAR(45),"
    "    uniProtIDSub CHAR(15) NOT NULL,"
    "    geneNamePreferredSub VARCHAR(45),"
    "    subTaxid INT,"
    "    subOrganism VARCHAR(45),"
    "    subDephospoSites VARCHAR(256),"
    "    sitePlusMinus5AA VARCHAR(256),"
    "    inVivo BOOLEAN,"
    "    inVitro BOOLEAN,"
    "    literature VARCHAR(256),"
    "    reliabilityScore INT,"
    "    UNIQUE(uniProtIDPPase, uniProtIDSub, subDephospoSites, inVivo, inVitro)"
    ") ENGINE=InnoDB"
);
#cursor.execute("DROP TABLE IF EXISTS kinasePhosphoSitePlus")
#cursor.execute("DROP TABLE IF EXISTS depodPhosphatase")

for table_name in TABLES:
    table_description = TABLES[table_name]
    try:
        print("Creating table: {}".format(table_name))
        cursor.execute(table_description)
    except mysql.connector.Error as err:
        if err.errno == errorcode.ER_TABLE_EXISTS_ERROR:
            print("Table already exists")
        else:
            print(err.msg)


psp = pd.read_csv("../PhosphoSitePlus_Substrates_of_Kinases/Kinase_Substrate_Dataset", 
                     sep="\t", skiprows=3)

psp['in_vivo'] = np.where(psp['IN_VIVO_RXN']=='X', True, False)
psp['in_vitro'] = np.where(psp['IN_VITRO_RXN']=='X', True, False)
psp['kin_tax'] = psp['KIN_ORGANISM'].map({'human': 9606,
                                          'rat' : 10116,
                                          'mouse': 10090,
                                          'hamster': 10029})
psp['sub_tax'] = psp['SUB_ORGANISM'].map({'human': 9606,
                                          'rat' : 10116,
                                          'mouse': 10090,
                                          'hamster': 10029})

# only get rows for human, mouse, rat, hamster
psp2 = psp[~psp.filter(like='_tax').isna().any(1)].copy()
psp2['kin_organ'] = psp2['KIN_ORGANISM'].map({'human': 'Homo sapiens',
                                          'rat' : 'Rattus norvegicus',
                                          'mouse': 'Mus musculus',
                                          'hamster': 'Cricetulus griseus'})
psp2['sub_organ'] = psp2['SUB_ORGANISM'].map({'human': 'Homo sapiens',
                                          'rat' : 'Rattus norvegicus',
                                          'mouse': 'Mus musculus',
                                          'hamster': 'Cricetulus griseus'})

psp2['KIN_ACC_ID'] = psp2['KIN_ACC_ID'].str.replace("-.*", "")
psp2['SUB_ACC_ID'] = psp2['SUB_ACC_ID'].str.replace("-.*", "")

kinase_log = "kinase_not_entered.log"
open(kinase_log, 'w').close()

df_final = psp2.replace({np.nan: None})

for idx, row in df_final.iterrows():
    print(idx)
    try:
        cursor.execute(
            "REPLACE INTO kinasePhosphoSitePlus VALUES (%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s)",
            (row['KIN_ACC_ID'], row['GENE'], row['kin_tax'], row['kin_organ'], 
             row['SUB_ACC_ID'], row['SUB_GENE'], row['SUBSTRATE'],
             row['sub_tax'], row['sub_organ'], row['SUB_MOD_RSD'],
             row['SITE_+/-7_AA'], row['in_vivo'], row['in_vitro'])
        )
        cnx.commit()
    except mysql.connector.Error as err:
        print("Something went wrong: {}".format(err))
        with open(kinase_log, 'a') as f:
            f.write(f"{idx+1}:    {row['KIN_ACC_ID']}    {row['SUB_ACC_ID']}\n")




ppase = pd.read_excel("../data/PPase_protSubtrates_201903.xls")
ppase.columns

ppase['in_vivo'] = np.where(ppase['Assay/s to infer dephosphorylation'].str.match(".*vivo"), True, False)
ppase['in_vitro'] = np.where(ppase['Assay/s to infer dephosphorylation'].str.match(".*vitro"), True, False)
ppase[['Assay/s to infer dephosphorylation', 'in_vivo','in_vitro']]
ppase_final = ppase.replace({np.nan: None})


phosphotase_log = "phos_not_entered.log"
open(phosphotase_log, 'w').close()

for idx, row in ppase_final.iterrows():
    print(idx)
    try:
        cursor.execute(
            "REPLACE INTO depodPhosphatase VALUES (%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s)",
            (row['Phosphatase accession numbers'], row['Phosphatase entry names'], 
             9606, 'Homo sapiens', row['Substrate accession numbers'], 
             row['Substrate entry names'], 9606, 'Homo sapiens',
             row['Dephosphosites'], row['5 amino acid window around the dephosphosite (small letters)'],
             row['in_vivo'], row['in_vivo'], row['Literature source/s'], row['Reliability score'])
        )
        cnx.commit()
    except mysql.connector.Error as err:
        print("Something went wrong: {}".format(err))
        with open(phosphotase_log, 'a') as f:
            f.write(f"{idx+1}:    {row['Phosphatase accession numbers']}    {row['Substrate accession numbers']}\n")
    