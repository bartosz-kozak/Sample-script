#!/bin/python2.7
# coding: utf-8

# Simple script to convert csv file to fasta fromat

# import librarys
import pandas as pd
import sys
import os.path

# create file name for fasta file
filename = sys.argv[-1]
outname = filename.split('.')
outname1 = '.'.join([outname[0], 'fasta'])

# read data (csv file)
df = pd.read_csv(filename, header=None)
df.columns = ['id', 'seq']

# create fasta file
fh = open(outname1, 'w')

# function for conversion to fasta format
for i in range(0,len(df)):
	n = df.at[i,'id']
	seq = df.at[i, 'seq']
	fh.write(">%s\n" % n)
	fh.write("%s\n" % seq)
fh.close() 
