# Supported AI Workers

All AI coding tools that can be used as the "Coder" in AI Pilot.

## Officially Supported

### Claude Code
- **By**: Anthropic
- **Install**: `npm install -g @anthropic-ai/claude-code`
- **Auth**: Claude Pro ($20/mo), Max ($100/mo), or Team/Enterprise
- **Models**: Claude Opus, Sonnet, Haiku
- **Best for**: Complex refactoring, deep codebase understanding, multi-file edits
- **Mode**: Interactive (`claude`) or One-shot (`claude -p "..."`)
- **Website**: [anthropic.com/claude-code](https://www.anthropic.com/claude-code)
- **CLI**: `ai-pilot delegate claude "task"`

### OpenCode
- **By**: Anomaly
- **Install**: `curl -fsSL https://opencode.ai/install | bash`
- **Auth**: Free (includes free models), or BYO API key
- **Models**: 75+ providers — Claude, GPT, Gemini, Llama, and more
- **Best for**: Quick tasks, teams with different AI subscriptions
- **Mode**: Interactive TUI, Web UI, or One-shot (`opencode run "..."`)
- **Website**: [opencode.ai](https://opencode.ai)
- **CLI**: `ai-pilot delegate opencode "task"`

### Aider
- **By**: Paul Gauthier (open source)
- **Install**: `pip install aider-chat` or `brew install aider`
- **Auth**: BYO API key (Anthropic, OpenAI, Google, or any provider)
- **Models**: Claude, GPT-4, Gemini, Llama, and more
- **Best for**: Git-aware edits, pair programming, auto-commits
- **Mode**: Interactive (`aider`) or One-shot (`aider --message "..." --yes`)
- **Website**: [aider.chat](https://aider.chat)
- **CLI**: `ai-pilot delegate aider "task"`
- **Special features**:
  - Auto-commits with descriptive messages
  - Architect mode (separate planning + coding models)
  - `/undo` to revert changes
  - Lint and test integration

## Community Integrations (Contributions Welcome!)

These tools could be integrated. PRs welcome:

| Tool | Type | Status | Notes |
|------|------|--------|-------|
| [Cline](https://cline.bot) | VS Code Extension | 🔜 Planned | Autonomous coding agent |
| [Cursor](https://cursor.sh) | IDE | 🔜 Planned | AI-first code editor |
| [GitHub Copilot CLI](https://githubnext.com/projects/copilot-cli) | Terminal | 🔜 Planned | GitHub's AI assistant |
| [Codex CLI](https://github.com/openai/codex-cli) | Terminal | 🔜 Planned | OpenAI's coding agent |
| [Windsurf](https://windsurf.com) | IDE | 💭 Considering | AI-first IDE |

## Adding a New Worker

To add support for a new AI worker:

1. **Create a workflow** at `.agent/workflows/delegate-[tool-name].md`
   - Follow the pattern in `delegate-claude.md`
   - Document the launch command
   - Document how to send tasks
   - Document how to review output
2. **Update SKILL.md** — Add the tool to the "Available AI Workers" table
3. **Update CLI** — Add the worker to `bin/ai-pilot`'s `cmd_delegate` function
4. **Update this file** — Add documentation above
5. **Submit a PR!**

See [CONTRIBUTING.md](../CONTRIBUTING.md) for full contribution guidelines.

## Choosing the Right Worker

| Scenario | Recommended Worker |
|----------|-------------------|
| Complex multi-file refactoring | Claude Code |
| Quick one-file fix | Any (OpenCode is fastest) |
| Want auto-commits | Aider |
| Want free models | OpenCode or Aider (with Gemini) |
| Team with mixed subscriptions | OpenCode |
| Pair programming style | Aider |
| Deep codebase understanding | Claude Code |
