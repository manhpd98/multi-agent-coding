# Contributing to AI Pilot

Thank you for considering contributing to AI Pilot! This project is community-driven and we welcome contributions of all kinds.

## How to Contribute

### 1. Report Issues

Found a bug or have a feature request? [Open an issue](https://github.com/manhpd98/ai-pilot/issues/new/choose) using one of our templates.

### 2. Submit a Pull Request

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/my-improvement`
3. Make your changes
4. Test your changes (see below)
5. Commit: `git commit -m "feat: add support for Cursor as worker"`
6. Push: `git push origin feature/my-improvement`
7. Open a Pull Request

### 3. Improve Documentation

Documentation improvements are always welcome! Fix typos, add examples, improve clarity.

## Contribution Areas

### 🔧 Add a New AI Worker

To add support for a new AI coding tool:

1. **Create a workflow** at `.agent/workflows/delegate-[tool-name].md`
   - Follow the pattern in `delegate-claude.md`
   - Document: launch command, how to send tasks, how to review output
2. **Update SKILL.md** — Add the tool to the "Available AI Workers" table
3. **Update CLI** — Add the worker to `bin/ai-pilot`'s delegate function
4. **Update docs** — Add to `docs/supported-workers.md`

### 🌐 Add a Platform Config

To add support for a new platform/framework:

1. Create a config at `templates/project-configs/[platform].md`
2. Include: build/test/lint commands, common file patterns, delegation context template
3. Follow the pattern in `ios.md` or `web.md`

### 📝 Add an Example

To add a real-world example:

1. Create at `examples/[scenario].md`
2. **Must include**: actual prompts sent, code diffs, terminal output, lessons learned
3. Follow the pattern in `examples/fix-bug.md`

### 🌍 Add a Translation

1. Create at `docs/[language-code].md` (e.g., `docs/ja.md` for Japanese)
2. Translate the getting-started content and examples
3. Follow the pattern in `docs/huong-dan-su-dung.md` (Vietnamese)

## Commit Convention

We use [Conventional Commits](https://www.conventionalcommits.org/):

```
feat: add Aider worker support
fix: correct typo in prompt template
docs: add Korean translation
chore: update CLI version number
```

## Testing Your Changes

Since AI Pilot is primarily markdown + shell scripts:

1. **Shell scripts**: Test `install.sh` and `bin/ai-pilot` in a clean directory
   ```bash
   mkdir /tmp/test-project && cd /tmp/test-project
   /path/to/ai-pilot/bin/ai-pilot init
   /path/to/ai-pilot/bin/ai-pilot status
   ```

2. **Markdown**: Ensure proper formatting, links work, and code blocks are correct

3. **Workflows**: If possible, test the delegation workflow with an actual AI worker

## Code of Conduct

- Be respectful and constructive
- Welcome newcomers
- Focus on the code, not the person
- Assume good intentions

## Questions?

Open a [Discussion](https://github.com/manhpd98/ai-pilot/discussions) or reach out via Issues.
