from process import *

def sjf_processes_gen(procs):
    systems = get_systems(procs)
    users = get_users(procs)
    users_s = []
    running = None
    t = 0
    while running or systems or users or users_s:
        if systems and systems[0].start <= t:
            yield do_first(systems)
        elif running:
            running.do_work();
            yield running
            if running.is_finished():
                running = None
        elif users or users_s:
            while users and users[0].start <= t:
                users_s.append(users.pop(0))
            if users_s:
                users_s = sorted(users_s, key=lambda p: p.duration)
                running = users_s.pop(0)
                continue
        else:
            yield None
        t += 1


