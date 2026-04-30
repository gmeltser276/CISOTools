# WARP.md

This file provides guidance to WARP (warp.dev) when working with code in this repository.

## What this repo is
This repository is a **Claude Code skill** implemented as Markdown with progressive disclosure.

The "runtime" artifact is `SKILL.md`: Claude Code reads the YAML frontmatter (metadata + allowed tools) and the prompt/instructions that follow. Supporting files in `references/` and `examples/` are loaded on demand.

`README.md` is for humans: installation, usage, and a compact overview.

## Key files (and how they relate)
- `SKILL.md`
  - The skill definition. Always loaded when the skill triggers.
  - YAML frontmatter (`---` ... `---`) with `name`, `version`, `description`, and `allowed-tools`.
  - After the frontmatter: personality/soul guidance, pattern quick-reference tables, process, and output format.
  - ~1,400 words. Designed for quick scanning against text.
- `references/patterns.md`
  - Full pattern descriptions with before/after examples for all 40+ AI writing patterns.
  - Loaded on demand when rewrite guidance for a specific pattern is needed.
  - ~3,500 words. Organized into 7 categories.
- `examples/full-rewrite.md`
  - A complete before/after calibration example showing heavy AI contamination fully humanized.
  - ~800 words.
- `README.md`
  - Installation and usage instructions.

When changing behavior/content, treat `SKILL.md` as the source of truth for the process and quick-reference tables, and `references/patterns.md` as the source of truth for detailed pattern definitions. Update `README.md` to stay consistent.

## Common commands
### Install the skill into Claude Code
Recommended (clone directly into Claude Code skills directory):
```bash
mkdir -p ~/.claude/skills
git clone https://github.com/blader/humanizer.git ~/.claude/skills/humanizer
```

Manual install/update (all skill files):
```bash
mkdir -p ~/.claude/skills/humanizer/{references,examples}
cp SKILL.md ~/.claude/skills/humanizer/
cp references/patterns.md ~/.claude/skills/humanizer/references/
cp examples/full-rewrite.md ~/.claude/skills/humanizer/examples/
```

## How to "run" it (Claude Code)
Invoke the skill:
- `/humanizer` then paste text

## Making changes safely
### Versioning (keep in sync)
- `SKILL.md` has a `version:` field in its YAML frontmatter.
- `README.md` has a "Version History" section.

If you bump the version, update both.

### Editing
- `SKILL.md`: Preserve YAML frontmatter formatting. The quick-reference tables must stay in sync with the pattern entries in `references/patterns.md`.
- `references/patterns.md`: Pattern numbering (1.1, 2.3, etc.) should remain stable. Add new patterns at the end of their category.
- When adding a new pattern, add it to both the SKILL.md quick-reference table AND `references/patterns.md`.

### Documenting non-obvious fixes
If you change the prompt to handle a tricky failure mode, add a short note to `README.md`'s version history describing what was fixed and why.
