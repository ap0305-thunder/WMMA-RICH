# WolframMMAProjectRICH – to-do list

Last updated: 2026-11-08

## Open

| # | Item | Where | Priority |
|---|------|-------|----------|
| 1 | `resonate=True` for the non-split optics template: unify the strategy. The generic component/surface numbering of the template covers `resonate=False`; the `resonate==True` branch of each non-split optics-def file is still the file-specific block, marked `TO DO (later)`. | `src/optics-def-LHCb22Upg1-rich1.wl`, `-rich2.wl`, `src/optics-def-LHCb35Upg2FTDR-rich2.wl` | normal |
| 2 | FTDR RICH1 optics definition is still a stub (template header only, no components): write it on the non-split template. Until then a run with FTDR + RICH1 stops at OPTICS (the run panel shows a warning). | `src/optics-def-LHCb35Upg2FTDR-rich1.wl` | normal |
| 3 | `ModelRefractiveIndex::WaveLength` warnings. | `notebooks/optics.nb` > OPTICS ANALYSIS > RAY-TRACING > ANALYZESYSTEM | low |
| 4 | The Eli versions of the split optics are offered by the notebook but their files are not in `src/`: `optics-def-LHCb35Upg2Split-rich1_E-v3-11-9.wl`, `optics-def-LHCb35Upg2Split-rich2_E-v8-09-1.wl` (a run with them stops at OPTICS). Add the files or drop the option. | `notebooks/optics.nb` > SYSTEM DEFINITION > OPTICS > SPLIT optics | low |
| 5 | Non-split template uses the Optica tilt convention (primary/secondary tilts differ by 180° from the old values): tilt values printed or exported by the notebook are in the new convention, check them before comparing with older outputs. | `notebooks/optics.nb` exports (opticalSystemDefVars, optics-geometry) | low |
| 6 | Other `.wl` files still have mixed line endings (calculator.wl, myNotebookInit.wl, geometricalOptics.wl, inputDataForRICH.wl, statDataAnal.wl, cellStyleDataRules.wl, LoadProject.wl, validation/ValidationConfig.wl): convert to CRLF as done for the optics-def files. | `src/`, `validation/` | low |

## Design decisions (not to-do)

- `butterfly` exists only for the Split RICH1 optics; there will be no butterfly for RICH2.
- LHCb22Upg1 (RICH1, RICH2) is frozen: geometry written as explicit numbers on the non-split template.

## Done

- 2026-11-08 – optics.nb: RUN CONTROL PANEL (Title at the top of the notebook): choose RICH / optics / version / source / sensor / options and Run the chapters OPTICAL SYSTEM DESIGN and OPTICS ANALYSIS.
- 2026-11-08 – optics.nb: the `line` source works for the non-split optics (placed in front of the single photodetector plane).
