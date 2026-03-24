# Changelog

All notable changes to AI Pilot will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2026-03-24

### Added

- **Install Script** (`install.sh`)
  - One-line install: `curl -fsSL ... | bash`
  - Auto-detects installed AI workers
  - Optional copy of templates, examples, and docs

- **CLI Tool** (`bin/ai-pilot`)
  - `ai-pilot init` — Install .agent/ into any project
  - `ai-pilot delegate <worker> "<task>"` — Delegate tasks to Claude Code, OpenCode, or Aider
  - `ai-pilot review [files...]` — AI-powered code review
  - `ai-pilot status` — Check installed workers
  - `ai-pilot log` — View delegation history

- **Core Skill** (`.agent/skills/ai-delegation/SKILL.md`)
  - Multi-Pilot support (Antigravity, Cursor, Cline, GitHub Copilot)
  - Detailed mermaid flow diagram
  - Decision tree: when to delegate vs direct edit
  - Prompt templates: bug fix, feature, refactor, review, tests
  - Advanced multi-step delegation guide
  - Error handling playbook
  - Session logging format

- **Workflows**
  - `delegate-claude.md` — Claude Code delegation workflow
  - `delegate-opencode.md` — OpenCode delegation workflow
  - `delegate-aider.md` — Aider delegation workflow (NEW)
  - `code-review.md` — AI code review pipeline
  - `debug.md` — Structured debugging flow

- **Examples** (with actual code diffs)
  - `fix-bug.md` — Crash fix with Kotlin diffs
  - `add-feature.md` — Dark mode with React/Next.js diffs
  - `refactor.md` — MVVM refactor with Swift diffs and metrics

- **Templates**
  - `prompt-templates.md` — 8 ready-to-use prompt templates
  - Platform configs: iOS, Android, Web, Flutter, Python

- **Documentation**
  - `getting-started.md` — Complete setup guide
  - `best-practices.md` — Tips and anti-patterns
  - `supported-workers.md` — All compatible AI tools
  - `huong-dan-su-dung.md` — Vietnamese guide

- **Community**
  - `CONTRIBUTING.md` — Contribution guidelines
  - GitHub Issue templates (bug report, feature request)
  - `CHANGELOG.md` — This file

[1.0.0]: https://github.com/manhpd98/ai-pilot/releases/tag/v1.0.0
