from process import *
from collections import deque

def rr_processes_gen(procs, step):
    procs_q = deque()
    t = 0
    while procs or procs_q:
        if procs or procs_q:
            while procs and procs[0].start <= t:
                procs_q.append(procs.pop(0))
            if (procs_q):
                first = procs_q.popleft()
                for i in range(0,step):
                    if not first.is_finished():
                        first.do_work()
                        yield first
                    else:
                        yield None
                    t += 1
                if not first.is_finished():
                    procs_q.append(first)
        else:
            yield None
            t += 1
