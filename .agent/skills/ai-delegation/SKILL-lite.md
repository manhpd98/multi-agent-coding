---
name: AI Pilot — Smart Delegation
description: Delegate coding tasks to Claude Code or other AI workers. ONLY activates when user explicitly says use claude, dùng claude, used claude, delegate, hoặc khi user đồng ý sau khi được hỏi. NEVER auto-delegate without user consent.
---

# AI Pilot — Smart Delegation

> Antigravity auto-picks the best delegation mode. User just describes the task.

## When to Activate

**This skill ONLY activates when:**
1. User explicitly says "dùng Claude Code", "use Claude", "used Claude", "delegate", or similar
2. User responds "yes" when Antigravity asks "Bạn muốn delegate cho Claude Code không?"

**If user does NOT mention Claude Code:**
- For simple tasks → Antigravity does it directly, no need to ask
- For complex tasks → Antigravity ASKS: "Task này khá phức tạp, bạn muốn mình tự làm hay delegate cho Claude Code?"
- **NEVER auto-delegate without asking**

## Delegation Modes (after user confirms)

**Quick assessment (spend <200 tokens on this):**
1. How many files need changes? (1 → simple, 2-3 → medium, 4+ → complex)
2. Is the scope clear from the request alone? (yes → simple/medium, no → complex)
3. Is this high-risk? (DB schema, auth, payments → always complex)

Then auto-pick:

| Assessment | Mode | What to do |
|------------|------|------------|
| 1 file, clear scope, low risk | 🟢 **Direct** | `claude -p "TASK"` → done |
| 2-3 files, or unclear scope | 🟡 **Guided** | Quick plan → `claude -p "TASK"` → spot-check 1 file |
| 4+ files, high risk, or ambiguous | 🔴 **Full** | Analyze → plan → delegate → review all → test |

**Do NOT tell the user which mode you picked. Just do it.**

---

## 🟢 Direct Mode

```bash
claude -p "TASK_DESCRIPTION. Follow existing code patterns. Don't change unrelated files." --output-format text
```

After command completes, briefly report what Claude did. Skip review.

---

## 🟡 Guided Mode

1. Spend ~30 seconds reading the main file(s) involved
2. Write a focused prompt with file paths and constraints:
   ```bash
   claude -p "DETAILED_PROMPT_WITH_PATHS" --output-format text
   ```
3. After completion, `view_file` the main changed file to spot-check
4. Report results

---

## 🔴 Full Mode

1. **Analyze** — Read relevant files, understand architecture
2. **Plan** — Break into ordered tasks
3. **Delegate** — One task at a time via `claude -p "..."`
4. **Review** — Read all changed files
5. **Test** — Run build/test commands
6. **Report** — Summary with changes and test results

### Prompt Template (for Full Mode only)

```
[TASK_TYPE: Bug Fix / Feature / Refactor]

File: [PATH]
Function: [NAME] (if applicable)

What to do:
[SPECIFIC_INSTRUCTIONS]

Constraints:
- Don't change unrelated files
- Follow existing code patterns
- Keep tests passing
```

### Error Recovery

- If Claude's output is wrong → send targeted correction via `claude -p "Fix: ..."` 
- If build fails → send error message via `claude -p "Build error: ... Fix it."`

---

## Batch Mode (Auto-detect)

If user gives multiple small tasks at once, batch them into one prompt:

```bash
claude -p "Do these tasks:
1. [TASK_1]
2. [TASK_2]  
3. [TASK_3]
Don't ask questions. Work through each one." --output-format text
```

---

## Key Rules

1. **Auto-pick mode** — Never ask user "is this simple or complex?"
2. **Minimize token usage** — For 🟢 and 🟡, keep Antigravity's work minimal
3. **Only read files when necessary** — Don't read codebase for simple tasks
4. **Trust Claude Code for simple tasks** — Skip review for 🟢 mode
5. **Always review for 🔴 mode** — Complex tasks need quality checks
