# Collaboration guide

## Four-person split

1. **Campus data:** coordinate origin, evaluation regions, building rectangles, existing and nearby sites, and source/date notes.
2. **Propagation:** path loss, LOS/NLOS assignment, indoor loss assumptions, and sector orientation.
3. **Metrics and experiments:** SINR, rate, controlled scenario matrix, median and 5th-percentile comparisons.
4. **Integration and presentation:** keep `main.m` runnable, review pull requests, generate maps/CDFs, and prepare the explanation.

Agree on function inputs/outputs before parallel edits. The shared data schema is described in `docs/MATLAB_MODULE_MAP.md`.

## Branch and pull-request rules

- Start from an updated `main` branch.
- Name branches `data/<topic>`, `model/<topic>`, `experiment/<topic>`, or `plot/<topic>`.
- Keep a pull request focused on one module or one experiment.
- Include the assumptions changed, units, and a screenshot or output summary when changing results.
- Ask one teammate to review before merging. Do not commit generated figures or temporary MATLAB files.

## Commit messages

Use a short verb phrase, for example `Add Sejong building coordinates` or `Fix thermal noise calculation`.
