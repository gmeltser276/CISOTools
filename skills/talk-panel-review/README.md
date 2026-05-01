# Talk Panel Review

A Claude Code skill that runs a simulated expert panel review of talk scripts and presentation drafts. Nine panelists with distinct analytical lenses debate story arc, content credibility, presentation quality, audience fit, and delivery -- then produce a ranked consensus improvement list.

## Installation

```bash
mkdir -p ~/.claude/skills/talk-panel-review
cp SKILL.md ~/.claude/skills/talk-panel-review/
```

## Usage

Point it at a talk script or presentation draft:

```
Review my talk at Presentations/RSA 2026 Keynote.md
```

Or invoke the skill directly:

```
/talk-panel-review
```

Then provide the talk path or paste the content.

## What it does

The skill reads your talk script, pulls recent industry context (via the `last30days` plugin or web search fallback), assembles a 7-9 member expert panel, and runs a three-round critique.

### The panel

Six core roles are always present:

| Code | Role | Lens |
|------|------|------|
| PE | Presentation Expert | Narrative spine, slide structure, visual hierarchy |
| SC | Speaker Coach | Delivery rhythm, register consistency, quotable moments |
| SME | Subject Matter Expert | Claim accuracy, source credibility, framing vs. consensus |
| PL | Peer Leader | Credibility, peer register, practitioner authenticity |
| AA | Audience Advocate | Thesis clarity, Monday-morning takeaway, cognitive load |
| DA | Devil's Advocate | Steelmanned objections, whether the talk defeats or ignores them |

1-3 adaptive roles are added based on the talk's subject matter (AI/Technology Visionary, Policy/Government Expert, Operations Director, Risk/Compliance Expert, Budget/Finance Advocate, Data Communication Expert, Inclusion/Assumption Auditor).

### Three rounds

1. **First Impressions** -- each panelist gives a fast, opinionated read through their lens. Specific slides and lines, not generalities.
2. **Structural Debate** -- panelists engage with each other. Disagreements get resolved or sharpened.
3. **Consensus** -- 5-8 priority improvements (ranked, with specific slide/section references) and 3-5 "do not change" items worth protecting.

### Optional: Apply improvements

Ask the agent to apply the consensus improvements. It works top-to-bottom from the priority list and treats the "do not change" list as a regression test -- if an edit damages a protected element, it reverts and finds another approach.

## Dependencies

**Required:** None. The skill works standalone with any Claude Code setup.

**Recommended (for best results):**

| Plugin | Purpose |
|--------|---------|
| [last30days](https://github.com/mvanhorn/last30days-skill) | Industry context from Reddit, X, HN, GitHub, Polymarket, web. Gives panelists current framing to evaluate against. |
| [Exa](https://exa.ai/) MCP server | Web search fallback if `last30days` is unavailable |

Without these, the SME panelist works from the model's training data alone -- still useful, but less current.

## Talk script format

The skill works with any markdown talk script. For best results, include frontmatter:

```yaml
---
title: Your Talk Title
audience: Security practitioners at mid-size enterprises
format: 25-minute presentation, 15 slides
core_message: The thesis of your talk
desired_outcome: What the audience should leave with
resistance: What pushback the audience brings
tone: Direct, technically grounded
---
```

Missing fields are inferred from content. If something can't be inferred, the skill asks before proceeding.

## How it differs from generic feedback

- **Structured disagreement.** Panelists are designed to conflict. The Speaker Coach and Presentation Expert have non-overlapping domains. The Devil's Advocate steelmans the audience's resistance, not the speaker's argument.
- **Specificity enforced.** Every critique must name a slide, section, or line. "The pacing feels off" is rejected; "Slides 8-11 present four consecutive data charts with no breathing room" is accepted.
- **Audience Advocate has veto weight.** If the AA says the audience is lost, that overrides other panelists.
- **Current industry context.** The `last30days` integration means panelists evaluate whether your framing is ahead of, behind, or sideways to where the industry conversation is right now.
- **"Do not change" list.** Prevents the speaker from "fixing" things that work. Equally weighted with improvements.

## License

MIT
