import json, os, re, sys, glob
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from wlparse import *
ROOT, CELLS, OUTDEFS = sys.argv[1:4]
cells = json.load(open(CELLS))

CHAIN = ['myNotebookInit', 'cellStyleDataRules', 'base', 'statDataAnal', 'physicsGeneral', 'inputDataForRICH', 'RICH', 'calculator']
defs = {}      # name -> list of def records
allstm = []    # all statements with info

def add_def(origin, loc, st, src_text, extra):
    d = find_def(st)
    toks = st['toks']
    # nested definitions (Block[{..}, f[x_]:=...]) -- registered as globals unless localised
    for (nm, kd, op, rs, re_, hi, hj) in nested_defs(st['toks']):
        sub = st['toks'][rs:re_]
        calls, vals, assigned = body_idents(sub, 0)
        defs.setdefault(nm, []).append({'name': nm, 'kind': 'function', 'op': op, 'origin': origin, 'loc': loc, 'calls': calls, 'vals': vals,
            'assigned': sorted(assigned), 'locals': sorted(local_names(sub)), 'text': src_text[sub[0][2]: sub[-1][2] + len(sub[-1][1])] if sub else '',
            'lead': [], 'tag': None, 'cond': False, 'nargs': None, 'nested': True, **extra})
    if d is None:
        return
    rhs = d['rhs']
    calls, vals, assigned = body_idents(toks, rhs)
    # also identifiers on LHS defaults (args default values)
    lcalls, lvals, _ = body_idents(toks, 0) if d['kind'] == 'function' else ({}, {}, set())
    loc_names = local_names(toks[rhs:]) | d['params']
    rec = {'name': d['name'], 'kind': d['kind'], 'op': d['op'], 'origin': origin, 'loc': loc,
           'calls': calls, 'vals': vals, 'assigned': sorted(assigned), 'locals': sorted(loc_names),
           'text': src_text[st['start']:st['end']], 'lead': [c for c in st['lead']], 'tag': d.get('tag'),
           'cond': d.get('cond', False), 'nargs': None}
    if d['kind'] == 'function':
        # signature text
        a = d['argtoks']; 
        rec['sig'] = src_text[st['start']: toks[rhs-2][2] + len(toks[rhs-2][1])] if False else None
    rec.update(extra)
    if d['kind'] == 'multi': rec['names'] = d['names']
    defs.setdefault(d['name'], []).append(rec)
    return rec

# ---- libraries
lib_info = {}
for name in CHAIN:
    path = os.path.join(ROOT, 'src', name + '.wl')
    if not os.path.exists(path): continue
    txt = open(path, encoding='utf-8', errors='replace').read()
    lib_info[name] = {'bytes': len(txt)}
    nl = [m.start() for m in re.finditer('\n', txt)]
    import bisect
    for st in statements(txt):
        line = bisect.bisect_right(nl, st['start']) + 1
        add_def(name + '.wl', {'file': 'src/%s.wl' % name, 'line': line}, st, txt, {'source': 'lib'})
# ---- notebook
nbn = 'calculator.nb'
for c in cells:
    if c['style'] != 'Input': continue
    txt = c['text']
    for st in statements(txt):
        add_def(nbn, {'cell': c['i'], 'path': c['path'], 'noeval': c['noeval']}, st, txt, {'source': 'nb'})
json.dump(defs, open(OUTDEFS, 'w'), default=list)
print(len(defs), 'distinct names;', sum(len(v) for v in defs.values()), 'definitions')
from collections import Counter
print(Counter((r['origin'], r['kind']) for v in defs.values() for r in v))
