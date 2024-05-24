#!/usr/bin/env python
# -*- encoding: utf-8 -*-
'''
@File    :   FilterFastaGap.py
@Time    :   2024/05/24 10:35:39
@Author  :   Lulu Shi 
@Mails   :   crazzy_rabbit@163.com
@link    :   https://github.com/Crazzy-Rabbit
'''

import click

def load_fa(fafile):
    seqdict = {}
    with open(fafile) as f:
        seq_id = f.readline().strip().split()[0][1:]
        tmp_seq = []
        for line in f:
            if line[0] != '>':
                tmp_seq.append(line.strip())
            else:
                seqdict[seq_id] = ''.join(tmp_seq)
                seq_id = line.strip().split()[0][1:]
                tmp_seq = []

        seqdict[seq_id] = ''.join(tmp_seq)
    return seqdict

@click.command()
@click.option('infasta')
@click.option('outfasta')
@click.option('--miss', help="缺失比例(N)", type=float, default=0.25)
def main(infasta, outfasta, miss):
    seq = load_fa(infasta)
    with open(outfasta, 'w') as f:
        for name, string in seq.items():
            if (string.upper().count('N') / len(string)) < miss:
                f.write(f'>{name}\n{string}\n')

if __name__ == '__main__':
    main()
