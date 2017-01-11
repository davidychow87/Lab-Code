import csv

lettArr = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H']
numArr = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]
header = []

for number in numArr:
    for letter in lettArr:
        header.append((letter + str(number)).strip())

header.insert(0, 'hr')
print header

with open('600.csv', 'r') as inputfile, open('600_reordered.csv', 'wb') as outputfile:
               
    fieldnames = header
    writer = csv.DictWriter(outputfile, fieldnames=fieldnames)
    writer.writeheader()
    for row in csv.DictReader(inputfile):
        if row:
            writer.writerow(row)

inputfile.close()
outputfile.close()
