# MATLAB module map

## One-line flow

`main.m` → shared settings → campus data → user grid → link powers → SINR → rate/statistics → figures.

## Files and hand-off data

| File | Responsibility | Input | Output |
|---|---|---|---|
| `src/main.m` | Calls modules in order | none | experiment results |
| `src/config/projectConfig.m` | One source of truth for the experiment | none | `cfg` struct |
| `src/data/campusData.m` | Holds surveyed campus geometry and site coordinates | none | `campus` struct |
| `src/geometry/buildUserGrid.m` | Creates unique evaluation points in meters | `campus.evalRegions`, `cfg.gridSpacingM` | N-by-2 `[x y]` points |
| `src/model/calcNoisePower.m` | Thermal noise over the full bandwidth | bandwidth in Hz, NF in dB | noise in dBm |
| `src/model/calcPathlossUMa.m` | UMa LOS/NLOS path loss | 3D distance in m, frequency in GHz, heights in m, LOS flag | path loss in dB |
| `src/model/calcSinr.m` | Selects strongest serving sector and sums other-sector interference | service and external powers in dBm, noise in dBm | SINR linear and dB |
| `src/metrics/calcRate.m` | Shannon-rate estimate | bandwidth in Hz, SINR linear | rate in bit/s |
| `src/metrics/summarizeResults.m` | Mean, median, 5th percentile, and sorted CDF samples | rate vector in bit/s | summary struct |
| `src/plots/plotResults.m` | SINR map and throughput CDF | locations, SINR dB, summary, campus | figures |

All radio powers passed between modules are in **dBm**. Convert to linear power before adding signals; convert the ratio back to dB only for display. Distances are meters, frequency is GHz for the UMa equations, bandwidth is Hz, and throughput is bit/s.

## Minimal concepts every teammate should be able to explain

1. Path loss reduces received power: `Prx_dBm = Ptx_dBm + antennaGain_dB - pathloss_dB - indoorLoss_dB`.
2. SINR is `S / (I + N)` in linear power. dBm values cannot be directly added.
3. Thermal noise is `-174 + 10*log10(BW_Hz) + NF_dB` dBm.
4. Rate is `BW_Hz * log2(1 + SINR_linear)` bit/s. It is a model estimate, not measured user throughput.
5. Controlled experiments change the stated variable only. Median describes the middle user; the 5th percentile highlights weak locations.

## Migration notes from the supplied draft

- `Campus_original.m` is preserved under `legacy/`; it is a reference, not the active simulation.
- Its campus coordinate/building loops describe the old campus and should be replaced with surveyed Sejong data.
- Its 4 GHz / 5 MHz constants do not represent the required experiment matrix.
- Its noise expression `-174*1000` is dimensionally wrong. Use `calcNoisePower`.
- Do not reuse old reported values as Sejong results.

## Campus data needed before producing results

Complete `src/data/campusData.m` with a shared meter-based coordinate system, evaluation rectangles, building geometry, candidate service sites, and surrounding same-band interferers. Add source and collection date to the data notes. Mark each building/user point as indoor or outdoor and define how LOS/NLOS is assigned. Until then, the framework must stop before reporting results rather than silently substituting old coordinates.
