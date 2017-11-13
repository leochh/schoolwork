import os
import csv
import Orange

# file_path = os.path.join('dataset.csv')
# data = []
# with open(file_path, newline='') as csvfile:
#     spamreader = csv.reader(csvfile, delimiter=',')
#     for row in spamreader:
#         data.append(row)

data = Orange.data.Table("dataset.basket")
print(data.metas)
