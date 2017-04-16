from process import *
from collections import deque

def rr_processes_gen(procs, step):
    systems = get_systems(procs)
    users = get_users(procs)
    users_q = deque()
    t = 0
    while systems or users or users_q:
        if systems and systems[0].start <= t:
            yield do_first(systems)
            t += 1
        elif users or users_q:
            while users and users[0].start <= t:
                users_q.append(users.pop(0))
            if (users_q):
                first = users_q.popleft()
                for i in range(0,step):
                    if not first.is_finished():
                        first.do_work()
                        yield first
                    else:
                        yield None
                    t += 1
                if not first.is_finished():
                    users_q.append(first)
        else:
            yield None
            t += 1