#Need to pass in name of fastq file to be trimmed and which basepair to trim
#in Terminal, you would call: "python trim_fastq.py test.fastq 100" to trim off 100
import sys

inputfile = open(sys.argv[1], "r")
fileName = sys.argv[1][:-6] #removes the last 6 chars of the file ie ".fastq"
outputfile = open(fileName + "_trim" + sys.argv[2] + ".fastq", "w") 
line = inputfile.readline()
          
while line:
    line1 = line
    line2 = inputfile.readline()
    line3 = inputfile.readline()
    line4 = inputfile.readline()
    outputfile.write(line1)
    outputfile.write(line2[:-(len(line2)-int(sys.argv[2]))] + "\n")
    outputfile.write(line3)
    outputfile.write(line4[:-(len(line4)-int(sys.argv[2]))] + "\n")
    line = inputfile.readline()
    
inputfile.close()
outputfile.close()
