---
name: data-information-design
description: "Decide which layer and place each piece of information takes in a persistent store of notes, logs, and ledgers (raw observations, normalized source-of-truth notes, outputs for decisions), how derived notes trace back to and stay fresh against their inputs, and how to find information in the store. Use before writing information whose place in the store is undecided, when designing or reorganizing a store's layers and layout, when searching a store for history, reasons, or current state, and when reading back a store's state at the start of a session. Not for what a single document such as a README, design doc, or ADR should contain."
---

# Data information design

A store of notes stays useful when every fact has exactly one authoritative
home and the questions asked most often reach that home in few steps. Lay the
store out as a medallion: Bronze, Silver, and Gold layers that rise in quality
from raw observation to decision-ready output.

## Inputs from the store

Read these from the store's own instructions before starting, and ask the
store's owner for any that are missing:

- The layer map: which locations hold Bronze, Silver, and Gold.
- The placement table: which kind of information goes to which location.
- The lookup table: for each common question, the commands that answer it.
- The metadata schema and the check that enforces it.

## Layers

| Layer | What it holds | How it is written |
| --- | --- | --- |
| Bronze | Original observations: conversation logs, review transcripts, collected source texts | Append only, or written by a tool; never edited afterward |
| Silver | Notes normalized for comparison: tasks, decisions, meeting notes, investigations, project conventions. The source of truth for each fact | One form for identifiers, dates, and names across the store; each fact cites its source |
| Gold | Outputs for a decision or action: status pages, reports, handouts | Rebuilt from Silver; holds no fact that Silver lacks |

## Rules for the whole task

- Keep each fact's source of truth in exactly one Silver note, and have Bronze
  and Gold notes point to it.
- When a Gold output is wrong, fix the Silver note first, then rebuild the
  output.
- Keep a pointer, not a copy, to information whose source of truth lives
  outside the store (chat messages, shared documents, tickets, pull requests,
  messages you sent); copy only a part that may disappear and that section 4
  allows.
- Take a note's date of last change from version control
  (`git log -1 --format=%cs -- <path>`) instead of a hand-written field.

## 1. Place new information

1. Classify the information: an observation to keep as it was (Bronze), a fact
   others will compare or rely on (Silver), or an output for one decision or
   action (Gold).
   Completion: the information has one layer.
2. Apply the store's placement table from the top and use the first row that
   matches. When no row matches, propose a new kind and location to the owner
   before writing.
   Completion: the destination is a row of the table or an addition the owner
   approved.
3. Write the note with its lineage (section 2) and freshness (section 3).
   Completion: the note's source of truth is in one Silver note, and every
   Bronze and Gold note that uses it points there.
4. Run the store's check on the notes you changed, and report problems in other
   notes instead of fixing them, since they lie outside your change.
   Completion: the check reports zero problems for the notes you changed.

## 2. Lineage

- Name every derived note's inputs in its metadata: the originals outside the
  store and the notes inside it that it was built from.
- Point a derived note only at its own layer or a lower one: Gold at Silver or
  Bronze, Silver at Silver or Bronze.
- When moving or renaming a note, update every link and lineage entry that
  names its path in the same commit.
- Leave old paths in Bronze text as they are, and find the moved note by its
  base name (`fd '<base name>'`).

Completion: every derived note names its inputs, and the store's check reports
no dangling link.

## 3. Freshness

- Give a Silver note that states a time-limited fact (a tool version, an
  issue's status, a pending reply, contract terms) a review-by date.
- When a note passes its review-by date, recheck its facts, then move the date
  forward or mark the note superseded.
- When part of a decision changes, write a new decision that supersedes the old
  one, and leave the old one unedited.
- Rebuild a Gold output from Silver when it goes stale, instead of marking it.
- Keep one file per Gold output and let version control hold its earlier
  versions.

Completion: no note is past its review-by date, or the overdue notes are
reported to the owner.

## 4. Safety

- Leave out of every layer, Bronze included: secrets (tokens, passwords,
  cookies, sessions), personal information the work does not need, and full
  texts of copyrighted works whose terms of distribution are unknown.
- When you find such content, report its location to the owner without copying
  the value.

## 5. Find information

- Answer from the store's lookup table first, including the state read back at
  the start of a session, and search full text only when its commands do not
  reach the answer.
- Start a full-text search at Silver locations, and search Bronze conversation
  logs last.
- When a full-text search finds a note that lacks the metadata key the question
  used (a task ID, a project name), add the key so the table's lookup reaches
  the note next time.

Completion: every claim in the answer rests on the output of a lookup command
or a note you opened.

## 6. Design or reorganize the layout

- Start from the questions the store must answer and who acts on the answers;
  give each recurring question one Gold output or one lookup row.
- When the work depends on history or logs, decide which Bronze evidence to
  keep before designing any Gold output.
- For each Silver kind, fix the identifiers, date format, and names it
  normalizes, and the metadata fields that hold its lineage and review-by date.
- Express the layers with plain files and folders (Markdown notes, a table, a
  folder per kind) unless the questions need more.
- Write the layer map, the placement table, the lookup table, and the schema
  into the store's own instructions, and have its check enforce the schema.

Completion: every common question has a lookup row that reaches a Silver note
or a Gold output, and every kind of information has a placement row.

## Report

Report briefly: where each piece of information went and why, the lineage
written, overdue notes, safety findings, and what you could not verify.
