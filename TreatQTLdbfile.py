#! /usr/bin/env python
# -*- coding: utf-8 -*-
"""
Created on  09 25 10:38:58  2023

@Author: Lulu Shi

@Mails: crazzy_rabbit@163.com
"""
import sys

QTLdb = sys.argv[1]
out = open('QTLdb.txt', 'w')
with open (QTLdb, 'r') as f:
    for line in QTLdb:
        if line.startswith("#"):
            continue
        if line.startswith('Chr'):
            tempStart = line.strip().split("\t")[1]
            tempEnd = line.strip().split("\t")[2]
            if tempStart < tempEnd:
                out.write(line + '\n')
            elif tempStart > tempEnd:
                tempStart, tempEnd = tempEnd, tempStart
                out.write(line + '\n')
                
QTLdb.close()
out.close()