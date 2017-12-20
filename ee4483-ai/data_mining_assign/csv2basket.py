import re
import os
import Orange

in_path = os.path.join('dataset.csv')
with open(in_path) as f:
    s = f.read() + '\n'

word = re.compile("\w+")
all_items = set(word.findall(s))

domain = Orange.data.Domain([])
domain.add_metas({Orange.orange.newmetaid(): Orange.feature.Continuous(n)
                  for n in all_items}, True)

data = Orange.data.Table(domain)
for e in s.splitlines():
    ex = Orange.data.Instance(domain)
    for m in re.findall("\w+", e):
        ex[m] = 1
    data.append(ex)

out_path = 'dataset.basket'
# f = open(out_path, 'wb')
# f.write(bin(data))
# f.close()
data.save(out_path)
