#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Oct 21 21:05:11 2020

@author: coyote
"""


import pandas as pd

galaxy_downloads = ["/home/coyote/Downloads/Galaxy1-[UCSC_Main_on_Human__wgEncodeUwTfbsHct116CtcfStdHotspotsRep1_(chr6_88,000,001-93,100,000)].bed",
                    "/home/coyote/Downloads/Galaxy2-[UCSC_Main_on_Human__wgEncodeUwTfbsHelas3CtcfStdHotspotsRep1_(chr6_88,000,001-93,100,000)].bed"]

colors = ["color=%s" % "50,48,206",  # blue
          "color=%s" % "227,32,20"   # red
          ]

out_names = ["Hct116Ctcf", "Helas3Ctcf"]
          
out_files = ["/home/coyote/Downloads/%s.bedGraph" % i for i in out_names]


for d in range(0, len(galaxy_downloads)):
    input_ = pd.read_csv(galaxy_downloads[d], sep="\t", header=None)
    
    chrom=0
    start=1
    end=2
    score=4
    
    continuous = []
    for i in range(0, len(input_)-1):
        continuous.append([input_.iloc[i,chrom], 
                       input_.iloc[i,start], 
                       input_.iloc[i,end],
                       input_.iloc[i,score]])
        continuous.append([input_.iloc[i,chrom], 
                       input_.iloc[i,end], 
                       input_.iloc[i+1,start],
                       0])
    
    continuous.append(list(input_.iloc[len(input_)-1,[chrom, start, end, score]]))
    
    with open(out_files[d], 'w') as f:
        f.write("track type=bedGraph name=%s description=%s_bedGraph %s\n" % 
                (out_names[d], out_names[d], colors[d]))
        for line in continuous:
            f.write("\t".join([str(i) for i in line]))
            f.write("\n")

