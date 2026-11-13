# MBS Certification Session Management Dataset

> Demo and workshop data companion for Certification Session Management, built around the Contoso demo data pattern.

| Area | Details |
|---|---|
| App name | `MBS Certification Session Management Dataset` |
| Publisher | `MBS` |
| Primary app role | Demo / workshop / seed data generation |
| Object range | `50300..50399` |
| Depends on | Main app + Microsoft Contoso demo data framework |

## Purpose

This app makes the certification solution immediately useful in sandbox, demo, training, and performance-test environments.

It creates realistic sample content across four layers:

- **setup data**
- **master data**
- **transactional open data**
- **historical posted data**

## What gets created

### Setup layer

- certification number series
- session number series
- posted session number series
- an empty `Source Code Setup` record when none exists (the install codeunit of the main app fills in the certification source code)

### Master layer

- certifications
- invigilators
- rooms
- candidates

### Transactional layer

- a planned future session
- an open session with partial result capture
- a closed session ready to post

### Historical layer

- posted sessions with mixed outcomes
- candidate retake storylines
- ledger history that can be used for demos and analytics

## Quick start

1. Publish the main app.
2. Make sure the Microsoft Contoso demo data dependency is available.
3. Publish this dataset app.
4. Run the Contoso-style demo data flow that includes the certification module.
5. Open the certification pages and verify seeded data.

## Detailed usage

### 1. Publish in the right order

```text
1. App
2. Contoso demo data dependency
3. App.Dataset
```

### 2. Run the module through the Contoso framework

The app registers itself as a demo data module and is designed to be invoked through the Contoso demo data framework.

### 3. Understand the data layers

#### Setup data

Creates the certification setup record and numbering so the app is immediately operational.

#### Master data

Creates a meaningful starter catalog of certifications, invigilators, rooms, and candidates.

#### Transactional data

Creates open working documents that are useful during demos:

- one future planning scenario
- one session actively capturing outcomes
- one session ready for posting walkthroughs

#### Historical data

Creates posted history so users can immediately demonstrate:

- posted session review
- ledger analysis
- retake tracking over time

## Sample storyline highlights

### Planning and operations

- future certification session ready for scheduling review
- open session with mixed in-progress outcomes
- closed session ready for posting demo

### Historical storytelling

- mixed pass/fail outcomes across past sessions
- retake scenario where a candidate fails and later passes
- absent-then-pass scenario for audit and follow-up demonstrations

## Best use cases

Use this app when you need to:

- demonstrate the certification process quickly
- seed a sandbox with realistic records
- support workshops or internal training
- prepare performance or exploratory testing with meaningful data

## Practical notes

- Setup and master layers are re-run safe. Transactional and historical layers skip themselves when sessions or posted history already exist, so a re-run after partial changes will not top them up.
- Historical data is especially useful when demonstrating ledger entries and retake history.
- This app is a strong companion for both the main app and the performance app.

## Folder guide

| Folder | Purpose |
|---|---|
| `src/Module` | Contoso module registration and orchestration |
| `src/Setup` | setup and master-data helpers |
| `src/Transactional` | open operational session generation |
| `src/Historical` | posted history and retake scenarios |

## Suggested verification path

```text
Run dataset generation
  -> Open Certification List
  -> Review Session List
  -> Review Posted Session List
  -> Open Cert. Ledger Entries
  -> Validate retake history and seeded data quality
```
