# parse each file from the photo collection and export data into CSV.
# will need: os.listdir(path)
import sys
import os
import codecs
import csv
from BeautifulSoup import BeautifulStoneSoup
 
# get the file list:
if len(sys.argv) > 1:
    dir = sys.argv[1]
else:
    dir = os.getcwd()
     
file = dir
 
# create the output dictionary
outputData = []
 
# sanity checking, only work on kml files
if file.endswith('.kml') == 0: sys.exit(-1)
 
print "Reading file: "+file
 
fh = codecs.open(file,'r',"utf-8")
html = fh.read()
fh.close()
 
soup = BeautifulStoneSoup(html)
#print soup.prettify()
 
# create a new dictionary for the current image's data
imageData = dict();
 
# get the image data:
dataTable = soup.findAll('placemark')
for i in dataTable:
    row = i.contents
 
    # add the current data to the dict
    imageData = {}
    imageData['Name'] = row[0].contents[0].string.encode("ascii","ignore")
    imageData['Description'] = row[1].contents[0].string.encode("ascii","ignore")
    imageData['Time'] = row[3].contents[0].string.encode("ascii","ignore")
    coord = row[5].coordinates.contents[0].string.encode("ascii","ignore")
    imageData['Lon'] = coord.split(',')[0]
    imageData['Lat'] = coord.split(',')[1]
 
    # add this image's data to the list
    outputData.append(imageData)
 
#print outputData
 
# create the output file
out = codecs.open(os.getcwd() + "/out.csv", 'w',"utf-8")
firstRun = 1
 
print "Writing output file: "+ out.name
try:
    fieldnames = sorted(outputData[0].keys())
    fieldnames.reverse()
    writer = csv.DictWriter(out,dialect='excel', fieldnames=fieldnames, extrasaction='ignore', quoting=csv.QUOTE_NONNUMERIC)
    headers = dict( (n,n) for n in fieldnames )
    writer.writerow(headers)
 
    for row in outputData:
         writer.writerow(row)
 
finally:
    out.close()
