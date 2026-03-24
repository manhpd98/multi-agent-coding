---
description: Quick delegate to Claude Code with minimal token overhead. Use when user says quick delegate, fast delegate, delegate nhanh, giao nhanh cho claude.
---

# Quick Delegate (Token-Optimized)

Minimal Antigravity involvement. Claude Code does all the work.

## Steps

1. **Construct a one-line prompt** — include file path + task + constraints
2. **Run Claude Code one-shot:**
   ```bash
   claude -p "PROMPT_HERE" --output-format text
   ```
3. **Done** — Trust Claude Code's output for simple tasks

## That's it.

No planning. No reviewing. No testing. Just delegate and go.

**Only use this for low-risk tasks.** For anything complex, use `/delegate-claude` instead.

## Examples

```bash
# Fix a bug
claude -p "Fix the null pointer crash in src/auth/login.ts at line 42. Add a null check before accessing user.email. Don't change other files." --output-format text

# Add a function
claude -p "In src/utils/date.ts, add a function formatRelativeTime(date: Date): string that returns '2 hours ago' style strings. Follow the patterns in the existing file." --output-format text

# Batch small tasks
claude -p "1. Fix typo 'recieve' → 'receive' in src/api.ts
2. Add .env.local to .gitignore
3. Update copyright year to 2025 in LICENSE" --output-format text
```
