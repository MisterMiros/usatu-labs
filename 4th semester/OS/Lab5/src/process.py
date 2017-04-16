def do_first(procs):
    first = procs[0]
    first.do_work()
    if first.is_finished():
        procs.remove(first)
    return first

def get_systems(procs):
    return [p for p in procs if p.kind == Process.SYSTEM]

def get_users(procs):
    return [p for p in procs if p.kind == Process.USER]

class Process(object):

    SYSTEM = 1
    USER = 0

    def __init__(self, name, start, duration, kind):
        self.name = name
        self.start = start
        self.duration = duration
        self.kind = kind

    def __repr__(self):
        return str(self.name)

    def do_work(self):
        if self.duration > 0:
            self.duration -= 1

    def is_finished(self):
        return self.duration == 0

    def copy(self):
        return Process(self.name, self.start, self.duration, self.kind)

    def __eq__(self, other):
        if (isinstance(other, Process)):
            return self.name == other.name \
                   and self.kind == other.kind
        else: return False