import re

with open('ld.QC.xll_noinclude0.recode-502502-geno02-maf03.fa', 'r') as fin:
sequences = [(m.group(1), ''.join(m.group(2).split()))
for m in re.finditer(r'(?m)^>([^ n]+)[^n]*([^>]*)', fin.read())]
with open('output.phy', 'w') as fout:
fout.write('%d %dn' % (len(sequences), len(sequences[0][1])))
for item in sequences:
fout.write('%-20s %sn' % item)