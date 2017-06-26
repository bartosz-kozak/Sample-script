#!/bin/python2.7
# coding: utf-8

# autor: B. Kozak
# data: 22-czerwca-2016
# script converting GenBank format to fasta (fan)

# loading libraries
import sys
import Bio
from Bio import SeqIO
from Bio.SeqRecord import SeqRecord

# take file name
filename = sys.argv[-1]

handle = filename
output = 'out.fasta'
data = Bio.SeqIO.parse(handle, 'gb')
fh = open(output, 'w')

# main program function
def dna_seq(record):
    return SeqRecord(seq = record.seq, \
                    id = record.id, \
                    description = record.description)

# create empty list (for DNA sequence)

dna = []

# loop add sequence to list

for rec in data:
    print 'Dealing with %s' % rec.description
    dna.append(dna_seq(rec))

# save sequence to fasta file  
SeqIO.write(dna, output, 'fasta')
