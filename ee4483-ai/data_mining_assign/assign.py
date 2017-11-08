import os
import csv
import apriori
import generate_rules

file_path = os.path.join('dataset.csv')
data = []
with open(file_path, newline='') as csvfile:
    spamreader = csv.reader(csvfile, delimiter=',')
    for row in spamreader:
        data.append(row)

freq_dataset, support_data = apriori.apriori(data, minsupport=0.05)
# for f in freq_dataset:
#     print(f)
rules = generate_rules.generateRules(freq_dataset, support_data, min_confidence=0.5)
for rule in rules:
    print(rule)
