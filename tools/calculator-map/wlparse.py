"""Light-weight Wolfram Language statement/definition/usage analyser (no kernel)."""
import re

IDENT = r'(?:[A-Za-z$]|\\\[[A-Za-z0-9]+\])(?:[A-Za-z0-9$]|\\\[[A-Za-z0-9]+\])*'
QIDENT = IDENT + r'(?:`' + IDENT + r')*`?'
OPS = [':=', '^:=', '/;', '//.', '/.', '//', '/@', '@@@', '@@', '@', '->', ':>', '&&', '||', '<>', '>=', '<=',
       '!=', '===', '=!=', '==', '=.', '=', '>>>', '>>', '<<', ';;', ';', '+=', '-=', '*=', '/=', '^=', '/:', '::', '~~', '|',
       '+', '-', '*', '/', '^', '<', '>', '!', '&', '.', ':', '?', '~', '#', '%', '_', '\\']
OPS.sort(key=len, reverse=True)
TOK = re.compile(
    r'(?P<ws>[ \t\r\f]+)|(?P<nl>\n)|(?P<str>"(?:[^"\\]|\\.)*")|'
    r'(?P<num>(?:[0-9]+\.?[0-9]*|\.[0-9]+)(?:`[0-9.]*)?(?:\*\^-?[0-9]+)?)|'
    r'(?P<id>' + QIDENT + r')|(?P<br>[\[\]{}()])|(?P<comma>,)|'
    r'(?P<op>' + '|'.join(re.escape(o) for o in OPS) + r')|(?P<other>.)', re.S)

def tokenize(src):
    """returns list of (kind, text, pos). Comments are returned with kind 'comment' (nested aware)."""
    out = []; i = 0; n = len(src)
    while i < n:
        if src.startswith('(*', i):
            depth = 1; j = i + 2
            while j < n and depth:
                if src.startswith('(*', j): depth += 1; j += 2
                elif src.startswith('*)', j): depth -= 1; j += 2
                elif src[j] == '"':   # strings inside comments
                    m = re.compile(r'"(?:[^"\\]|\\.)*"', re.S).match(src, j)
                    j = m.end() if m else j + 1
                else: j += 1
            out.append(('comment', src[i:j], i)); i = j; continue
        m = TOK.match(src, i)
        k = m.lastgroup
        out.append((k, m.group(0), i)); i = m.end()
    return out

BINOP_END = {':=', '=', ',', '+', '-', '*', '/', '^', '->', ':>', '/;', '&&', '||', '/.', '//', '//.', '@', '@@', '/@', '@@@',
             '<>', '==', '===', '!=', '>=', '<=', '<', '>', '/:', '^:=', '^=', '~~', '|', ':', '?', '=!=', '+=', '-=', '*=', '/=', '::', ';;', '.', '~'}

def statements(src):
    """split source into top-level statements. returns list of dict(start,end,toks(no ws/comments),lead_comments)"""
    toks = tokenize(src)
    stmts = []; cur = []; lead = []; depth = 0; last_sig = None; start = None
    def flush(end):
        nonlocal cur, lead, start
        if cur:
            stmts.append({'start': start, 'end': end, 'toks': cur, 'lead': lead})
        cur = []; lead = []; start = None
    pending_comments = []
    for (k, t, p) in toks:
        if k == 'comment':
            if cur and depth > 0: continue
            if not cur: pending_comments.append(t)
            else: cur_comments = None
            continue
        if k == 'ws': continue
        if k == 'nl':
            if depth == 0 and cur and not (last_sig and last_sig[0] == 'op' and last_sig[1] in BINOP_END):
                flush(p)
            continue
        if not cur:
            start = p; lead = pending_comments; pending_comments = []
        if k == 'br':
            if t in '[{(': depth += 1
            else: depth = max(0, depth - 1)
        if k == 'op' and t == ';' and depth == 0:
            cur.append((k, t, p)); last_sig = None
            flush(p + 1); continue
        cur.append((k, t, p)); last_sig = (k, t)
    flush(len(src))
    return stmts

def ident_base(t):
    return t.split('`')[-1] if '`' in t and not t.endswith('`') else t

def match_close(toks, i):
    """toks[i] is an opening bracket; return index of matching close"""
    d = 0
    for j in range(i, len(toks)):
        if toks[j][0] == 'br':
            if toks[j][1] in '[{(': d += 1
            elif toks[j][1] in ']})':
                d -= 1
                if d == 0: return j
    return len(toks) - 1

def find_def(st):
    """detect a definition: returns dict(name,kind,lhs_toks,rhs_start,op,params) or None"""
    toks = st['toks']; d = 0
    for i, (k, t, p) in enumerate(toks):
        if k == 'br':
            d += 1 if t in '[{(' else -1
        elif k == 'op' and d == 0 and t in (':=', '='):
            lhs = toks[:i]
            # strip trailing /; condition
            cond = None
            for j, x in enumerate(lhs):
                pass
            # find '/;' at depth 0 inside lhs
            dd = 0; condpos = None
            for j, x in enumerate(lhs):
                if x[0] == 'br': dd += 1 if x[1] in '[{(' else -1
                elif x[0] == 'op' and x[1] == '/;' and dd == 0: condpos = j; break
            core = lhs[:condpos] if condpos is not None else lhs
            if not core: return None
            # usage message?  name::usage = "..."
            if len(core) >= 3 and core[0][0] == 'id' and core[1][1] == '::':
                return {'name': ident_base(core[0][1]), 'kind': 'message', 'tag': core[2][1], 'op': t, 'rhs': i + 1, 'lhs': core, 'params': set()}
            if core[0][0] == 'id':
                name = ident_base(core[0][1])
                nxt = core[1][1] if len(core) > 1 else None
                if nxt == '[':
                    kind = 'function'
                    j = match_close(core, 1)
                    args = core[2:j]
                    params = set()
                    for q in range(len(args) - 1):
                        if args[q][0] == 'id' and args[q+1][1].startswith('_'):
                            params.add(ident_base(args[q][1]))
                        # name_: -> '_' tokenised as op '_'
                    return {'name': name, 'kind': 'function', 'op': t, 'rhs': i + 1, 'lhs': core, 'params': params, 'argtoks': args, 'cond': condpos is not None}
                if len(core) == 1:
                    return {'name': name, 'kind': 'value', 'op': t, 'rhs': i + 1, 'lhs': core, 'params': set()}
                if nxt in ('=', ) or nxt is None: pass
                # e.g. name[[i]] / Subscript etc -> treat as value-part
                return {'name': name, 'kind': 'part', 'op': t, 'rhs': i + 1, 'lhs': core, 'params': set()}
            if core[0][1] == '{':
                j = match_close(core, 0)
                names = [ident_base(x[1]) for x in core[1:j] if x[0] == 'id']
                return {'name': names[0] if names else '?', 'kind': 'multi', 'names': names, 'op': t, 'rhs': i + 1, 'lhs': core, 'params': set()}
            return None
        if k == 'op' and d == 0 and t in ('^:=', '^='): return None
    return None

LOCALIZERS = {'Module', 'Block', 'With', 'DynamicModule', 'Function', 'Table', 'Do', 'Sum', 'Product', 'Manipulate'}
def local_names(toks):
    """identifiers localised by Module/Block/With/Do/Table iterators etc. (approximate)"""
    loc = set()
    n = len(toks)
    for i, (k, t, p) in enumerate(toks):
        if k == 'id' and t in ('Module', 'Block', 'With', 'DynamicModule') and i + 2 < n and toks[i+1][1] == '[' and toks[i+2][1] == '{':
            j = match_close(toks, i + 2)
            d = 0
            expect = True
            for q in range(i + 3, j):
                kk, tt, _ = toks[q]
                if kk == 'br': d += 1 if tt in '[{(' else -1
                if d == 0 and kk == 'id' and expect: loc.add(ident_base(tt)); expect = False
                if d == 0 and kk == 'comma': expect = True
        # iterator variable: Table[expr,{i,...}], Do, Sum, Product
        if k == 'id' and t in ('Table', 'Do', 'Sum', 'Product', 'ParallelTable', 'ParallelDo', 'Array') and i + 1 < n and toks[i+1][1] == '[':
            j = match_close(toks, i + 1)
            for q in range(i + 2, j - 1):
                if toks[q][1] == '{' and toks[q+1][0] == 'id' and (q + 2 < len(toks) and toks[q+2][0] == 'comma'):
                    loc.add(ident_base(toks[q+1][1]))
    # pattern variables  x_  anywhere
    for q in range(len(toks) - 1):
        if toks[q][0] == 'id' and toks[q+1][0] == 'op' and toks[q+1][1].startswith('_'):
            loc.add(ident_base(toks[q][1]))
    # slot-free: Function[{a,b},...]
    for i, (k, t, p) in enumerate(toks):
        if k == 'id' and t == 'Function' and i + 2 < n and toks[i+1][1] == '[' and toks[i+2][1] == '{':
            j = match_close(toks, i + 2)
            for q in range(i + 3, j):
                if toks[q][0] == 'id': loc.add(ident_base(toks[q][1]))
    return loc

def body_idents(toks, start):
    """identifiers in body with usage mode: 'call' if followed by '[' , 'value' otherwise; and those assigned"""
    calls = {}; vals = {}; assigned = set()
    n = len(toks)
    for i in range(start, n):
        k, t, p = toks[i]
        if k == 'id':
            b = ident_base(t)
            nxt = toks[i+1] if i + 1 < n else None
            prev = toks[i-1] if i > start else None
            if prev and prev[0] == 'op' and prev[1] == '::': continue   # message tag f::tag
            if nxt and nxt[0] == 'op' and nxt[1] == '::': 
                vals.setdefault(b, 0); vals[b] += 1; continue
            if nxt and nxt[0] == 'op' and nxt[1] in (':=', '=', '+=', '-=', '*=', '/='):
                assigned.add(b)            # assignment target only: not a read
                continue
            nn = toks[i+2] if i + 2 < n else None
            if nxt and nxt[1] == '[' and nxt[0] == 'br' and nn and nn[1] == '[':
                vals[b] = vals.get(b, 0) + 1          # x[[i]] is a Part, i.e. a value use
            elif nxt and nxt[1] == '[' and nxt[0] == 'br':
                calls[b] = calls.get(b, 0) + 1
            elif nxt and nxt[0] == 'op' and nxt[1] in ('@', '/@', '@@', '@@@') :
                calls[b] = calls.get(b, 0) + 1
            else:
                vals[b] = vals.get(b, 0) + 1
            # assignment to identifier at statement-ish positions:  id = / id := / id++ ...
            if nxt and nxt[0] == 'op' and nxt[1] in (':=', '=', '+=', '-=', '*=', '/=') :
                # only if previous token is not part of a larger expression like a[[..]]
                assigned.add(b)
            if nxt and nxt[1] == '[' and nxt[0] == 'br':
                # f[...] = ...  or f[...] := ...
                j = match_close(toks, i + 1)
                if j + 1 < n and toks[j+1][0] == 'op' and toks[j+1][1] in (':=', '='):
                    assigned.add(b + '[]')
    return calls, vals, assigned

def nested_defs(toks):
    """definitions that occur at depth>=1 inside a statement (e.g. Block[{r}, f[x_]:=...]) whose head is not localised.
    returns list of (name, kind, op, rhs_start_idx, rhs_end_idx)"""
    out = []; n = len(toks)
    loc = local_names(toks)
    depth = 0
    for i, (k, t, p) in enumerate(toks):
        if k == 'br':
            depth += 1 if t in '[{(' else -1
        if depth < 1 or k != 'id' or i + 1 >= n or toks[i+1][1] != '[' or toks[i+1][0] != 'br': continue
        if i + 2 < n and toks[i+2][1] == '[': continue            # Part
        name = ident_base(t)
        if name in loc or name[0].isupper() and name in ('Set', 'SetDelayed'): continue
        j = match_close(toks, i + 1)
        if j + 1 >= n: continue
        op = toks[j+1]
        if op[0] != 'op' or op[1] not in (':=', '='): continue
        args = toks[i+2:j]
        has_pat = any(a[0] == 'op' and a[1].startswith('_') for a in args)
        if op[1] == '=' and not has_pat: continue
        # extent of rhs: until ',' or ';' or closing bracket at the same depth
        d = 0; e = j + 2
        while e < n:
            kk, tt, _ = toks[e]
            if kk == 'br':
                if tt in '[{(': d += 1
                else:
                    if d == 0: break
                    d -= 1
            elif d == 0 and (kk == 'comma' or (kk == 'op' and tt == ';')): break
            e += 1
        out.append((name, 'function', op[1], j + 2, e, i, j))
    return out
