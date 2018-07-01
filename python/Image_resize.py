#!/bin/python2.7
# coding: utf-8

# autor: B. Kozak
# data: 30-marca-2016

# simple script resize image for internet website

# import libraries
import PIL
from PIL import Image
import os.path
import sys


# take image name 
filename = sys.argv[-1]
# width set on 250px
szer_baz = 250
# change image size
img = Image.open(filename)
wpercent = (szer_baz/float(img.size[0]))
hsiz = int((float(img.size[1])*float(wpercent)))
img = img.resize((szer_baz, hsiz), PIL.Image.ANTIALIAS)

# create name for resize file
filename1 = ''.join(list(filename)[:-4])
filename1 = '.'.join([filename1,'png'])
filename1 = '/'.join(['thumbs', filename1])
if os.path.isdir('./thumbs')==True:
	if os.path.isfile(filename1)==False:
		img.save(filename1)
			
	else:
		print 'miniatura juz istnieje'
else:
# create folter for miniature image
	os.makedirs('./thumbs')
	if os.path.isfile(filename1)==False:
		img.save(filename1)
	else:
		print 'miniatura juz istnieje'
print filename1, 'zrobione'
