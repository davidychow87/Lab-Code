import datetime
import os
import csv
first = datetime.datetime(2016, 10, 5, 15, 6, 8)

for file in os.listdir(os.getcwd()):
    if file.endswith(".txt"):
        year = int(file[8:12])
        month = int(file[12:14])
        if file[14:16].startswith('0'):
            day = int(file[15:16])
        else:
            day = int(file[14:16])
        
        if file[17:19].startswith('0'):
            hour = int(file[18:19])
        else:
            hour = int(file[17:19])
        
        if file[19:21].startswith('0'):
            minute = int(file[20:21])
        else:
            minute = int(file[19:21])
        
        if file[21:23].startswith('0'):
            second = int(file[22:23])
        else:
            second = int(file[21:23])
            
        thistime = datetime.datetime(year, month, day, hour, minute, second)
        delta = thistime - first
        #note timedelta is in days 'delta.days' and seconds 'delta.seconds'
        totalHours = round(float(delta.days * 24) + (float(delta.seconds) / 3600), 1)
        totalHours = str(totalHours)
             
        os.rename(file, file[:-4] + "-" + totalHours + "-.txt")  
