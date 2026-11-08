#!/usr/bin/env python3
"""Generate docs/CALCULATOR_MAP.md from the extracted notebook cells and the definition index.

usage: build_map.py <repo_root> <cells.json> <defs.json> <out.md> <notebook-file-name>
"""
import json, re, sys, os, datetime
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from wlparse import *

ROOT, CELLS, DEFS, OUT, NBNAME = sys.argv[1:6]
cells = json.load(open(CELLS)); defs = json.load(open(DEFS))
MAINS = ['doCalcAllExperiment', 'doSetExperiment', 'doCalcExperiment', 'doCalcSignificance', 'doAllSignificancePlots']
TAG = {'doCalcAllExperiment': 'A', 'doSetExperiment': 'S', 'doCalcExperiment': 'E', 'doCalcSignificance': 'G', 'doAllSignificancePlots': 'P'}
LEVEL = {'Title': 0, 'Subtitle': 1, 'Subsubtitle': 2, 'Section': 3, 'Subsection': 4, 'Subsubsection': 5}


# ------------------------------------------------------------------ helpers
def pick(name):
    c = [r for r in defs.get(name, []) if r['kind'] == 'function' and not r.get('nested')]
    return max(c, key=lambda r: len(r['text'])) if c else None

def where(r, short=False):
    l = r['loc']
    if 'file' in l: return '`%s:%d`' % (l['file'], l['line'])
    return 'cell %d' % l['cell'] if short else 'cell %d (%s)' % (l['cell'], ' › '.join(l['path'][-2:]))

def live_toks(t): return [x for x in tokenize(t) if x[0] not in ('ws', 'nl', 'comment')]

def render(src, toks):
    return re.sub(r'\s+', ' ', src[toks[0][2]:toks[-1][2] + len(toks[-1][1])]).strip() if toks else ''

def split0(toks):
    parts = []; cur = []; d = 0
    for k, t, p in toks:
        if k == 'br': d += 1 if t in '[{(' else -1
        if d == 0 and k == 'comma': parts.append(cur); cur = []; continue
        cur.append((k, t, p))
    if cur: parts.append(cur)
    return parts

def signature(name):
    r = pick(name); t = r['text']; toks = live_toks(t)
    j = match_close(toks, 1)
    return [render(t, p) for p in split0(toks[2:j])]

def returns(name):
    r = pick(name); t = r['text']; toks = live_toks(t); last = None
    for i, (k, tt, p) in enumerate(toks):
        if tt == 'Return' and i + 3 < len(toks) and toks[i + 1][1] == '[' and toks[i + 2][1] == '{': last = i
    if last is None: return []
    j = match_close(toks, last + 2)
    return [render(t, p) for p in split0(toks[last + 3:j])]

def reach(starts, depth, stop=(), skip=()):
    """names reachable from `starts` through function/value bodies; `stop` names are listed but not expanded,
    `skip` names are ignored altogether (used for globals that the main functions assign themselves)"""
    seen = {}; fr = [(s, 0) for s in starts]
    while fr:
        n, dp = fr.pop(0)
        for r in defs.get(n, []):
            if r['kind'] not in ('function', 'value'): continue
            loc = set(r['locals'])
            for k in set(r['calls']) | set(r['vals']):
                if k in loc or k == n or k not in defs or k in seen or k in skip: continue
                seen[k] = dp + 1
                if dp + 1 < depth and k not in stop and r['kind'] == 'function': fr.append((k, dp + 1))
    return seen

GREEK = {'\\[Delta]': 'δ', '\\[Mu]': 'μ', '\\[Lambda]': 'λ', '\\[Gamma]': 'γ', '\\[Sigma]': 'σ', '\\[Theta]': 'θ', '\\[Alpha]': 'α', '\\[Beta]': 'β', '\\[Epsilon]': 'ε'}
def pretty(name):
    for k, v in GREEK.items(): name = name.replace(k, v)
    return name

def direct(name):
    r = pick(name); loc = set(r['locals'])
    ok = lambda k: k in defs and k not in loc and k != name and any(x['kind'] in ('function', 'value') for x in defs[k])
    calls = {k for k in r['calls'] if ok(k)}
    vals = {k for k in r['vals'] if ok(k) and k not in calls}
    return calls, vals

def esc(s): return s.replace('|', '\\|')
def nbsites(n): return [r for r in defs.get(n, []) if r['source'] == 'nb' and r['kind'] in ('function', 'value')]
def live_text(t): return ''.join(x[1] for x in tokenize(t) if x[0] != 'comment')

def span(text, style, any_level=False, prefix=False):
    """(first, last) cell index of the block introduced by a heading"""
    for c in cells:
        if c['style'] == style and (c['text'].strip().startswith(text) if prefix else c['text'].strip() == text):
            lv = LEVEL[style]; end = len(cells) - 1
            for d in cells[c['i'] + 1:]:
                if d['style'] in LEVEL and (any_level or LEVEL[d['style']] <= lv): end = d['i'] - 1; break
            return c['i'], end
    return None

def rng(sp): return '%d–%d' % sp if sp else 'n/a'


# ------------------------------------------------------------------ descriptions (each checked against the definition)
DESC = {
    'toPure': 'strip units (`QuantityMagnitude`)', 'toMRad': 'convert to milliradians', 'toNanS': 'convert to nanoseconds',
    'toMMet': 'convert to millimetres', 'toNumPixels': 'tag a number as pixels (`IndependentUnit["pix"]`)',
    'toNumPhotons': 'tag a number as photons (`IndependentUnit["pho"]`)', 'toCounts': 'tag a number as counts (`IndependentUnit["cnts"]`)',
    'toIntensity': 'convert a Quantity to MHz/mm²', 'toGeVc': 'tag a number as GeV/c', 'createMRad': 'build a milliradian Quantity from a number',
    'mmToMRad': 'mrad per mm at the effective focal length (default `thisEffFocalLength`)', 'mRadToMm': 'mm per mrad at the effective focal length',
    'calcBinaryOccupancyFromTrueToApparent': 'mean true counts → apparent binary occupancy, `1-Exp[-x]`',
    'fiducialAreaOfTheRing': 'annulus area from radius and radial width `[r, δr, α:1]`; the live definition sits inside a `Block`, an older commented copy is in the same cell',
    'pixelGeometricalAcceptanceRelativeToDefault': 'association: pixel geometric-acceptance size → factor relative to the default pixel',
    'beta': 'β from γ', 'gamThr': 'γ at Cherenkov threshold for index n', 'gammaCherenkovThreshold': 'γ at Cherenkov threshold for index n',
    'momentumFromMassAndBeta': 'p = m·β·γ', 'numRelPho': 'photon yield relative to its n-dependent maximum, `sin²θ / sin²θmax`',
    'thetaChr': 'Cherenkov angle `[β, n]`', 'thisThetaChr': 'Cherenkov angle in mrad for `[γ, n:thisRefrIndex]`',
    'thisNumRelChr': 'relative photon yield for `[γ, n:thisRefrIndex]`',
    'sbnScan': 'for one particle: significance table over the γ list (`listOfGammasFor`), one row per γ from `loop`',
    'loop': 'one scan point: `doCalcSignificance[experiment, False, γ]`',
    'listOfGammasFor': 'γ list for an explicit refractive index, last entry `gammaMax`',
    'theListOfGammas': 'same γ list from the global `thisRefrIndex` (legacy form)',
    'momentumThresholdFromScan': 'momentum at which a significance column reaches a target; `Failure[…]` on bad or non-monotonic scans',
    'checkedStageResult': 'wrap one stage: abort, non-list, wrong length or non-finite values become `Failure[…]`', 'finiteRealQ': 'numeric, finite and real',
    'sigmaTotSnglPhEvolutionWithGammaRatio': 'growth of the total single-photon σ with γ relative to γ=9999 (chromatic model)',
    'sigmaTotSnglPhEvolutionWithGamma': 'total single-photon σ versus γ (needs the fitted chromatic model)',
    'chromaEvolutionWithGammaRatio': 'chromatic σ(γ)/σ(γmax) from the fitted model',
    'sumInQuadr': 'square root of the sum of squares', 'nf': 'NumberForm shortcut `[x, sp, dg, exp]`', 'dropFirst': '`Drop[x,1]`',
    'debugPrint': 'print only when the debug flag is on', 'debugPrintD': 'debug print with the held expression (`RICH.wl` copy)',
    'printD': 'HoldAll print of an expression and its value', 'showIt': 'HoldAll print of an expression and its value',
    'bigBanner': 'framed banner message', 'miniBanner': 'one-line banner message', 'bannerLine': 'repeated-character separator line',
    'exportGraphicsToPDF': 'export graphics to the project output folder (mode: Button / Immediate / Disabled)',
    'performGraphicsPDFExport': 'does the PDF export for `exportGraphicsToPDF`', 'configuredProjectDirectory': 'resolved project output/backup directory',
}
GROUPS = [
    ('Units and conversions', ['toPure', 'toMRad', 'toNanS', 'toMMet', 'toNumPixels', 'toNumPhotons', 'toCounts', 'toIntensity', 'toGeVc', 'createMRad', 'mmToMRad', 'mRadToMm']),
    ('Detector geometry and occupancy', ['pixelGeometricalAcceptanceRelativeToDefault', 'fiducialAreaOfTheRing', 'calcBinaryOccupancyFromTrueToApparent']),
    ('Cherenkov physics (`physicsGeneral.wl`, `RICH.wl`)', ['beta', 'gamThr', 'gammaCherenkovThreshold', 'momentumFromMassAndBeta', 'numRelPho', 'thetaChr', 'thisThetaChr', 'thisNumRelChr']),
    ('Significance scan and thresholds', ['sbnScan', 'loop', 'listOfGammasFor', 'theListOfGammas', 'momentumThresholdFromScan', 'sigmaTotSnglPhEvolutionWithGammaRatio', 'sigmaTotSnglPhEvolutionWithGamma', 'chromaEvolutionWithGammaRatio']),
    ('Stage checking', ['checkedStageResult', 'finiteRealQ']),
    ('General utilities (`base.wl`, `statDataAnal.wl`, `myNotebookInit.wl`, `RICH.wl`)', ['sumInQuadr', 'nf', 'dropFirst', 'debugPrint', 'debugPrintD', 'printD', 'showIt', 'bigBanner', 'miniBanner', 'bannerLine', 'exportGraphicsToPDF', 'performGraphicsPDFExport', 'configuredProjectDirectory']),
]
LIB = [
    ('myNotebookInit.wl', 'myNotebookInit`', 'bootstrap, banners, `printD`, load log, docked toolbar, `exportGraphicsToPDF`'),
    ('cellStyleDataRules.wl', '—', 'cell-style rules'),
    ('base.wl', 'base`', 'general helpers: number formatting (`nf…`), `debugPrint`, table utilities'),
    ('statDataAnal.wl', 'statDataAnal`', 'statistics helpers (`sumInQuadr`, histograms, error propagation)'),
    ('physicsGeneral.wl', 'physicsGeneral`', 'relativistic kinematics and Cherenkov relations (β, γ, θC, thresholds, `numRelPho`)'),
    ('inputDataForRICH.wl', 'inputDataForRICH`', 'sensor and optics input data (PDE and transmission curves, constants)'),
    ('RICH.wl', 'rich`', 'radiator and yield calculation (`calcRICHYield`, efficiencies, `thisThetaChr`, `allDetectorResults`)'),
    ('calculator.wl', 'calculator`', 'notebook initialization only (stops before `CALCULATOR BODY`)'),
]
INTRO = {
    'doCalcAllExperiment': ('orchestrator for one experiment tag: select the parameters → `doSetExperiment` → `doCalcExperiment` → `doCalcSignificance` → momentum scans → one result row.',
                            'appends a result row to `allExperimentResultsHeader/Data` (unless `recordResults=False`) and exports PDF and TeX; sets the `this…` globals and `currentExperiment`.'),
    'doSetExperiment': ('turns the dimension-full experiment inputs (focal length, pixel size, luminosity and time-bin factors, reference intensities, σ and photon-number inputs, PDA geometry) into the derived experiment constants; looks up `allDetectorResults[cherenkovTag]` for the radiator.',
                        'returns a 24-element list; also fills `resultsDoSetExperiment` (header `headerDoSetExperiment`).'),
    'doCalcExperiment': ('asymptotic (γ→∞) photon, background and dark-noise counts and occupancies in the pixel, ring and time gate; ring radius and area; maximum separating momenta.',
                         'returns a 20-element list; also fills `resultsDoCalcExperiment` (header `headerDoCalcExperiment`).'),
    'doCalcSignificance': ('significance of the ring at one γ: signal, ring area, background and dark counts versus momentum, and six significance definitions `sbn1…sbn6` (names in `ssbnName`).',
                           'returns a 17-element list; also fills `resultsDoCalcSignificance`. Entries 15–17 (`pMin…`) are placeholders that `doCalcAllExperiment` fills afterwards.'),
    'doAllSignificancePlots': ('significance-versus-momentum plot for π, K, p with the momentum thresholds marked for the chosen target; defaults to `pMinTargetSignificance` and the `sbn5` column.',
                               'sets `sbnScanResults`, `sbnScanResults1`, `momentumThresholdsHadrons` and `plot`; exports the plot with `exportGraphicsToPDF`.'),
}


# ------------------------------------------------------------------ facts
ncells_in = sum(1 for c in cells if c['style'] == 'Input')
mainrec = {m: pick(m) for m in MAINS}
missing_mains = [m for m in MAINS if mainrec[m] is None]
if missing_mains: sys.exit('main function(s) not found in the index: %s' % missing_mains)
D = {m: direct(m) for m in MAINS}
WRITTEN = set()      # globals that the main functions assign themselves
for m in MAINS:
    WRITTEN |= {a.rstrip('[]') for a in mainrec[m]['assigned']} - set(mainrec[m]['locals'])
R = reach(MAINS, 3, stop=MAINS, skip=WRITTEN)
unfinished = span('UNFINISHED', 'Title', prefix=True)
unfinished_first = unfinished[0] if unfinished else 10 ** 9
def live_strings(t): return [x[1][1:-1] for x in tokenize(t) if x[0] == 'str']
tag_cell = next(c for c in cells if c['style'] == 'Input' and 'experimentTags={' in c['text'].replace(' ', ''))
active_tags = live_strings(tag_cell['text'])
table_cell = next(c for c in cells if 'experimentSwitchCasesHeld=HoldComplete' in c['text'].replace(' ', ''))
table_tags = re.findall(r'"([^"]+)"\s*,\s*theExperimentParametersCase\s*=', re.sub(r'\(\*.*?\*\)', '', table_cell['text'], flags=re.S))
missing_tags = [t for t in active_tags if t not in table_tags]
loop_cell = next((c for c in cells if c['style'] == 'Input' and re.search(r'Do\[\s*doCalcAllExperiment\[', live_text(c['text']))), None)
writers = sorted({(r['name'], r['origin'], r['loc'].get('line')) for v in defs.values() for r in v if 'allDetectorResults[]' in r['assigned']})
users = {}            # name -> 'ASEGP' letters, upper case = called directly, lower case = only through other helpers
for m in MAINS:
    dc = D[m][0] | D[m][1]
    for k in reach([m], 3, stop=MAINS, skip=WRITTEN):
        if k in MAINS: continue
        users.setdefault(k, {})[TAG[m]] = k in dc
closure_written = WRITTEN
def users_str(n):
    u = users.get(n, {})
    return ''.join((c if u[c] else c.lower()) for c in 'ASEGP' if c in u) or '·'

L = []; A = L.append
A('# RICH calculator — code map')
A('')
A('> Generated %s by static analysis of `%s` and `src/*.wl`; nothing was evaluated. Names, cell numbers, signatures, result-vector layouts and the dependency tables are computed from the source; the one-line descriptions come from reading the definitions. Cell numbers are positions in the notebook\'s list of heading, text and input cells and change when the notebook is edited. How to regenerate: §8.' % (datetime.date.today().isoformat(), NBNAME))
A('')
A('**Basis.** `%s` is the Oct 26 notebook with fixes A1, A2, A3 and B1 (`docs/calculator--2026-10-26-fixes.diff`); the tracked `notebooks/calculator.nb` (Aug 24) is the version before them. It has %d input cells.' % (NBNAME, ncells_in))
A('')
A('## 1. Where the code lives')
A('')
A('`LoadProject.wl` loads the `calculator` case as a chain; each package sees the ones above it. The notebook body then adds everything below `---... CALCULATOR`.')
A('')
A('| # | File | Context | Role | Functions / values |')
A('|---|------|---------|------|-------------------:|')
for i, (f, ctx, role) in enumerate(LIB, 1):
    n = len({r['name'] for v in defs.values() for r in v if r['origin'] == f and r['kind'] in ('function', 'value')})
    A('| %d | `src/%s` | %s | %s | %d |' % (i, f, ctx if ctx == '—' else '`%s`' % ctx, role, n))
nbn = len({r['name'] for v in defs.values() for r in v if r['source'] == 'nb' and r['kind'] in ('function', 'value')})
A('| %d | notebook, `CALCULATOR BODY` | `Global`` | the calculator itself (this map) | %d |' % (len(LIB) + 1, nbn))
A('')
A('## 2. Notebook map')
A('')
A('| Block (heading) | Cells | What is there | Status |')
A('|---|---|---|---|')
sp_setup = span('---... SETUP', 'Title', any_level=True)
sp_prelim = span('SOME PRELIMINARY CALCULATIONS', 'Subtitle')
sp_basic = span('basic', 'Section'); sp_sing = span('single photon angular precision', 'Section', prefix=True)
sp_pda = span('PDA', 'Section'); sp_gen = span('general functions', 'Subsubtitle')
sp_det = span('DETECTOR FUNCTIONS', 'Subsubtitle'); sp_init = span('init', 'Section', any_level=True)
sp_new = span('NEW TO IMPLEMENT AND CHECK', 'Subsection')
sp_misc = span('miscellanea', 'Subsubtitle'); sp_end = span('END', 'Subsubtitle')
sp_misc_end = (sp_misc[0], sp_end[1]) if sp_misc and sp_end else sp_misc
A('| `---... SETUP` | %s | universal bootstrap cell (`RICHNotebookBootstrap`) and explanatory text | active |' % rng(sp_setup))
prelim_in = [c for c in cells if sp_prelim and sp_prelim[0] <= c['i'] <= sp_prelim[1] and c['style'] == 'Input']
A('| `SOME PRELIMINARY CALCULATIONS` | %s | `calcRICHYield` over the radiators (`doCalcAllRadiators2022`, `doCalcAllRadiatorsUpg2`, then the RICH1 / RICH2 / ALADDIN cells) to fill `allDetectorResults`; %d of the %d input cells are non-evaluatable | partly active |' % (rng(sp_prelim), sum(c['noeval'] for c in prelim_in), len(prelim_in)))
A('| `INPUT DATA` › basic | %s | pixel and geometry helpers, `fiducialAreaOfTheRing`, `mmToMRad`, `mRadToMm` | active |' % rng(sp_basic))
A('| `INPUT DATA` › single photon angular precision … | %s | per-detector tuned symbols `sigmaSnglPhAsymptUpg*`, `numPhoUpg*`, `sigmaChrRngAsymptUpg*`, protected afterwards through `theTunedDetectorSymbols` | active |' % rng(sp_sing))
A('| `INPUT DATA` › PDA | %s | reference values (`…Ref`, protected), refractive indices, time bins, γ list (`gammaMax`, `numSteps`, `gammaVal`) | active |' % rng(sp_pda))
A('| `INPUT DATA` › general functions | %s | unit helpers (`toPure`, `toMRad`, …), binary-occupancy functions, Poisson and significance checks | active |' % rng(sp_gen))
A('| `detector design` › DETECTOR FUNCTIONS | %s | **`doSetExperiment`**, **`doCalcExperiment`**, **`doCalcSignificance`**, `sbnScan`, `loop`, `listOfGammasFor`, **`doAllSignificancePlots`** | active |' % rng(sp_det))
A('| `CALC ALL EXPERIMENTS` › init | %s | output-table helpers (`cleanHeadForOutput`, `showSelectedOutputEntries…`, `whichExperiment…`) | active |' % rng(sp_init))
A('| `CALC ALL EXPERIMENTS` › NEW TO IMPLEMENT AND CHECK | %s | **`experimentSwitchCasesHeld`** (one parameter list per experiment tag), **`doCalcAllExperiment`**, `checkedStageResult`, `momentumThresholdFromScan`, `experimentTags`, the driver loop, summary tables; the keyed-configuration refactor (`doSetExperimentNamed`, `allExpData`, `validateDoSetExperimentConfig`) is present but non-evaluatable | active, refactor in progress |' % rng(sp_new))
A('| `miscellanea`, `END` | %s | fixed-momentum difference tables and small utilities | active |' % rng(sp_misc_end))
A('| `UNFINISHED - WORK IN PROGRESS` | %s | CalAliMon, ray tracing, error analysis, **CHROMATICA** (defines the chromatic σ model that `doCalcSignificance` uses), 2D pixels, dark counts, group velocity, RICH resolution, dispersion studies | exploratory, but see §6 |' % rng(unfinished))
A('')
A('## 3. Runtime pipeline')
A('')
A('```mermaid')
A('flowchart TD')
A('  T["experimentTags (cell %d): %d active tags"] --> DO["driver loop%s"]' % (tag_cell['i'], len(active_tags), ' (cell %d)' % loop_cell['i'] if loop_cell else ''))
A('  DO --> ALL["doCalcAllExperiment[tag]"]')
A('  SW["experimentSwitchCasesHeld (cell %d)<br/>%d tags × 21 parameters"] -->|"Switch via args"| ALL' % (table_cell['i'], len(table_tags)))
A('  ALL --> S["doSetExperiment → 24 values"]')
A('  RICHW["allDetectorResults[cherenkovTag]<br/>filled by calcRICHYield"] --> S')
A('  S --> CTX["currentExperiment (Association)"]')
A('  CTX --> E["doCalcExperiment → 20 values"]')
A('  E --> CTX')
A('  CTX --> G["doCalcSignificance at gammaMax → 17 values"]')
A('  CTX --> SC["sbnScan for 5 particles<br/>loop → doCalcSignificance per γ"]')
A('  SC --> M["momentumThresholdFromScan<br/>Pion, Kaon, Proton at pMinTargetSignificance"]')
A('  G --> ROW["result row"]')
A('  M --> ROW')
A('  ROW --> OUT["allExperimentResultsHeader / Data<br/>and PDF / TeX export"]')
A('  PL["doAllSignificancePlots[tag]"] -->|"recordResults=False"| ALL')
A('  PL --> SC')
A('```')
A('')
A('`doCalcAllExperiment` is the entry point and must be run first for an experiment: it creates the `currentExperiment` context that the other functions take (fix B1) and sets the legacy `this…` globals. `doAllSignificancePlots` re-runs it with `recordResults=False`, then scans and plots.')
A('')
A('Active experiment tags (cell %d): %s.' % (tag_cell['i'], ', '.join('`%s`' % t for t in active_tags)))
if missing_tags: A('Tags in `experimentTags` without a case in the table: %s.' % ', '.join('`%s`' % t for t in missing_tags))
else: A('Every active tag has a case in the table, which holds %d tags.' % len(table_tags))
A('')
A('## 4. The five main functions')
A('')
for m in MAINS:
    r = mainrec[m]
    A('### `%s`' % m)
    A('')
    A('%s — %s' % (where(r), INTRO[m][0]))
    A('')
    A('```wl')
    A('%s[' % m)
    A(',\n'.join('  ' + a for a in signature(m)))
    A(']')
    A('```')
    A('')
    A('**Output.** ' + INTRO[m][1])
    A('')
    rv = returns(m)
    if rv:
        A('**Result vector** (`doCalcAllExperiment` reads these by position)')
        A('')
        if len(rv) > 12:
            half = (len(rv) + 1) // 2
            A('| # | value | # | value |'); A('|--:|---|--:|---|')
            for i in range(half):
                j = i + half
                right = '| %d | `%s` ' % (j + 1, esc(rv[j])) if j < len(rv) else '| | '
                A('| %d | `%s` %s|' % (i + 1, esc(rv[i]), right))
        else:
            A('| # | value |'); A('|--:|---|')
            for i, x in enumerate(rv, 1): A('| %d | `%s` |' % (i, esc(x)))
        A('')
    calls, vals = D[m]
    A('**Helpers called** — ' + (', '.join('`%s`' % pretty(c) for c in sorted(calls)) or '—'))
    A('')
    if vals:
        A('**Global values read** — ' + ', '.join('`%s`' % pretty(v) for v in sorted(vals)))
        A('')
    writes = sorted(a for a in set(r['assigned']) if a.rstrip('[]') not in set(r['locals']))
    if writes:
        A('**Globals written** — ' + ', '.join('`%s`' % pretty(w).replace('[]', '[…]') for w in writes))
        A('')
A('## 5. Helper index')
A('')
A('Helpers reached from the main functions (call depth up to three, not following calls into the other main functions). Used by: A = `doCalcAllExperiment`, S = `doSetExperiment`, E = `doCalcExperiment`, G = `doCalcSignificance`, P = `doAllSignificancePlots`; a capital letter means the main function calls the helper directly, a lower-case letter that it reaches it only through other helpers.')
A('')
shown = set()
for title, names in GROUPS:
    rows = []
    for n in names:
        if n not in defs: continue
        recs = [r for r in defs[n] if r['kind'] in ('function', 'value') and not r.get('nested')] or [r for r in defs[n] if r['kind'] in ('function', 'value')]
        if not recs: continue
        shown.add(n)
        pri = [r for r in recs if r['source'] == 'lib'] or recs
        loc = where(pri[0], short=True)
        others = [r for r in recs if r is not pri[0]]
        nbo = [r for r in others if r['source'] == 'nb']; lio = [r for r in others if r['source'] == 'lib']
        if nbo and pri[0]['source'] == 'lib': loc += '; also defined in %d notebook cell%s' % (len({r['loc']['cell'] for r in nbo}), '' if len({r['loc']['cell'] for r in nbo}) == 1 else 's')
        elif nbo: loc += ' (+%d more)' % len(nbo)
        if lio: loc += '; also in %s' % ', '.join(sorted({where(r) for r in lio}))
        rows.append('| `%s` | %s | %s | %s |' % (n, users_str(n), loc, esc(DESC.get(n, ''))))
    if rows:
        A('**%s**' % title); A('')
        A('| Helper | Used by | Defined in | What it does |'); A('|---|---|---|---|'); L.extend(rows); A('')
undescribed = sorted({c for m in MAINS for c in D[m][0]} - shown - set(MAINS))
if undescribed: A('Other direct helpers: ' + ', '.join('`%s`' % u for u in undescribed) + '.'); A('')

A('## 6. Shared state and out-of-place dependencies')
A('')
A('From the dependency scan, not from running the notebook.')
A('')
A('**Reached from the main functions but defined only in the `UNFINISHED` part** (names the main functions assign themselves are left out)')
A('')
rows = []
for n in sorted(R):
    if len(n) < 3 or n.startswith('\\[') or n in closure_written: continue
    s = nbsites(n)
    if s and all(x['loc']['cell'] >= unfinished_first for x in s) and not any(x['source'] == 'lib' for x in defs[n]):
        rows.append('| `%s` | %s | %s |' % (n, ', '.join(str(c) for c in sorted({x['loc']['cell'] for x in s})[:4]), ' › '.join(s[0]['loc']['path'][-3:-1])))
A('| Name | Cell | Section |'); A('|---|---|---|'); L.extend(rows[:12] if rows else ['| — | | |']); A('')
A('**Shared parameters defined in more than one cell** (a later evaluation replaces the earlier value)')
A('')
A('| Name | Definitions |'); A('|---|---|')
multi = []
for n in ['gammaMax', 'numSteps', 'thisRefrIndex', 'mmToMRad']:
    s = nbsites(n)
    if len({x['loc']['cell'] for x in s}) < 2: continue
    multi.append(n)
    parts = []
    for x in sorted(s, key=lambda x: x['loc']['cell']):
        txt = re.sub(r'\s+', ' ', re.sub(r'\(\*.*?\*\)', '', x['text'], flags=re.S)).strip()
        parts.append('cell %d `%s`' % (x['loc']['cell'], esc(txt if len(txt) <= 46 else txt[:43] + '…')))
    A('| `%s` | %s |' % (n, '; '.join(parts)))
A('')
prot = [n for n in ['beta', 'thetaChr', 'momentumFromMassAndBeta'] if nbsites(n) and any(r['source'] == 'lib' for r in defs[n])]
if prot:
    A('**Package symbols that notebook cells also define** (`physicsGeneral.wl` protects them)')
    A('')
    for n in prot: A('- `%s`: cells %s' % (n, ', '.join(map(str, sorted({x['loc']['cell'] for x in nbsites(n)})))))
    A('')
glob = [a for a in sorted(set(mainrec['doCalcAllExperiment']['assigned'])) if a.startswith('this')]
A('**Legacy `this…` globals set by `doCalcAllExperiment`** (kept for interactive cells; the pipeline passes `currentExperiment`): ' + ', '.join('`%s`' % g for g in glob) + '.')
A('')
if writers:
    A('**Where `allDetectorResults[tag]` is filled** (read by `doSetExperiment`): ' + ', '.join('`%s` (%s:%s)' % w for w in writers) + '.')
    A('')

A('## 7. Observations from the static pass')
A('')
A('Not run and not fixed: candidates to check, most useful first.')
A('')
obs = []
for n in prot:
    unprot = [c['i'] for c in cells if c['style'] == 'Input' and re.search(r'Unprotect\[[^\]]*\b%s\b' % n, live_text(c['text']))]
    assign = sorted({x['loc']['cell'] for x in nbsites(n)})
    if unprot and n == 'beta':
        obs.append('**`beta` is overwritten by an exploratory cell.** Cell %s runs `Unprotect[beta]` and assigns a number to `beta` (assignments in cells %s). Once that cell is evaluated, `beta[γ]` no longer evaluates as the function of `physicsGeneral.wl` (a value on the symbol replaces the head), so `thisThetaChr`, `thisNumRelChr` and therefore `doCalcSignificance`, `sbnScan` and `doAllSignificancePlots` give wrong results until `beta =.` is run or the kernel is restarted and the packages are reloaded.' % (', '.join(map(str, unprot)), ', '.join(map(str, assign))))
guard = next((c for c in cells if c['style'] == 'Input' and 'ValueQ[sigmaTotSnglPhEvolutionWithGammaRatio' in live_text(c['text']).replace(' ', '')), None)
real = [x['loc']['cell'] for x in nbsites('sigmaTotSnglPhEvolutionWithGamma')]
if guard and real:
    obs.append('**Order-dependent significance.** `doCalcSignificance` uses `sigmaTotSnglPhEvolutionWithGammaRatio`, which is defined with the chromatic model in the CHROMATICA part (cell %s). Cell %d sets the ratio to 1 (γ→∞ only) and prints a warning when it is undefined, so the results depend on whether the CHROMATICA cell was evaluated first.' % (', '.join(map(str, real)), guard['i']))
if multi:
    obs.append('**Parameters redefined by other cells.** ' + '; '.join('`%s` in cells %s' % (n, ', '.join(map(str, sorted({x['loc']['cell'] for x in nbsites(n)})))) for n in multi) + '. Evaluating the later ones changes the γ list, the default scan point or the conversion functions used by the main code (`mmToMRad` is a function in one cell and a value in another).')
if re.search(r'C:\\\\TEMP', mainrec['doCalcAllExperiment']['text']):
    obs.append('**Hard-coded export path.** `doCalcAllExperiment` writes `C:\\TEMP\\res-<tag>-<timestamp>.pdf` and `.tex` when `recordResults` is true; the README describes `RICHOutputPath[…]` for portable paths.')
if 'resPara[[' in mainrec['doCalcAllExperiment']['text']:
    obs.append('**Positional coupling.** `doCalcAllExperiment` reads `resPara`, `resCalc` and `resSign` by index; `checkedStageResult` verifies only the lengths (24, 20, 17), not what each position means. `thisEff := resPara[[21]]` is the `cherenkovTag` string, and `thisEff` is not read anywhere else.')
noev = [c['i'] for c in cells if c['style'] == 'Input' and c['noeval'] and sp_new and sp_new[0] <= c['i'] <= sp_new[1]]
if noev:
    obs.append('**Refactor not yet active.** The keyed configuration (`doSetExperimentNamed`, `validateDoSetExperimentConfig`, `allExpData`; %d cells) is non-evaluatable. The production path still uses the positional 21-parameter lists of `experimentSwitchCasesHeld` (%d characters of source).' % (len(noev), len(table_cell['text'])))
others = [n for n in prot if n != 'beta']
if others:
    obs.append('**Other protected package symbols.** Notebook cells also define ' + ', '.join('`%s` (cell%s %s)' % (n, '' if len({x['loc']['cell'] for x in nbsites(n)}) == 1 else 's', ', '.join(map(str, sorted({x['loc']['cell'] for x in nbsites(n)})))) for n in others) + '. While `physicsGeneral.wl` protects these symbols the definitions are rejected; they would replace the functions used by the main code only after an `Unprotect`.')
for i, o in enumerate(obs, 1): A('%d. %s' % (i, o))
A('')
A('## 8. Regenerate')
A('')
A('```')
A('python3 tools/calculator-map/nbextract.py notebooks/<notebook>.nb  work/cells.json')
A('python3 tools/calculator-map/build_index.py . work/cells.json work/defs.json')
A('python3 tools/calculator-map/build_map.py   . work/cells.json work/defs.json docs/CALCULATOR_MAP.md <notebook>.nb')
A('```')
A('')
A('Limits: the parser is a lightweight tokenizer, not the Wolfram parser. Definitions created by `Set` inside loops or `ToExpression`, and names built at run time, are not seen, so search for a name reported as missing before trusting it.')
open(OUT, 'w', encoding='utf-8').write('\n'.join(L) + '\n')
print('written', OUT, len(L), 'lines')
