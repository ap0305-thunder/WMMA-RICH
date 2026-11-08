# WolframMMAProjectRICH – to-do list

Last updated: 2026-11-08 (16:00)

## Open

| # | Item | Where | Priority |
|---|------|-------|----------|
| 1 | `resonate=True` for the non-split optics template: unify the strategy. The generic component/surface numbering of the template covers `resonate=False`; the `resonate==True` branch of each non-split optics-def file is still the file-specific block, marked `TO DO (later)`. | `src/optics-def-LHCb22Upg1-rich1.wl`, `-rich2.wl`, `src/optics-def-LHCb35Upg2FTDR-rich2.wl` | normal |
| 2 | FTDR RICH1 optics definition is still a stub (template header only, no components): write it on the non-split template. Until then a run with FTDR + RICH1 stops at OPTICS (the run panel shows a warning). | `src/optics-def-LHCb35Upg2FTDR-rich1.wl` | normal |
| 3 | `ModelRefractiveIndex::WaveLength` warnings. | `notebooks/optics.nb` > OPTICS ANALYSIS > RAY-TRACING > ANALYZESYSTEM | low |
| 4 | The Eli versions of the split optics are offered by the notebook but their files are not in `src/`: `optics-def-LHCb35Upg2Split-rich1_E-v3-11-9.wl`, `optics-def-LHCb35Upg2Split-rich2_E-v8-09-1.wl` (a run with them stops at OPTICS). Add the files or drop the option. | `notebooks/optics.nb` > SYSTEM DEFINITION > OPTICS > SPLIT optics | low |
| 5 | Non-split template uses the Optica tilt convention (primary/secondary tilts differ by 180° from the old values): tilt values printed or exported by the notebook are in the new convention, check them before comparing with older outputs. | `notebooks/optics.nb` exports (opticalSystemDefVars, optics-geometry) | low |
| 6 | Other `.wl` files still have mixed line endings (calculator.wl, myNotebookInit.wl, geometricalOptics.wl, inputDataForRICH.wl, statDataAnal.wl, cellStyleDataRules.wl, LoadProject.wl, validation/ValidationConfig.wl): convert to CRLF as done for the optics-def files. | `src/`, `validation/` | low |
| 7 | `opticalSystemDefVars-<tag>--<date>.txt` lists about 15 entries of the split optics that the non-split template does not define (they print their own name). Kept as is for now. | `notebooks/optics.nb` > SYSTEM DEFINITION > INIT > full dataset | low |
| 8 | Run panel: increase the contrast between selected and non-selected buttons (SetterBar choices, check boxes). | `notebooks/optics.nb` > RUN CONTROL PANEL (also the Float palette) | low |
| 9 | Run panel title: "RICH optics run control" (now "RICH run control"; also the palette window title). | `notebooks/optics.nb` > RUN CONTROL PANEL | low |
| 10 | ARC barrel: in `ARCBarrel.wl` the aerogel and cooling plates are offset from the sensor along the radial axis of the cell but oriented like the tilted sensor, so the 262 µm safe distance holds only for untilted sensors (cells ±17: aerogel overlaps the sensor by 0.24 mm). Check `ARC_barrel_geo.cpp`: if the offsets are in the sensor frame, fix `makeCell` (`ac`, `cc`). See arc.nb Test 4. | `notebooks/ARCBarrel.wl` | normal |

## Design decisions (not to-do)

- `butterfly` exists only for the Split RICH1 optics; there will be no butterfly for RICH2.
- LHCb22Upg1 (RICH1, RICH2) is frozen: geometry written as explicit numbers on the non-split template.

## Done

- 2026-11-08 – optics.nb: RUN CONTROL PANEL (Title at the top of the notebook): choose RICH / optics / version / source / sensor / options and Run the chapters OPTICAL SYSTEM DESIGN and OPTICS ANALYSIS.
- 2026-11-08 – optics.nb: the `line` source works for the non-split optics (placed in front of the single photodetector plane).
- 2026-11-08 – optics.nb: Float button (run panel as a floating palette bound to the notebook); Export drawing and Export summary buttons.
- 2026-11-08 – optics.nb: detailed side view exported as `optics-geometry--<tagString>--<date>.pdf`; "Export optics geometry" report extended to the non-split optics (quartz plate included).
- 2026-11-08 – optics.nb: `run-summary--<tagString>--<date>.txt` at the end of every run (run options, optics file, geometry, radiator/Cherenkov/sensor, source, results); `opticalSystemDefVars-a-<tag>.txt` no longer written.
- 2026-11-08 – myNotebookInit.wl: `timeStamp` in the format `--yyyy-mm-dd--HHMMSS` (was `-DYYMMDDTHHMMSS`).
- 2026-11-08 – ARC barrel (`notebooks/arc.nb`, `ARCBarrelOptica.wl`): adapter switched to OpticaEM and Rotate convention fixed (OpticaEM applies the transpose of the rotation matrix); cell 1 trace checked: 36/36 photons on the sensor, ring radius 8.82 mm, as in an independent geometric calculation.
