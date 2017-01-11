# Uses SeqIO from BioPython
#In terminal, need to pass in name of fastq file and the cut off for Phred score
#i.e. python filter_fastq.py test.fastq 20
import sys
from Bio import SeqIO

inputFile = open(sys.argv[1], "r")
fileName = sys.argv[1][:-6]

goodReads = (rec for rec in SeqIO.parse(sys.argv[1], "fastq")
             if min(rec.letter_annotations["phred_quality"]) >= int(sys.argv[2]))
count = SeqIO.write(goodReads, fileName + "_filtered.fastq", "fastq")
print("Saved %i reads" %count)
