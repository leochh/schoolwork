import csv

csv_file = 'dataset.csv'
output = 'dataset.tab'

in_file = csv.reader(open(csv_file, 'r'))
out_file = csv.writer(open(output, 'w'), delimiter='\t')

out_file.writerows(in_file)
