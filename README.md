# Sejong 5G SLS mini project

This repository turns the supplied MATLAB draft into small, reviewable modules for the Sejong campus study. The supplied draft is kept unchanged under `legacy/` as a reference; it still contains Soonchunhyang campus geometry and must not be treated as a Sejong result.

## Start here

1. Read `docs/MATLAB_MODULE_MAP.md` for the simulation flow and each file's responsibility.
2. Agree on the coordinate origin and units (meters), then fill the campus and base-station data in `src/data/campusData.m`.
3. Run `src/main.m` from MATLAB after the campus data and link evaluation have been completed.

The starter modules make the shared interfaces explicit. The campus data is intentionally left blank, and `evaluateCampus.m` stops with a clear message until the team agrees on LOS/NLOS and O2I handling. They do not claim a validated Sejong result while the Sejong geometry, surveyed base stations, and propagation inputs are still missing.

## Required comparisons

- Frequency: 3.5 GHz / 100 MHz against 28 GHz / 100 MHz.
- Bandwidth: 3.5 GHz / 100 MHz against 28 GHz / 800 MHz.
- New sites: retain existing sites, add two candidates, and compare before/after using the same map, power, antenna, and random inputs.

Report SINR maps and throughput CDFs, including the median and 5th percentile. Keep units and assumptions visible in the figures.

## Team workflow

Use one short-lived branch per change (`data/…`, `model/…`, `experiment/…`, `plot/…`), open a pull request to `main`, and have another teammate review it. Keep shared assumptions in `projectConfig.m`; do not copy parameter values into individual modules. See `CONTRIBUTING.md`.

## MATLAB

Open this folder in MATLAB and run `src/main.m`. The numerical functions use MATLAB base functionality; no Communications Toolbox function is required by the starter modules.
