#!usr/bin/python2.7
# coding: utf-8

# autor: B. Kozak
# data: 26-lipiec-2016

# simple script downloading sequence in fasta format from ncbi database by names from txt file 


from Bio import Entrez
import time
import sys
import os.path

filename = sys.argv[-1]

outname = list(filename)[:-4]
outname1 = '.'.join([''.join(outname), 'fasta'])


Entrez.email = 'bartosz.kozak@up.wroc.pl'

f = open(filename)
fh = open(outname1, 'w')

for line in f:
    handle = Entrez.efetch(db='nucleotide', id=line, retmode='xml')
    records = Entrez.read(handle)
    print ">GI "+line.rstrip()+" "+records[0]["GBSeq_primary-accession"]+" "+records[0]["GBSeq_definition"]+"\n"+records[0]["GBSeq_sequence"]
    fh.write(">GI "+line.rstrip()+" "+records[0]["GBSeq_primary-accession"]+" "+records[0]["GBSeq_definition"]+"\n"+records[0]["GBSeq_sequence"])
    fh.write("\n")
    time.sleep(3) # to make sure not many requests go per second to ncbi
f.close()
fh.close()
