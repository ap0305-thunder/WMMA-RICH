# calculator-map

Static analysis of the calculator notebook and the `src/*.wl` packages (no Wolfram kernel needed).
It writes `docs/CALCULATOR_MAP.md`: load chain, notebook outline, pipeline, the five main functions with
signatures and result vectors, helper index, shared state and observations.

```
python3 tools/calculator-map/nbextract.py notebooks/calculator--2026-10-26-fixes.nb work/cells.json
python3 tools/calculator-map/build_index.py . work/cells.json work/defs.json
python3 tools/calculator-map/build_map.py   . work/cells.json work/defs.json docs/CALCULATOR_MAP.md calculator--2026-10-26-fixes.nb
```

`nbextract.py` renders Input/Text/heading cells of a `.nb` as text; `wlparse.py` is a light tokenizer
(comments, strings, statements, definitions); `build_index.py` indexes definitions in the notebook and in the
load chain; `build_map.py` writes the Markdown. The Markdown's descriptions of the helpers are kept in the
`DESC` dictionary of `build_map.py`.
