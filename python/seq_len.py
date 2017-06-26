#!usr/bin/python2.7
# coding: utf-8

# date: 16-wrzesień-2016
# autor: B.Kozak

# Simple script giving length of sequences from fasta file

import Bio
from Bio import SeqIO
import sys
import os.path

filename = sys.argv[-1]

outname = filename.split('.')
outname1 = '.'.join([outname[0], 'txt'])

FastaFile = open(filename, 'rU')
f = open(outname1, 'w')

for rec in SeqIO.parse(FastaFile, 'fasta'):
	name = rec.id
	seq = rec.seq
	seqLen = len(rec)
	print name, seqLen
	f.write("%s\t" % name)
	f.write("%s\n" % seqLen)
f.close()
print 'Done'
	
