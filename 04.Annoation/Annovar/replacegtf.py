import os
path = './cattle1.2_genomic.gtf'           # 转换前的gtf文件
path2 = './cattle1.2_genomic.replace.gtf'  # 转换后的gtf文件

fh = open(path, 'r+')
fp = open(path2, 'w+')
gene_id_old = 'xxx'
count = 0
transcript_id_unknown = 'unknown_transcript_1'
transcript_id_unknown_bak = 'unknown_transcript_'
transcript_id_unknown_bak2 = 'unknown_transcript_'

for eachLine in fh.readlines():
    if eachLine._contains_(transcript_id_unknown):
        arr = eachLine.split('\t')
        arr2 = arr[8].split(';')
        arr3 = arr2[0].split()
        arr4 = arr2[1].split()
        gene_id = eval(arr3[1])
        transcript_id = eval(arr4[1])
        if gene_id != gene_id_old:
            gene_id_old = gene_id
            count += 1
            transcript_id_unknown_bak2 = transcript_id_unknown_bak + str(count)
            print(transcript_id_unknown_bak2)
            eachLine = eachLine.replace(transcript_id_unknown, transcript_id_unknown_bak2)
            print(eachLine)
            fp.write(eachLine)
        else:
            eachLine = eachLine.replace(transcript_id_unknown, transcript_id_unknown_bak2)
            print(eachLine)
            fp.write(eachLine)
    else:
        fp.write(eachLine)
fh.close()
fp.close()
          
            
