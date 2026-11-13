# MBS Certification Session Management

> A Business Central extension for planning certification sessions, recording candidate outcomes, posting immutable history, and tracking attempt-ledger data.

| Area | Details |
|---|---|
| App name | `MBS Certification Session Management` |
| Publisher | `MBS` |
| Primary app role | Operational business app |
| Object range | `50000..50099` |
| Runtime | `17.0` |

## Why this app exists

This app brings a clean document-style certification process into Business Central:

- maintain certification master data
- schedule certification sessions
- register candidates
- capture attendance, results, attempts, and notes
- post closed sessions into history
- review the resulting ledger trail for analysis and follow-up

It follows a familiar Business Central pattern: **setup → master data → document → posting → posted history → ledger**.

## What you get

### Core capabilities

- **Certification setup** with number series for live and posted documents
- **Certification master data** with duration and candidate thresholds
- **Session documents** with invigilator, room, date, and candidate lines
- **Candidate result capture** including attended flag, result status, score, and attempt number
- **Posting flow** that turns a session into posted history and ledger entries
- **Comment support** for certifications and sessions
- **Install codeunit** that creates the source code `MBSCERT` (*Certification Session Posting*) and stores it in the extended `Source Code Setup`
- **Operational permission set** (`MBS Cert. All Users`, 50000) for end users

### Key pages

| Page | Purpose |
|---|---|
| `Certification Setup` | Maintains numbering and defaults |
| `Certification List` / `Certification Card` | Maintains certification catalog |
| `Certification Session` / `Certification Session List` | Manages active session documents |
| `Posted Cert. Session` / `Posted Cert. Sess. List` | Reviews posted history |
| `Cert. Ledger Entries` | Reviews candidate attempt history |
| `Cert. Registers` | Reviews posting register boundaries |

## Quick start

If you only want the fast path, do this:

1. Publish the app.
2. Open **Certification Setup**.
3. Fill in:
   - `Certification Nos.`
   - `Cert. Session Nos.`
   - `Posted Cert. Sess. Nos.`
4. Create one or more records in **Certification List**.
5. Open **Certification Session List** and create a session.
6. Select the certification, session date, invigilator, and room.
7. Add candidates on the lines.
8. Record results and set the session status to **Closed**.
9. Use **Post**.
10. Review the result in **Posted Cert. Sess. List** and **Cert. Ledger Entries**.

## Detailed setup and usage

### 1. Initial setup

Open **Certification Setup** and assign three number series:

- certification master numbers
- certification session document numbers
- posted certification session numbers

Without these values, the app cannot create and post documents reliably.

### 2. Create certification master data

Use **Certification List** to register each certification.

Recommended fields to maintain:

- `Name`
- `Description`
- `Duration`
- `Min. Candidates`
- `Max. Candidates`
- `Blocked`

Use comments when business context or special instructions should stay with the certification.

### 3. Create a live certification session

In **Certification Session**, enter:

- the certification
- the planned session date
- the invigilator resource
- the room resource
- posting and document dates

The session inherits defaults from the certification where relevant.

### 4. Add candidates and capture outcomes

Use the lines subpage to register candidates.

For each candidate, capture as needed:

- candidate contact
- registration date
- attendance
- attempt number
- result status
- score
- notes

This gives the posting engine enough information to create a historical trace.

### 5. Close and post the session

Only post sessions that are ready and validated.

During posting, the app:

- validates the session header
- validates candidate lines
- assigns a posted document number
- creates the posted session header and posted candidate lines
- copies relevant comments to posted history
- writes certification ledger entries and register data
- removes the original open document

### 6. Review history and audit trail

After posting, use:

- **Posted Cert. Sess. List** for document-level history
- **Cert. Ledger Entries** for candidate attempt tracking
- **Cert. Registers** for register ranges and audit support

## Typical business flow

```text
Certification Setup
  -> Certification Master
  -> Certification Session
  -> Candidate Result Capture
  -> Close Session
  -> Post
  -> Posted Session History + Ledger Entries
```

## Suggested validation checklist

- create a certification and verify numbering
- create a session and confirm certification defaults flow down
- add multiple candidates
- post a closed session
- confirm posted lines are created
- confirm ledger entries exist per candidate
- confirm the original session document is removed after posting

## Notes for implementers and admins

- The app is designed for **internal operational use** in a controlled Business Central environment.
- Test, performance, and dataset apps are delivered separately so operational users can stay focused on the core business process.
- The app exposes internals to its companion apps for test automation, BCPT scenarios, and demo data generation.

## Publish order

```text
1. App
2. App.Test   (optional)
3. App.PerformanceTest   (optional)
4. App.Dataset   (optional)
```

## Folder guide

| Folder | Purpose |
|---|---|
| `src/Setup` | Setup table/page, install codeunit, Source Code Setup extension |
| `src/Certification` | Master data, comments, supporting enums |
| `src/Session` | Open document model |
| `src/Posting` | Posting logic and internal journal layer |
| `src/Posted Session` | Immutable posted history |
| `src/Ledger` | Attempt ledger and register tracking |
| `src/Permissions` | Permission set |

## Object ID blocks

| Type | IDs | Objects |
|---|---|---|
| Table | 50000..50009 | `MBS Certification Setup`, `MBS Certification`, `MBS Cert. Session Header`, `MBS Cert. Candidate Line`, `MBS Cert. Comment Line`, `MBS Posted Cert. Sess. Hdr.`, `MBS Posted Cert. Cand. Line`, `MBS Cert. Ledger Entry`, `MBS Cert. Register`, `MBS Cert. Journal Line` |
| Table extension | 50000 | `MBS Source Code Setup` (adds *Certification* source code) |
| Page | 50000..50012 | Setup, certification list/card, comment sheet/list, session document/list/subpage, posted session/list/subpage, ledger entries, registers |
| Codeunit | 50000..50004 | `MBS Certification-Post`, `MBS Cert.-Post (Yes/No)`, `MBS Cert. Jnl.-Check Line`, `MBS Cert. Jnl.-Post Line`, `MBS Certification Install` |
| Enum | 50000..50003 | Session status, result status, entry type, comment table name |
| Permission set | 50000 | `MBS Cert. All Users`: Execute on all objects, RIMD on setup, master and open-document data, RI on posted history and ledger, RIM on registers |
