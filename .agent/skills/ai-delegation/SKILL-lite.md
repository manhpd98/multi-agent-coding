---
name: AI Pilot — Smart Delegation
description: Delegate coding tasks to Claude Code or other AI workers. ONLY activates when user explicitly says use claude, dùng claude, used claude, delegate, hoặc khi user đồng ý sau khi được hỏi. NEVER auto-delegate without user consent.
---

# AI Pilot — Delegation Protocol

## When to Activate

**ONLY delegate when user says so.** Keywords: "dùng Claude", "use Claude", "delegate".
If user doesn't mention a worker → ASK which one to use.
If user doesn't mention delegation for complex tasks → ASK: "Bạn muốn delegate cho Claude Code không?"

## Protocol (Token-Optimized)

### Step 1: Generate task file

Write `.ai-pilot/tasks/task-<ID>.yaml`:

```yaml
id: task-001
type: bug-fix
description: "What to do"
files: [path/to/file.ts]
constraints:
  - Don't change unrelated files
  - Follow existing patterns
```

### Step 2: Run worker

```bash
# Claude Code (reads CLAUDE.md automatically)
claude -p "Read .ai-pilot/tasks/task-001.yaml and execute the task. Write result to .ai-pilot/results/task-001.json following the schema in .ai-pilot/schema/result.json" --output-format text

# Aider
aider --message "Read .ai-pilot/tasks/task-001.yaml and execute" --yes

# OpenCode
opencode run "Read .ai-pilot/tasks/task-001.yaml and execute"
```

### Step 3: Read result

Read `.ai-pilot/results/task-001.json` → decide:
- `status: completed` + `tests_passed: true` → ✅ Report success
- `status: completed` + `tests_passed: false` → Create fix task, re-delegate
- `status: failed` → Report error, ask user what to do

## Mode Selection (auto, don't ask user)

| Files | Risk | Mode |
|-------|------|------|
| 1 file | Low | 🟢 Skip task file, run `claude -p "TASK"` directly |
| 2-3 files | Medium | 🟡 Write task YAML → delegate → spot-check result |
| 4+ files | High | 🔴 Write task YAML → delegate → review all files → run hooks |

## Rules

1. Ask about delegation, not complexity
2. Ask about worker if not specified
3. For 🟢 mode: skip protocol, just `claude -p "..."` directly
4. For 🟡/🔴 mode: use full protocol (YAML → JSON)
5. Never review files for 🟢 mode → trust worker
6. Always review for 🔴 mode
