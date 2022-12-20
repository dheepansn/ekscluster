import requests, csv
from datetime import datetime
import pandas as pd

csvFile = open('url.csv','r')
names = []
urls = []

csvFile.readline()
t = []

with open('Final.csv', 'w') as f:
    for name, url in csv.reader(csvFile, delimiter=','):
            names.append(name)
            urls.append(url)
            url = url
            payload={}
            response = requests.request("GET", url, data=payload)
            now = datetime.now()
            dt_string = now.strftime("%d/%m/%Y %H:%M:%S")
            row = f'{dt_string, response.status_code, url}\n'
            print(row)
            f.write(row)
a = pd.read_csv("Final.csv")
a.to_html("Final.htm")
html_file = a.to_html
