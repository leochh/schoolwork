import os
import csv
from pyspark import SparkContext
from pyspark.mllib.fpm import FPGrowth

file_path = os.path.join('dataset.csv')
data = []
with open(file_path, newline='') as csvfile:
    spamreader = csv.reader(csvfile, delimiter=',')
    for row in spamreader:
        data.append(row)

sc = SparkContext()
rdd = sc.parallelize(data, 6)
model = FPGrowth.train(rdd, minSupport=0.03, numPartitions=6)
result = model.freqItemsets().collect()
for fi in result:
    print(fi)
print(len(result))
