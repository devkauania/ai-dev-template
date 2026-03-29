---
name: env-file-safety
enabled: true
event: file
action: warn
conditions:
  - field: file_path
    operator: regex_match
    pattern: \.env$|\.env\.
---

**Editing .env File - Critical Rules**

1. **NO inline comments** — `KEY=value # comment` is read as `value # comment` by most parsers
2. **Update `.env.example`** with any new variables (without real values)
3. **Never commit** `.env` files — ensure `.gitignore` covers them
4. **Docker hostnames**: If using containers, use service names (not localhost)
