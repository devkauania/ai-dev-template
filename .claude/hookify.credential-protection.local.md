---
name: credential-in-code
enabled: true
event: file
action: warn
conditions:
  - field: file_path
    operator: not_contains
    pattern: .env
  - field: new_text
    operator: regex_match
    pattern: (API_KEY|SECRET_KEY|TOKEN|PASSWORD|PRIVATE_KEY|ACCESS_KEY)\s*=\s*["'][^"']{8,}
---

**Hardcoded Credential Detected**

You're writing what looks like a hardcoded secret to a non-.env file.

**Convention:**
- Secrets go in `.env` (never committed)
- Access via settings/config module
- Document the variable in `.env.example` (without the real value)
- For tests, use mocks or environment variable overrides
