---
name: require-validation-before-stop
enabled: true
event: stop
action: warn
pattern: .*
---

**Session Checklist - Validate Before Stopping**

Per CLAUDE.md rule #1 (Zero Regressions), ensure these are done:

1. **Run `make validate`** — all tests must pass, lint clean
2. **Check test counts** against `.context/STATE.md` baseline — no regressions allowed
3. **Update `.context/STATE.md`** if you completed any features or changed test counts

If you haven't run validation yet, do it now before stopping.
