# MBS Certification Session Management Test

> Automated validation suite for the Certification Session Management app.

| Area | Details |
|---|---|
| App name | `MBS Certification Session Management Test` |
| Publisher | `MBS` |
| Primary app role | Automated tests |
| Object range | `50100..50199` |
| Depends on | Main app + Microsoft test libraries |

## Purpose

This app verifies that the business process behaves correctly from setup through posting and audit review.

It is meant for developers, QA engineers, build pipelines, and reviewers who want confidence that changes have not broken the certification workflow.

## Coverage at a glance

### Test areas

- **Setup** – number series and initialization
- **Certification master** – blocked certification handling and default propagation
- **Session documents** – required fields and posting prerequisites
- **Results** – pass/fail and attempt preservation
- **Posting** – posted header, posted lines, comments, and source cleanup
- **Ledger** – candidate history and chronology
- **Permissions** – basic access-sensitive behavior

### Main test codeunits

| Codeunit | Area |
|---|---|
| `MBS Library - Cert. Session` | shared helper library |
| `MBS Cert. Setup Tests` | setup validation |
| `MBS Cert. Master Tests` | certification master behavior |
| `MBS Cert. Session Tests` | session preconditions |
| `MBS Cert. Result Tests` | result persistence |
| `MBS Cert. Posting Tests` | end-to-end posting |
| `MBS Cert. Ledger Tests` | history and retakes |
| `MBS Cert. Register Tests` | register, source code and posting metadata |
| `MBS Cert. Permission Tests` | access-related checks |

## Quick start

1. Publish the main app.
2. Make sure Microsoft test libraries are available in the environment.
3. Publish this test app.
4. Run the test suite from your Business Central test runner setup.
5. Review failures by area and rerun targeted codeunits when needed.

## Detailed setup

### Dependencies you need available

This app expects the standard Microsoft test packages to be available, including libraries such as:

- `Library Assert`
- `Any`
- `System Application Test Library`
- `Tests-TestLibraries`
- `Test Runner`
- `Library Variable Storage`

It also relies on `internalsVisibleTo` access from the main app.

### Recommended execution order

1. Publish `App`
2. Publish Microsoft test dependencies
3. Publish `App.Test`
4. Run all tests
5. If a failure occurs, rerun the affected codeunit only

## What each test group validates

### Setup tests

Confirms that setup records and numbering infrastructure initialize correctly.

### Master tests

Confirms that blocked certifications cannot be used and that session defaults inherit from certification master data.

### Session tests

Confirms that invalid or incomplete sessions cannot be posted.

### Result tests

Confirms that candidate outcomes, attempt numbers, and result statuses are preserved after posting.

### Posting tests

Confirms that the posting routine creates:

- posted session header
- posted candidate lines
- copied comments
- ledger entries
- deletion of the original document

### Ledger tests

Confirms that candidate retakes remain traceable over time.

### Permission tests

Runs the standard setup, posting and review workflow end to end as an operational user. Test permissions are disabled, matching the reference app, so this checks workflow access paths rather than restricted-permission behavior.

## When to use this app

Use this app when you:

- change posting logic
- change validation logic
- adjust session or candidate behavior
- change ledger rules
- refactor internal procedures
- prepare a PR or release candidate

## Suggested operating rhythm

```text
Change code
  -> Publish main app
  -> Publish test app
  -> Run focused tests
  -> Run full suite
  -> Review failures
  -> Fix and rerun
```

## Practical tips

- Run focused codeunits first when you know the impacted area.
- Run the full suite before merging to main.
- Keep the helper library stable; it is the shared foundation for all tests.
- Prefer deterministic data setup so failures are easy to reproduce.

## Folder guide

| Folder | Purpose |
|---|---|
| `src/Library` | reusable test data and helpers |
| `src/Setup` | setup-focused tests |
| `src/Certification` | master-data tests |
| `src/Session` | document validation tests |
| `src/Results` | result persistence tests |
| `src/Posting` | end-to-end posting tests |
| `src/Ledger` | audit and history tests |
| `src/Security` | permission-related tests |
