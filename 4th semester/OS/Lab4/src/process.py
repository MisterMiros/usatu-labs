def do_first(procs):
    first = procs[0]
    first.do_work()
    if first.is_finished():
        procs.remove(first)
    return first

class Process(object):

    def __init__(self, name, start, duration):
        self.name = name
        self.start = start
        self.duration = duration

    def __repr__(self):
        return str(self.name)

    def do_work(self):
        if self.duration > 0:
            self.duration -= 1

    def is_finished(self):
        return self.duration == 0

    def copy(self):
        return Process(self.name, self.start, self.duration)

    def __eq__(self, other):
        if (isinstance(other, Process)):
            return self.name == other.name
        else: return False
