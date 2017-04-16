from process import *

def sjf_processes_gen(procs):
    procs_s = []
    running = None
    t = 0
    while running or procs or procs_s:
        if running:
            running.do_work();
            yield running
            if running.is_finished():
                running = None
        elif procs or procs_s:
            while procs and procs[0].start <= t:
                procs_s.append(procs.pop(0))
            if procs_s:
                procs_s = sorted(procs_s, key=lambda p: p.duration)
                running = procs_s.pop(0)
                continue
        else:
            yield None
        t += 1
