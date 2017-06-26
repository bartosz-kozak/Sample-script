#!usr/bin/python2.7
# coding: utf-8

# simple script to convert fasta file to csv file

# imports libraries
import sys
import os.path

# create file names
filename = sys.argv[-1]
outname = filename.split('.')
outname1 = '.'.join([outname[0], 'csv'])

# open fasta file
f=open(filename, "r")

# list fasta file
l=list(f) 
# create csv file
fh=open(outname1, "w")

# function converting fasta to csv
for i in range(0, len(l)):
	p_zn = list(l[i])[0]
	if p_zn == ">":
		k = ''.join(list(l[i]))[1:-1]
		print k
		fh.write("%s," % k)
	else:
		k = ''.join(list(l[i]))
		#print k
		fh.write("%s" % k)
fh.close()
print 'done'
