import pandas as pd

tables = pd.read_html("https://github.com/RooneyMcNibNug/FOIA/blob/master/Research/agency_records_retention_db.csv") #header=0, parse_dates["Date"])
print(tables[0])
#print(tables[0].to_json)
#print(tables[0].to_csv)
