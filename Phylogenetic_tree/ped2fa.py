import sys
input_ped = sys.argv[1]
output_fa = sys.argv[2]
a1=open(input_ped , "r")
x = a1.readline()
b1 = open(output_fa , "w")
i=0
while x:
    x = x.strip().split()
    c= (">",x[0])
    columns= ''.join(c)
    b1.write(columns + "\n")
    seq = ''.join(x[6:])
    sequence = seq.replace("0", "N")
    leng =int(len(sequence))
    len1 =leng-1
    all = ("A","T","C","G")
    while i<len1:
        b1.write(sequence[i])
        i = i+2
    b1.write("\n")
    x = a1.readline()
    i=0
a1.close
b1.close
