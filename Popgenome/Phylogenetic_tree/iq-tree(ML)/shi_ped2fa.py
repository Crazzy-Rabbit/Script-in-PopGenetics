import click

@click.command()
@click.option('--ped', '-p', type=click.File('r'), required=True,
             help='需要转换为fa格式的ped文件')
@click.option('--out', '-o', type=click.File('r'), required=True,
             help='输出文件名称')
def main(ped, out):
    with open (ped, "r") as a1:
        x = a1.readline()
    with open (out, "w") as b1:
        i = 0
        while x:
            x = x.strip().split()
            c = (">", x[0])
            columns = ''.join(c)
            b1.write(columns + "\n")
            seq = ''.join(x[6:])
            sequence = seq.replace("0", "N")
            leng = int(len(sequence))
            len1 = leng-1
            all = ("A", "T", "C", "G")
            while i < len1:
                b1.write(sequence[i])
                i = i+2
            b1.write("\n")

            
if __name__ == '__main__':
    main
