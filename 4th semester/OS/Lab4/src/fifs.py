from process import *

def fifs_processes_gen(procs):
    t = 0
    while procs:
        if procs and procs[0].start <= t:
            yield do_first(procs)
        else:
            yield None
        t += 1
