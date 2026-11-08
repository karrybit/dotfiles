# Citing Sources

Read when: quoting, citing, or claiming from a source, writing that something
is absent, or using or writing a cached summary.

## Quoting and Citing

- Say which source you actually read, and mark a claim resting on a summary as
  lower confidence.
- Build a verbatim quote only from the source text itself, not from a
  summarizing fetch, a search snippet, or recall, since those produce quotes,
  error strings, and example sentences the source does not contain.
- Verify a PDF quote with
  `$XDG_DATA_HOME/agents/scripts/pdf-cite/bin/pdf-cite`; it exits non-zero when
  the quote is absent.
- Before citing a file, prior decision, or repository document, open it and
  confirm the claim, since a citation claims something about its contents.
- When the cited claim is not there, name where the behavior actually comes
  from.

## Claiming an Absence

- Before writing that something is absent or unaddressed, bring the whole
  source into view or record the claim as unknown.
- Treat an excerpt, a filtered search, a truncated read, and a delegated
  excerpt-level search as evidence about only the region examined.

## Caching a Source Summary

- Cache a reusable source summary under `$XDG_DATA_HOME/agents/docs/` (or
  `~/.local/share/agents/docs/` when unset).
- Record the source URL, date checked, version context, and revalidation
  trigger in the summary.
- Cache what will be reused, and leave one-off investigation notes out.
- Keep attribution instead of copying long passages.
- When you encounter a stale, superseded, or duplicated cached summary, prune
  it.
