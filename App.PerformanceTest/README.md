# MBS Certification Session Management Performance Test

> BCPT companion app for measuring certification workflow throughput, latency, and stability under load.

| Area | Details |
|---|---|
| App name | `MBS Certification Session Management Performance Test` |
| Publisher | `MBS` |
| Primary app role | Performance and regression benchmarking |
| Object range | `50200..50299` |
| Depends on | Main app + Microsoft Performance Toolkit |

## Purpose

This app helps teams understand how the certification solution behaves when data volume and concurrency increase.

It combines:

- **certification-specific BCPT scenarios** for realistic business flows
- **toolkit support scenarios** under the `.BCPT` folder
- a ready-made `bcptSuite.json` for quick execution of selected benchmark paths

## What it measures

### Certification scenarios

| Scenario | What it stresses |
|---|---|
| Create Certification | master-data creation cost |
| Create Cert. Bulk | high-volume master creation |
| Create Session | session creation with candidate lines |
| Create Session Bulk | repeated document creation |
| Capture Results | line updates and result distribution |
| Post Session | full posting path |
| Post Session Bulk | repeated posting throughput |
| Candidate History Query | ledger lookup efficiency |
| Post Session Validation | failure-path overhead |
| Session Contention | shared-resource contention |

## Quick start

1. Publish the main app.
2. Make sure the Microsoft **Performance Toolkit** dependency is available.
3. Publish this app.
4. Open your BCPT tooling in Business Central.
5. Import or use `bcptSuite.json` for an immediate starter suite.
6. Run the suite and compare results across builds or branches.

## Detailed usage

### 1. Publish in the right order

```text
1. App
2. Performance Toolkit dependency
3. App.PerformanceTest
```

### 2. Choose how to run

You have two common approaches:

- **Quick benchmark path** – use the included `bcptSuite.json`
- **Targeted analysis** – run individual certification codeunits directly through BCPT configuration

### 3. Start with the included suite

The included suite (`CertPerf`) runs every certification scenario and is useful for smoke-level performance checks.

### 4. Expand to certification-specific scenarios

For realistic app-level validation, run the certification-specific codeunits and observe:

- session creation times
- posting times
- ledger growth behavior
- result distribution updates
- contention when shared resources are reused

## Recommended benchmark journey

### Fast pass

- run `Create Certification`
- run `Create Session`
- run `Post Session`
- run `Candidate History Query`

### Release-readiness pass

- run `Create Cert. Bulk`
- run `Create Session Bulk`
- run `Post Session Bulk`
- run `Session Contention`
- compare with prior build baselines

## Reading the results

Use BCPT output to compare:

- average duration
- total duration
- variation across runs
- degradation after code changes

Look for trends rather than isolated single-run numbers.

## Good use cases

- validating a posting refactor
- checking that added validations do not slow bulk posting too much
- spotting regressions after platform upgrades
- comparing branches before and after optimization work

## Practical notes

- Certification-specific scenarios are designed to exercise the app’s real business flow, not just synthetic operations.
- The `.BCPT` helper objects are part of the benchmark toolbox and support broader toolkit-driven runs.
- Duplicate `- Copy` source files were intentionally removed so the app remains clean and buildable.

## Folder guide

| Folder | Purpose |
|---|---|
| `src/Library` | shared performance helpers |
| `src/Certification` | certification creation scenarios |
| `src/Session` | session creation scenarios |
| `src/Results` | result-capture scenarios |
| `src/Posting` | posting benchmarks |
| `src/Analytics` | query and lookup scenarios |
| `src/Contention` | shared-resource contention scenarios |

## Suggested comparison model

```text
Baseline run
  -> Change implementation
  -> Run focused scenarios
  -> Run bulk scenarios
  -> Compare trends
  -> Decide whether optimization is needed
```
