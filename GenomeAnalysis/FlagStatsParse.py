import sys 
import csv

inputfile = open(sys.argv[1], "r")
fileName = sys.argv[1][:-4] #removes the last 4 chars of the file ie ".txt"
outputfile = open(fileName + '_parsed.csv', 'w')

line = inputfile.readline()
writer = csv.writer(outputfile)
writer.writerow(('Reference Fasta', 'Mapped Reads', 'Properly Paired' ))
while line:
	if line.startswith('Flagstats'):
                name = line[32:-2]
                inputfile.readline()
		inputfile.readline()
		mapped = inputfile.readline()
		mappedStart = mapped.index('(')
                mappedPercent = mapped[mappedStart + 1:-9]
                inputfile.readline()
                inputfile.readline()
                inputfile.readline()
                properPair = inputfile.readline()
                properStart = properPair.index('(')
                properPercent = properPair[properStart + 1:-9]
		writer.writerow((name, mappedPercent, properPercent))
	line = inputfile.readline()
		


inputfile.close()
outputfile.close()
