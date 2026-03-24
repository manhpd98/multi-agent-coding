# Session Log Template

Use this template to log each delegation session. Save logs to `.ai-pilot/logs/YYYY-MM-DD.log`.

## Log Format

Each entry should follow this format:

```
═══════════════════════════════════════
SESSION: [SESSION_ID or timestamp]
DATE: [YYYY-MM-DD HH:MM]
═══════════════════════════════════════

TASK: [User's original request]
WORKER: [claude / opencode / aider]
MODE: [one-shot / interactive]

PLAN:
1. [Task 1 description]
2. [Task 2 description]
3. [Task 3 description]

DELEGATIONS:
┌─ Delegation 1
│  Prompt: [What was sent to Coder]
│  Result: [success / failed / corrected]
│  Files: [List of modified files]
└─ Duration: [X minutes]

┌─ Delegation 2
│  Prompt: [What was sent to Coder]
│  Result: [success / failed / corrected]
│  Files: [List of modified files]
└─ Duration: [X minutes]

REVIEW:
- [X] Correctness verified
- [X] Style consistent
- [X] No scope creep
- [ ] Edge cases checked (note: [any concerns])

VERIFICATION:
- Build: ✅ Pass / ❌ Fail
- Tests: ✅ 42/42 / ❌ 40/42 failed
- Lint:  ✅ Clean / ⚠️ 2 warnings

SUMMARY:
[Brief description of what was accomplished]

ISSUES ENCOUNTERED:
- [Any problems and how they were resolved]

RECOMMENDATIONS:
- [Follow-up tasks or improvements to consider]
═══════════════════════════════════════
```

## Quick Log (One-liner)

For simple tasks, use the compact format:

```
[2025-03-24 10:30] worker=claude mode=one-shot task="Fix null pointer in auth.ts" status=completed files=1 tests=pass
```

## CLI Logging

The `ai-pilot` CLI automatically logs delegations:
```bash
ai-pilot delegate claude "Fix the login bug"
# → Logged to .ai-pilot/logs/2025-03-24.log

ai-pilot log
# → View recent sessions
```
