---
description: Delegate coding to Aider while the Pilot manages. Use when user says use aider, delegate to aider, dùng aider.
---

# Delegate to Aider

Use this workflow when you want the Pilot to manage while Aider writes code. Aider is git-aware, automatically creates commits, and supports many AI models.

## Why Aider?

- **Git-native** — Automatically commits changes with descriptive messages
- **Multi-model** — Works with Claude, GPT-4, Gemini, Llama, and more
- **Pair programming** — Interactive mode feels like real pair programming
- **Free** — Open source, bring your own API key

## Steps

1. **Analyze the request** — Understand requirements, read relevant files
2. **Create a plan** — Break into specific tasks
3. **Launch Aider** in the project directory:
   ```bash
   cd /path/to/project && aider
   ```
4. **Send instructions** — Clear, specific prompts with file paths
5. **Review output** — Check git diffs for all changes
6. **Test** — Build and run tests
7. **Report** — Summarize changes and commits

## Quick Commands

```bash
# One-shot mode — make a change and exit
aider --message "Fix the null pointer in auth.ts line 42" --yes

# Interactive mode — ongoing pair programming
aider

# Specify which files to work with (recommended)
aider src/api/user.ts src/api/auth.ts

# Use a specific model
aider --model claude-sonnet-4-20250514

# Use with Gemini (free)
aider --model gemini/gemini-2.5-pro

# Architect mode — separate planning and coding models
aider --architect --model claude-sonnet-4-20250514 --editor-model claude-haiku-4-20250514
```

## Aider-Specific Features

- **Auto-commits** — Every change is automatically committed with descriptive messages
- **Undo** — Use `/undo` to revert the last change
- **Add files** — Use `/add <file>` to add files to the context
- **Architect mode** — Separate models for planning vs coding
- **Lint integration** — Runs linter after each change
- **Test integration** — Run tests with `/test` command
- **Web search** — Use `/web <query>` for documentation lookup

## Reviewing Aider's Changes

After Aider makes changes, review using git:
```bash
# See what changed
git diff HEAD~1

# See the commit message
git log -1

# Revert if needed
git revert HEAD
```

## When to Use

✅ Use Aider when:
- You want automatic git commits
- You prefer pair programming style
- You need to work across multiple files with full context
- You want to use free/open-source models
- You need architect mode (separate planning + coding)

❌ Use Claude Code instead when:
- You need deep Anthropic model integration
- Complex refactoring requiring long context

❌ Use OpenCode instead when:
- You want a web UI
- You need multi-session support

## Installation

```bash
# Via pip
pip install aider-chat

# Via pipx (recommended)
pipx install aider-chat

# Via Homebrew
brew install aider
```

Set your API key:
```bash
export ANTHROPIC_API_KEY=sk-...
# or
export OPENAI_API_KEY=sk-...
# or
export GEMINI_API_KEY=...
```
