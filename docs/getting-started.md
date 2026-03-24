# Getting Started

Complete guide to setting up and using AI Pilot.

## Prerequisites

- One of the following **Pilot** AI assistants:
  - **Antigravity** — VS Code extension (full skill/workflow support)
  - **Cursor** — AI-first IDE
  - **Cline** — VS Code extension
  - **GitHub Copilot** — VS Code / CLI
- One of the following **AI Workers** (Coders):
  - **Claude Code** — Requires Claude Pro/Max subscription
  - **OpenCode** — Free, includes free models
  - **Aider** — Open source, bring your own API key

## Installation

### Method 1: One-line Install

```bash
# Install into current directory
curl -fsSL https://raw.githubusercontent.com/manhpd98/ai-pilot/main/install.sh | bash

# Install into a specific project
curl -fsSL https://raw.githubusercontent.com/manhpd98/ai-pilot/main/install.sh | bash -s -- /path/to/project
```

### Method 2: CLI Tool

```bash
# Clone the repo
git clone https://github.com/manhpd98/ai-pilot.git

# Add to PATH
export PATH="$PATH:$(pwd)/ai-pilot/bin"
# (Add to ~/.zshrc or ~/.bashrc to make permanent)

# Initialize in any project
cd /path/to/your/project
ai-pilot init
```

### Method 3: Manual Copy

```bash
git clone https://github.com/manhpd98/ai-pilot.git
cp -r ai-pilot/.agent /path/to/your/project/
```

## Install an AI Worker

### Claude Code
```bash
npm install -g @anthropic-ai/claude-code
claude  # Follow login prompts
```

### OpenCode
```bash
curl -fsSL https://opencode.ai/install | bash
source ~/.zshrc  # or restart your terminal
opencode
```

### Aider
```bash
pip install aider-chat
# or: pipx install aider-chat
# or: brew install aider

# Set your API key
export ANTHROPIC_API_KEY=sk-...
# or: export OPENAI_API_KEY=sk-...
```

## Verify Installation

```bash
# Check everything is set up
ai-pilot status
```

Or manually verify in VS Code:

> _"List all files in this project"_

Then try delegating:

> _"Use Claude Code to add a comment to the main file"_

## How to Trigger Delegation

### By Keyword (in Pilot chat)

| Phrase | Effect |
|--------|--------|
| "delegate to Claude Code" | Uses Claude Code as Coder |
| "use Claude Code" | Uses Claude Code as Coder |
| "delegate to OpenCode" | Uses OpenCode as Coder |
| "delegate to Aider" | Uses Aider as Coder |

### By Workflow Shortcut

> _"/delegate-claude fix the login bug"_
> _"/delegate-aider add input validation"_

### By CLI

```bash
ai-pilot delegate claude "Fix the null pointer in auth.ts"
ai-pilot delegate aider "Add dark mode toggle"
ai-pilot delegate opencode "Update the API docs"
```

## Project Configuration

For platform-specific settings, see:
- [iOS Config](../templates/project-configs/ios.md)
- [Android Config](../templates/project-configs/android.md)
- [Web Config](../templates/project-configs/web.md)
- [Flutter Config](../templates/project-configs/flutter.md)
- [Python Config](../templates/project-configs/python.md)

## Next Steps

- Read [Best Practices](best-practices.md) for tips
- Browse [Prompt Templates](../templates/prompt-templates.md) for ready-to-use prompts
- See [Examples](../examples/) for real-world walkthroughs with code diffs
- Check [Supported Workers](supported-workers.md) for all compatible AI tools
