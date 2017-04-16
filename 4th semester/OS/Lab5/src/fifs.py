from process import *

def fifs_processes_gen(procs):
    systems = get_systems(procs)
    users = get_users(procs)
    t = 0
    while systems or users:
        if systems and systems[0].start <= t:
            yield do_first(systems)
        elif users and users[0].start <= t:
            yield do_first(users)
        else:
            yield None
        t += 1