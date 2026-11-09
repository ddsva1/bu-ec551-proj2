"""
DAG and scheduling.


Scheduling modes:
    asap    - As Soon As Possible, unconstrained
    alap    - As Late As Possible, unconstrained, working back from a latency bound
    casap   - resource-constrained ASAP
    calap   - resource-constrained ALAP
    custom  - force-directed scheduling: for a given latency
              bound, spread operations across steps to minimise the number of
              functional units needed (greedy)
"""

from dataclasses import dataclass, field


OP_TYPES = ("add", "sub", "mul")
SYMBOL_TO_TYPE = {"+": "add", "-": "sub", "*": "mul"}
TYPE_TO_SYMBOL = {v: k for k, v in SYMBOL_TO_TYPE.items()}
FU_MODULE = {"add": "adder", "sub": "subtractor", "mul": "multiplier"}
COMMUTATIVE = {"add", "mul"}


class HLSError(Exception):
    """A user-facing error (bad input, impossible constraint, ...)."""


@dataclass
class Op:
    id: str      # "op0", "op1", ...
    dest: str    # SSA name written, e.g. "X_0"
    op: str      # "add" | "sub" | "mul"
    a: object    # SSA name (str) or integer constant (int)
    b: object
    line: int    # 1-based index of the SSA equation

    def text(self):
        return f"{self.dest} = {self.a} {TYPE_TO_SYMBOL[self.op]} {self.b}"


def _operand(tok):
    return int(tok) if tok.isdecimal() else tok


def parse_ssa(ssa_equations):
    ops = []
    for idx, eq in enumerate(ssa_equations):
        lhs, rhs = eq.split("=")
        a_tok, sym, b_tok = rhs.split()
        ops.append(Op(id=f"op{idx}", dest=lhs.strip(), op=SYMBOL_TO_TYPE[sym],
                      a=_operand(a_tok), b=_operand(b_tok), line=idx + 1))
    return ops


def base_name(ssa_name):
    """'X_12' -> 'X'"""
    return ssa_name.rsplit("_", 1)[0]


class DAG:
    """
    Nodes are operations, edges are data dependencies.
    self.ops is in SSA (equation) order, which is also a topological order.
    """

    def __init__(self, ops, var_map):
        self.ops = list(ops)
        if not self.ops:
            raise HLSError("the DAG has no nodes (no equations in the input file)")
        self.by_id = {o.id: o for o in self.ops}
        self.producer = {}  # SSA value name -> op id that writes it
        for o in self.ops:
            if o.dest in self.producer:
                raise HLSError(f"SSA value {o.dest} is assigned twice (lines "
                               f"{self.by_id[self.producer[o.dest]].line} and {o.line})")
            self.producer[o.dest] = o.id

        self.preds = {o.id: [] for o in self.ops}
        self.succs = {o.id: [] for o in self.ops}
        self.edges = []           # (from_op, to_op, value)
        self.inputs = []          # primary inputs (read but never written)
        self.constants = []       # integer constants used as operands
        self.consumers = {}       # value name -> list of op ids reading it

        for o in self.ops:
            for operand in (o.a, o.b):
                if isinstance(operand, int):
                    if operand not in self.constants:
                        self.constants.append(operand)
                    continue
                self.consumers.setdefault(operand, [])
                if o.id not in self.consumers[operand]:
                    self.consumers[operand].append(o.id)
                if operand in self.producer:
                    p = self.producer[operand]
                    if self.by_id[p].line >= o.line:
                        raise HLSError(f"line {o.line} reads {operand} before it is computed (line "
                                       f"{self.by_id[p].line})")
                    if p not in self.preds[o.id]:
                        self.preds[o.id].append(p)
                        self.succs[p].append(o.id)
                        self.edges.append((p, o.id, operand))
                elif operand not in self.inputs:
                    self.inputs.append(operand)

        # outputs: the final version of every variable that is assigned somewhere
        finals = {v for v in var_map.values() if v in self.producer}
        self.outputs = [o.dest for o in self.ops if o.dest in finals]

    def evaluate(self, input_values, width):
        """Reference model: {value: result} for every SSA value, modulo 2**width."""
        mask = (1 << width) - 1
        env = {k: v & mask for k, v in input_values.items()}

        def val(x):
            return x & mask if isinstance(x, int) else env[x]

        for o in self.ops:
            a, b = val(o.a), val(o.b)
            if o.op == "add":
                r = a + b
            elif o.op == "sub":
                r = a - b
            else:
                r = a * b
            env[o.dest] = r & mask
        return env


@dataclass
class Schedule:
    mode: str
    steps: dict                 # op id -> control step (1-based)
    latency: int                # number of control steps
    limits: dict = field(default_factory=dict)   # type -> max units (None = unlimited)

    def ops_in_step(self, dag, t):
        return [o for o in dag.ops if self.steps[o.id] == t]


def _check_limits(dag, limits):
    """Fill in missing types as unlimited (None); reject a limit of 0 for a used type."""
    limits = {t: (limits or {}).get(t) for t in OP_TYPES}
    for o in dag.ops:
        lim = limits[o.op]
        if lim is not None and lim < 1:
            raise HLSError(f"the equations need at least one {FU_MODULE[o.op]} but the limit is {lim}")
    return limits


def _check_latency(dag, latency):
    cp = asap(dag).latency
    if latency is None:
        return cp
    if latency < cp:
        raise HLSError(f"latency bound {latency} is shorter than the critical path ({cp} steps)")
    return latency


def _frames(dag, latency, fixed=None):
    fixed = fixed or {}
    early, late = {}, {}
    for o in dag.ops:
        e = max([early[p] + 1 for p in dag.preds[o.id]], default=1)
        early[o.id] = fixed.get(o.id, e)
    for o in reversed(dag.ops):
        l = min([late[s] - 1 for s in dag.succs[o.id]], default=latency)
        late[o.id] = fixed.get(o.id, l)
    return early, late


def asap(dag):
    early, _ = _frames(dag, 0)
    return Schedule("asap", early, max(early.values()))


def alap(dag, latency=None):
    L = _check_latency(dag, latency)
    _, late = _frames(dag, L)
    return Schedule("alap", late, L)


def constrained_asap(dag, limits):
    limits = _check_limits(dag, limits)
    prio = asap(dag).steps
    steps = {}
    t = 0
    while len(steps) < len(dag.ops):
        t += 1
        used = {k: 0 for k in OP_TYPES}
        ready = [o for o in dag.ops if o.id not in steps
                 and all(p in steps and steps[p] < t for p in dag.preds[o.id])]
        ready.sort(key=lambda o: (prio[o.id], o.line))
        for o in ready:
            lim = limits[o.op]
            if lim is None or used[o.op] < lim:
                steps[o.id] = t
                used[o.op] += 1
    return Schedule("casap", steps, t, limits)


def constrained_alap(dag, limits):
    limits = _check_limits(dag, limits)
    prio = alap(dag).steps
    rsteps = {}   # reverse step: 1 = last control step
    r = 0
    while len(rsteps) < len(dag.ops):
        r += 1
        used = {k: 0 for k in OP_TYPES}
        ready = [o for o in dag.ops if o.id not in rsteps
                 and all(s in rsteps and rsteps[s] < r for s in dag.succs[o.id])]
        ready.sort(key=lambda o: (-prio[o.id], -o.line))
        for o in ready:
            lim = limits[o.op]
            if lim is None or used[o.op] < lim:
                rsteps[o.id] = r
                used[o.op] += 1
    steps = {k: r - v + 1 for k, v in rsteps.items()}   # flip so the first step is 1
    return Schedule("calap", steps, r, limits)


def force_directed(dag, latency=None):
    """
    Force-directed scheduling (Paulin & Knight, 1989).

    For a fixed latency bound, every unscheduled op has a time frame
    [ASAP, ALAP] and is assumed equally likely to land in any step of it.
    Summing those probabilities per FU type gives a "distribution graph"
    DG[type][step] (expected number of busy units).  Placing op o in step s
    changes the probabilities of o and, through the dependency edges, of its
    predecessors and successors.  The "force" of that placement is
        sum over affected ops, steps of DG[type][step] * (new_p - old_p)
    and a low force means the placement moves work out of crowded steps.
    Each iteration fixes the single (op, step) with the lowest force.
    """
    L = _check_latency(dag, latency)

    fixed = {}
    while True:
        early, late = _frames(dag, L, fixed)
        for o in dag.ops:                      # ops with no freedom are trivially fixed
            if o.id not in fixed and early[o.id] == late[o.id]:
                fixed[o.id] = early[o.id]
        if len(fixed) == len(dag.ops):
            break
        early, late = _frames(dag, L, fixed)

        dg = {t: [0.0] * (L + 2) for t in OP_TYPES}
        for o in dag.ops:
            p = 1.0 / (late[o.id] - early[o.id] + 1)
            for s in range(early[o.id], late[o.id] + 1):
                dg[o.op][s] += p

        best = None
        for o in dag.ops:
            if o.id in fixed:
                continue
            for s in range(early[o.id], late[o.id] + 1):
                trial = dict(fixed)
                trial[o.id] = s
                e2, l2 = _frames(dag, L, trial)
                force = 0.0
                for q in dag.ops:
                    if e2[q.id] == early[q.id] and l2[q.id] == late[q.id]:
                        continue
                    p_old = 1.0 / (late[q.id] - early[q.id] + 1)
                    p_new = 1.0 / (l2[q.id] - e2[q.id] + 1)
                    for x in range(min(early[q.id], e2[q.id]), max(late[q.id], l2[q.id]) + 1):
                        old = p_old if early[q.id] <= x <= late[q.id] else 0.0
                        new = p_new if e2[q.id] <= x <= l2[q.id] else 0.0
                        force += dg[q.op][x] * (new - old)
                key = (round(force, 9), o.line, s)
                if best is None or key < best[0]:
                    best = (key, o.id, s)
        fixed[best[1]] = best[2]

    return Schedule("custom", dict(fixed), L)


def run_scheduler(dag, mode, limits=None, latency=None):
    """
    Dispatch to one of the scheduling modes.
    limits  : used by casap/calap only
    latency : used by alap/custom only
    """
    if mode == "asap":
        return asap(dag)
    if mode == "alap":
        return alap(dag, latency)
    if mode == "casap":
        return constrained_asap(dag, limits)
    if mode == "calap":
        return constrained_alap(dag, limits)
    if mode == "custom":
        return force_directed(dag, latency)
    raise HLSError(f"unknown scheduling mode '{mode}'")


def resource_usage(dag, sched):
    """Peak number of simultaneously busy units of each type = units to instantiate."""
    usage = {t: 0 for t in OP_TYPES}
    for step in range(1, sched.latency + 1):
        for t in OP_TYPES:
            n = sum(1 for o in dag.ops if o.op == t and sched.steps[o.id] == step)
            usage[t] = max(usage[t], n)
    return usage


def format_schedule(dag, sched):
    """The schedule as text (the assignment asks the tool to output the schedule)."""
    usage = resource_usage(dag, sched)
    limits = ", ".join(f"{FU_MODULE[t]}s<={v}" for t, v in sched.limits.items() if v is not None)
    lines = [f"Schedule mode : {sched.mode}",
             f"Latency       : {sched.latency} control steps",
             f"Limits        : {limits or 'none'}",
             ""]
    for t in range(1, sched.latency + 1):
        lines.append(f"Step {t}:")
        for o in sched.ops_in_step(dag, t):
            lines.append(f"    {o.id:<5} {o.text()}")
    lines.append("")
    lines.append("Functional units required:")
    for t in OP_TYPES:
        lines.append(f"  {FU_MODULE[t]:<11}: {usage[t]}")
    return "\n".join(lines)
