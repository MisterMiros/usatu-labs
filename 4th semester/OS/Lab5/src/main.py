#!/usr/bin/python3

import sys
from itertools import groupby
from process import *
from fifs import fifs_processes_gen
from rr import rr_processes_gen
from sjf import sjf_processes_gen

file = open(sys.argv[1], "r")
procs_temp = [[int(n) for n in l.split(" ")] for l in file]
procs = [Process(i, p[0], p[1], p[2]) for i, p in enumerate(procs_temp)]
file.close()

fifs_procs = [p.copy() for p in procs]
fifs_result = list(fifs_processes_gen(fifs_procs))
print(fifs_result)

rr_procs = [p.copy() for p in procs]
rr_result = [p for p in rr_processes_gen(rr_procs, 2)]
print(rr_result)

sjf_procs = [p.copy() for p in procs]
sjf_result = [p for p in sjf_processes_gen(sjf_procs)]
print(sjf_result)

def average_time(procs, times):
    summa = 0
    for p in procs:
        start = p.start
        finish = last_index(p, times) + 1
        summa += finish - start
    return summa / len(procs)

def last_index(it, lst):
    return len(lst) - 1 - lst[::-1].index(it)

print(average_time(procs, fifs_result))