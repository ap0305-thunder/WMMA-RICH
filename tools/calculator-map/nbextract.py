#!/usr/bin/env python3
"""Extract text of Input/Code/Text/heading cells from a Mathematica .nb (no kernel needed).
usage: nbextract.py in.nb out.json"""
import re, sys, json

SRC = open(sys.argv[1], encoding='utf-8', errors='replace').read()
_b = SRC.find('(* Beginning of Notebook Content *)'); _e = SRC.find('(* End of Notebook Content *)')
if _b >= 0 and _e > _b:
    # blank out everything outside the notebook content, keeping offsets stable
    SRC = ' ' * (_b + 35) + SRC[_b + 35:_e] + ' ' * (len(SRC) - _e)

# ---------- 1. locate non-group Cells with a linear bracket scan ----------
tok = re.compile(r'"(?:[^"\\]|\\.)*"|\[|\]', re.S)
stack = []          # frames: [open_idx, kind, first_end]   kind: 'cell','group','other'
cells = []          # (start, end, first_end)
for m in tok.finditer(SRC):
    t = m.group(0)
    i = m.start()
    if t == '[':
        pre = SRC[i-4:i]
        if pre == 'Cell' and not SRC[i-5:i-4].isalnum():
            kind = 'cell'
        elif SRC[i-13:i] == 'CellGroupData':
            kind = 'group'
        else:
            kind = 'other'
        stack.append([i, kind, None, False])  # False = has a first child yet
    elif t == ']':
        if not stack: break
        fr = stack.pop()
        if stack and stack[-1][1] == 'cell' and stack[-1][2] is None:
            stack[-1][2] = m.end()
        if fr[1] == 'cell':
            cells.append((fr[0], m.end(), fr[2], i))
        if not stack: break
    else:  # string
        if stack and stack[-1][1] == 'cell' and stack[-1][2] is None and i == stack[-1][0] + 1:
            stack[-1][2] = m.end()

# keep only leaf cells (those not containing a CellGroupData); cells list is in closing order
def style_of(c):
    s, e, fe, _ = c
    if fe is None: return None
    mm = re.match(r'(?:\s|\\\n)*,(?:\s|\\\n)*"([^"]+)"', SRC[fe:fe+160])   # allow \<newline> continuations
    return mm.group(1) if mm else None

leaf = []
for c in cells:
    s, e, fe, _ = c
    if fe is None: continue
    head = SRC[s+1:s+15]
    if head.startswith('CellGroupData'): continue
    leaf.append(c)
leaf.sort()   # document order

# ---------- 2. mini box parser ----------
btok = re.compile(r'(?:\s|\\\n)*("(?:[^"\\]|\\.)*"|[A-Za-z$][A-Za-z0-9$`]*|(?:[0-9]+\.?[0-9]*|\.[0-9]+)(?:`[0-9.]*)?(?:\*\^-?[0-9]+)?|->|:>|[\[\]{},]|[^\s\[\]{},"A-Za-z0-9$])', re.S)
def parse(text):
    pos = 0
    def val():
        nonlocal pos
        m = btok.match(text, pos)
        if not m: raise ValueError('tok at %d: %r' % (pos, text[pos:pos+30]))
        t = m.group(1); pos = m.end()
        if t[0] == '"': return ('s', t[1:-1])
        if t == '{':
            items = []
            m2 = btok.match(text, pos)
            if m2 and m2.group(1) == '}': pos = m2.end(); return ('l', items)
            while True:
                items.append(val())
                m2 = btok.match(text, pos)
                if not m2: raise ValueError('list at %d: %r' % (pos, text[pos:pos+30]))
                pos = m2.end()
                if m2.group(1) == '}': return ('l', items)
        if t[0].isalpha() or t[0] == '$':
            m2 = btok.match(text, pos)
            if m2 and m2.group(1) == '[':
                pos = m2.end(); args = []
                m3 = btok.match(text, pos)
                if m3 and m3.group(1) == ']': pos = m3.end(); return ('c', t, args)
                while True:
                    args.append(val())
                    m3 = btok.match(text, pos)
                    if not m3: raise ValueError('args of %s at %d: %r' % (t, pos, text[pos:pos+30]))
                    pos = m3.end()
                    if m3.group(1) == ']': return ('c', t, args)
            return ('a', t)
        return ('a', t)   # number/arrow
    return val()

GREEK_FIX = {'\\[Rule]': '->', '\\[RuleDelayed]': ':>', '\\[Equal]': '==', '\\[NotEqual]': '!=',
             '\\[LessEqual]': '<=', '\\[GreaterEqual]': '>=', '\\[And]': '&&', '\\[Or]': '||',
             '\\[Times]': '*', '\\[Not]': '!', '\\[IndentingNewLine]': '\n', '\\[NoBreak]': '',
             '\\[InvisibleSpace]': '', '\\[VeryThinSpace]': '', '\\[ThinSpace]': ' ', '\\[Colon]': ':',
             '\\[InvisibleComma]': ',', '\\[InvisibleApplication]': '', '\\[Equivalent]': '==='}
def unesc(s):
    s = s.replace('\\\n', '').replace('\\"', '"').replace('\\\\', '\\') if False else s
    for k, v in GREEK_FIX.items(): s = s.replace(k, v)
    s = s.replace('\\\n', '').replace('\\"', '"').replace('\\n', '\n').replace('\\\\', '\\')
    s = re.sub(r'\\<|\\>', '', s)
    return s

def join(parts):
    out = ''
    for p in parts:
        if out and p and re.match(r'[A-Za-z0-9$`\\]', p[0]) and re.match(r'[A-Za-z0-9$`\]]', out[-1]):
            out += ' '
        out += p
    return out

def render(n):
    k = n[0]
    if k == 's': return unesc(n[1])
    if k == 'a': return n[1]
    if k == 'l': return '{' + ','.join(render(x) for x in n[1]) + '}'
    h, a = n[1], n[2]
    R = lambda i: render(a[i]) if i < len(a) else ''
    if h == 'RowBox':
        return join([render(x) for x in a[0][1]]) if a and a[0][0] == 'l' else R(0)
    if h in ('BoxData', 'FormBox', 'StyleBox', 'TagBox', 'ButtonBox', 'TextData', 'Cell', 'AdjustmentBox', 'PaneBox', 'TooltipBox', 'ItemBox'):
        if a and a[0][0] == 'l' and h in ('BoxData', 'TextData'): return ''.join(render(x) for x in a[0][1])
        return R(0)
    if h == 'InterpretationBox': return R(0)
    if h == 'SuperscriptBox': return R(0) + '^' + R(1)
    if h == 'SubscriptBox': return 'Subscript[' + R(0) + ',' + R(1) + ']'
    if h == 'SubsuperscriptBox': return 'Subsuperscript[' + R(0) + ',' + R(1) + ',' + R(2) + ']'
    if h == 'UnderscriptBox': return 'Underscript[' + R(0) + ',' + R(1) + ']'
    if h == 'OverscriptBox': return 'Overscript[' + R(0) + ',' + R(1) + ']'
    if h == 'UnderoverscriptBox': return 'Underoverscript[' + R(0) + ',' + R(1) + ',' + R(2) + ']'
    if h == 'FractionBox': return '(' + R(0) + ')/(' + R(1) + ')'
    if h == 'SqrtBox': return 'Sqrt[' + R(0) + ']'
    if h == 'RadicalBox': return '(' + R(0) + ')^(1/(' + R(1) + '))'
    if h == 'GridBox':
        rows = a[0][1] if a and a[0][0] == 'l' else []
        return '{' + ','.join('{' + ','.join(render(c) for c in (r[1] if r[0] == 'l' else [r])) + '}' for r in rows) + '}'
    return R(0)

# ---------- 3. walk cells, keep interesting styles, track section path ----------
LEVEL = {'Title': 0, 'Subtitle': 1, 'Subsubtitle': 2, 'Chapter': 0, 'Section': 3, 'Subsection': 4, 'Subsubsection': 5}
SKIP = {'Output', 'Print', 'Message', 'MSG', 'Echo', 'PrintTemporary'}
path = [None] * 6
out = []
for idx, (s, e, fe, _) in enumerate(leaf):
    st = style_of((s, e, fe, 0))
    if st is None or st in SKIP: continue
    body = SRC[s+1:fe]            # first argument of Cell
    try:
        txt = render(parse(body)) if len(body) < 3_000_000 else ''
    except Exception as ex:
        txt = '<<PARSE ERROR %s>>' % ex
    txt = txt.strip('\n')
    if st in LEVEL:
        lv = LEVEL[st]; path[lv] = txt.strip()
        for j in range(lv+1, 6): path[j] = None
    tagm = re.search(r'CellTags\s*->\s*(\{[^}]*\}|"[^"]*")', SRC[fe:e])
    out.append({'i': len(out), 'pos': s, 'style': st, 'noeval': bool(re.search(r'Evaluatable\s*->\s*False', SRC[fe:e])), 'init': 'InitializationCell' in SRC[fe:e],
                'path': [p for p in path if p], 'text': txt, 'tags': tagm.group(1) if tagm else None})
json.dump(out, open(sys.argv[2], 'w'), ensure_ascii=False)
from collections import Counter
print(len(out), 'cells kept;', dict(Counter(c['style'] for c in out)))
