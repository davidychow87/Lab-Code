import datetime
import os
import csv
# make sure name is right
outputfile = open("600.csv", 'wb') #note has to be wb in order to not have blank rows
writer = csv.writer(outputfile)

lettArr = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H']
numArr = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]
samples = []




for letter in lettArr:
    for number in numArr:
        samples.append((letter + str(number)).strip())
samples.insert(0, 'hr')
array = []
array.append(samples)

writer.writerows(array)
def findNum(string, first, last):
    try:
        start = string.index(first) + len(first)
        end = string.index(last, start)
        return string[start: end]
    except ValueError:
        return ""

fileArray = []
for file in os.listdir(os.getcwd()):
    temp =[]
    if file.endswith(".txt"):
        timePoint = findNum(file, '-', '-')
        timePoint = float(timePoint)
        temp.append(timePoint)
        temp.append(file)
    if len(temp) > 0:
        fileArray.append(temp)

   
fileArray.sort(key=lambda x: x[0])

#print fileArray

dataArray = []
for each in fileArray:
    with open(each[1], 'r') as f:
        arr=[x.strip().split('\t') for x in f]
    tempArray = []
    for i in range(2, 10): # note this is for 600 OD
        row = arr[i]
        row.pop(len(arr[i])-1)
        row.pop(0)
        tempArray += row
        
    tempArray.insert(0, each[0])
    if len(tempArray) > 0:
        dataArray.append(tempArray)


writer.writerows(dataArray)


outputfile.close()
#print fileArray
