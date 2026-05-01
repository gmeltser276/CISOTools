---
name: talk-panel-review
description: Run a simulated expert panel review of a talk script or presentation draft. Panelists debate story arc, content credibility, presentation quality, audience fit, and flow -- then produce a consensus improvement list. Use PROACTIVELY when the user shares a talk script, speaker notes, presentation outline, or asks for feedback on a talk, keynote, panel prep, or conference presentation. Also use when the user says "panel review", "expert panel", "critique my talk", "review my presentation", or references improving a talk's story arc or flow.
---

# Talk Panel Review

You are reviewing a talk script for a security leader who speaks at security conferences, government events, and industry panels. The speaker's register is direct, technically grounded, quotable, no corporate filler.

## How This Works

1. Read the talk script (the user will provide a path or the content)
2. Extract the talk metadata (audience, format, topic, desired outcome) from frontmatter or context
3. Run `/last30days:last30days` once to pull recent context relevant to the talk's domain
4. Assemble the expert panel based on the talk's subject matter
5. Run the panel critique
6. Deliver the results

## Step 1: Read and Extract

Read the full talk script. Pull these fields from frontmatter or infer from content:

- **audience** -- who is in the room, what they care about, what they're tired of hearing
- **format** -- length, structure (presentation, panel, workshop)
- **core_message** -- the central thesis
- **desired_outcome** -- what the audience should leave with
- **resistance** -- what pushback or skepticism the audience brings
- **tone** -- the speaker's intended register

If any of these are missing and not inferrable, ask the user before proceeding.

## Step 2: Recent Context -- Industry Thinking

The goal is to build a sharp picture of where current industry thinking actually is on the talk's topics -- the live conversation, emerging consensus, open debates, and shifts in framing. This context lets panelists evaluate whether the talk's narrative, claims, and framing land in the right place relative to where the industry conversation is right now.

This is NOT for fact-checking individual statistics or verifying source citations. It is for sharpening opinion and vision: Does the talk's thesis align with where practitioners and thought leaders are headed? Is the framing ahead of the curve, behind it, or sideways to it? Are there arguments or framings gaining traction in the field that the talk should engage with or acknowledge?

**Preferred method:** Run `/last30days:last30days` with the `--deep` flag and a query scoped to the talk's core themes. For a cybersecurity talk about budget prioritization and AI threats, this might be `/last30days:last30days --deep AI reshaping cybersecurity defense, budget-constrained security programs, exploit timeline collapse, AI maturity security operations`. For a governance talk, scope accordingly.

**Fallback (if /last30days is unavailable or fails):** Run 5-7 parallel web searches (`mcp__exa__web_search_exa`) scoped to the talk's core themes, plus vault searches (`mcp__qmd__query`) for prior talks and reference material on the same topics. Each search should target a distinct theme from the talk (e.g., one for threat landscape shifts, one for budget/funding data, one for the key framework or methodology cited). Pull enough depth from each source that panelists can evaluate thematic alignment, not just surface-level keyword overlap.

Save the output -- it becomes shared context for all panelists.

## Step 3: Assemble the Panel

The panel always includes these six core roles. Each role has a specific analytical lens:

| Role | Code | Lens |
|------|------|------|
| Presentation Expert | PE | Structural architect. Evaluates whether the slide sequence forms a single narrative spine -- can you draw a straight line from opening to close? Owns slide count vs. time budget, data density vs. breathing room, and visual hierarchy. Does not evaluate delivery or verbal pacing (that's SC). |
| Speaker Coach | SC | Delivery and rhythm. Evaluates whether the speaker's voice stays in register or drifts into lecture, hedge, or corporate filler. Owns peak/valley emotional rhythm, quotable moments, verbal tics, and whether the opening and closing land. Does not evaluate slide structure or visual design (that's PE). |
| Subject Matter Expert | SME | Claim auditor. Cross-references every sourced claim in the talk against the research context from Step 2. Flags where the talk's framing diverges from current industry consensus, where a skeptic in the audience could find holes, and where numbers from different methodologies are presented as equivalent. Names the specific claim and the conflicting evidence. |
| Peer Leader | PL | Credibility, peer register, whether the speaker sounds like someone who does the work. |
| Audience Advocate | AA | Represents the least-expert person in the room. Evaluates through three structured checks: (1) Can the audience state the thesis in one sentence after hearing the talk? (2) Does the audience have a concrete action for Monday morning? (3) At what slide does cognitive load peak, and is there relief after it? If any check fails, the AA names the specific slide where it breaks down. |
| Devil's Advocate | DA | Steelmans the audience's resistance. Reads the `resistance` field from frontmatter (or infers it from context) and constructs the strongest version of each objection. Then evaluates whether the talk actually defeats it or just talks past it. Names the specific slide where each objection should be addressed, whether the talk engages it or ignores it, and what the unconvinced audience member is thinking as they walk out. |

Then add 1-3 adaptive roles based on the talk's subject matter. Select from:

| Role | When to include | Lens |
|------|-----------------|------|
| AI/Technology Visionary | Talk covers AI, emerging tech, or capability shifts | Evaluates whether the talk's technology framing matches where capability actually is today -- not where it was six months ago. Flags stale framings, missing developments, and opportunities to connect the audience to stealable resources. |
| Policy/Government Expert | Talk involves legislation, regulation, federal programs, or funding | Evaluates whether policy claims, funding figures, and program statuses are current. Flags where the political landscape has shifted since the talk was drafted and where advocacy asks need more specificity to be actionable. |
| Operations Director | Talk involves incident response, SOC, change management, or staffing | Evaluates whether operational recommendations are realistic for the audience's staffing and process maturity. Flags where the talk assumes capabilities the audience doesn't have. |
| Risk/Compliance Expert | Talk involves risk frameworks, audits, or compliance programs | Evaluates whether risk framing is precise and whether framework references are current. Flags where compliance language obscures operational meaning. |
| Budget/Finance Advocate | Talk involves cost arguments, ROI, or funding asks | Evaluates whether cost claims are sourced, whether ROI arguments would survive a finance committee, and whether the audience can actually use the numbers presented to make a budget case. |
| Data Communication Expert | Talk has 2+ data-heavy slides (charts, stat cards, survival curves) | Evaluates whether chart types match the claim being made, whether annotations guide the eye to the right conclusion, whether visual encoding communicates the data accurately, and whether the audience can read and interpret each chart in the time the speaker gives them. Diagnoses the root cause when PE or AA flag data overload. |
| Inclusion / Assumption Auditor | Audience spans a wide range of expertise, background, or institutional type | Flags assumed knowledge, jargon that excludes, cultural references that signal "this isn't for you," and examples calibrated to the wrong audience segment. Evaluates whether every audience member -- not just the median one -- can follow the talk and see themselves in it. |

Name each adaptive panelist with a descriptive title (e.g., "AI Visionary" not just "Panelist 6"). The panel should have 7-9 members total.

## Step 4: Run the Panel

The panel operates in three rounds. Each round has a distinct purpose.

### Round 1: First Impressions

Each panelist gives their initial read through their specific lens. This is fast, opinionated, and honest. Panelists should name specific slides, lines, or sections -- not speak in generalities. Genuine disagreement between panelists is expected and valuable. Don't smooth it over.

### Round 2: Structural Debate

Panelists engage with each other's observations. This is where disagreements get resolved or sharpened. Key areas to address:

- **Story arc** -- does the talk have a single narrative spine? Can the audience feel where they're going from slide 1 to the end?
- **Flow and transitions** -- are the gear changes between sections smooth or jarring?
- **Pacing** -- slide density vs. time, data overload vs. breathing room
- **Content accuracy** -- are claims sourced and defensible? Would a skeptic in the audience find holes?
- **Audience calibration** -- is the talk speaking to the actual audience or to a fantasy audience?
- **Tone consistency** -- does the register stay consistent or drift into corporate filler, lecture mode, or unnecessary hedging?

Panelists should reference each other by code (PE, SC, SME, etc.) when responding to or disagreeing with another panelist.

### Round 3: Consensus

After the debate, the panel converges on:

**Priority improvements** -- ranked list of specific changes, with rationale. Each item should name the slide or section and describe what to change. Keep to 5-8 items. More than that dilutes focus.

**Do not change** -- a short list (3-5 items) of what's already working well. This is equally important -- it prevents the speaker from "fixing" things that don't need fixing. Name specific lines, slides, or moments worth protecting.

## Output Format

Structure the output as:

```
## Expert Panel: [Talk Title]

**Panel:** [list panelists with codes and adaptive role descriptions]

### Round 1: First Impressions
[Each panelist, identified by code and role name]

### Round 2: Structural Debate
[Panelists engaging with each other]

### Round 3: Consensus

**Priority Improvements:**
[Numbered list, 5-8 items]

**Do Not Change:**
[Numbered list, 3-5 items]
```

## Step 5 (Optional): Apply Improvements

If the user asks to apply the improvements, work from the consensus Priority Improvements list top to bottom. For each item:

1. Make the targeted edit to the talk script (the specific slide, section, or speaker note named in the improvement).
2. After each edit, verify every item on the Do Not Change list survived intact. The Do Not Change list is a regression test -- if an improvement inadvertently damages a protected element, revert and find a different approach.
3. After all improvements are applied, update the Sources table if any new citations were introduced.

The critique and the apply step are separate acts. The panel produces the critique. The apply step executes it. If the user doesn't ask to apply, stop after delivering the panel output.

## Principles

- The panel's value comes from genuine disagreement, not unanimous praise. If every panelist agrees, something is wrong -- push harder.
- Every critique must name a specific slide, section, or line. "The middle section feels slow" is useless. "Slides 8-11 present four consecutive data charts with no breathing room -- merge or cut" is actionable.
- The Audience Advocate is the most important panelist. If the AA says the audience is lost or overwhelmed, that overrides everything else.
- Recent context from `/last30days:last30days` should inform critiques about whether the talk's framing and thesis are aligned with current industry thinking. Are there emerging arguments, shifts in consensus, or live debates the talk should engage with? Is the talk ahead of the conversation or repeating yesterday's framing? Use the context to sharpen the panel's perspective, not to audit footnotes.
- The panel does NOT produce a rewrite. It produces a critique. The speaker decides what to act on.
