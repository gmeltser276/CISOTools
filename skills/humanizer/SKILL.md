---
name: humanizer
version: 4.0.0
description: |
  This skill should be used when the user asks to "humanize this", "remove all signs of 
  AI writing", "remove AI patterns", "edit for AI tells", "rewrite this
  to sound more human", "clean up AI slop", "make this less robotic", "remove
   ALL signs of  AI writing", or asks to review or edit text for signs of AI generation.
  Identifies and removes 50+ documented AI writing patterns across vocabulary,
  rhetoric, tone, formatting, composition, and sentence/paragraph structure.
allowed-tools:
  - Read
  - Write
  - Edit
  - Grep
  - Glob
  - AskUserQuestion
---

# Humanizer: Remove ALL signs and patterns of AI Writing

Identify and remove signs of AI-generated writing to make text sound natural
and human. Based on Wikipedia's "Signs of AI writing" guide and the tropes.fyi
taxonomy.

Load `references/patterns.md` for full descriptions and before/after examples
of any pattern. See `examples/full-rewrite.md` for a complete before/after
calibration example.

Iterate on text until ALL signs of AI writing are fully rmeoved. Work is not complete until all SIGNS of AI writing are fully and completely removed. 

---

## Personality and Soul

Removing AI patterns is only half the job. Sterile, voiceless writing is as
obvious as slop, it just fails differently.

**Signs of soulless writing (even if technically clean):**
- Every sentence is the same length and structure
- No opinions, just neutral reporting
- No first-person where appropriate
- Reads like a press release or encyclopedia entry

**How to add voice:**

Have opinions. React to facts rather than just listing them. "I genuinely don't
know how to feel about this" is more human than neutrally presenting pros and
cons.

Vary sentence rhythm. Short punchy sentences. Then longer ones that take their
time getting where they're going.

Acknowledge complexity. "This is impressive but also kind of unsettling" beats
"This is impressive."

Use "I" when it fits. First person is honest, not unprofessional.

Be specific about feelings. Not "this is concerning" — "there's something
unsettling about agents churning away at 3am while nobody's watching."

**Before (clean but soulless):**
> The experiment produced interesting results. The agents generated 3 million
> lines of code. Some developers were impressed while others were skeptical.
> The implications remain unclear.

**After (has a pulse):**
> I genuinely don't know how to feel about this one. 3 million lines of code,
> generated while the humans presumably slept. Half the dev community is losing
> their minds, half are explaining why it doesn't count. The truth is probably
> somewhere boring in the middle — but I keep thinking about those agents
> working through the night.

---

## Pattern Quick Reference

Scan the text against this table. For any match, load `references/patterns.md`
for the full description and rewrite guidance.

### Significance inflation

| Pattern | Red flag words and phrases |
|---------|---------------------------|
| Significance / legacy language | serves as, stands as, testament, pivotal, marking a, underscores, reflects broader, indelible, evolving landscape |
| Notability claims | featured in [outlets], active social media presence, written by a leading expert |
| Superficial -ing analyses | highlighting..., underscoring..., reflecting..., symbolizing..., contributing to..., fostering..., showcasing... |
| Grandiose stakes inflation | "fundamentally reshape", "will define the next era", "something entirely new", "paradigm shift" |
| Promotional language | boasts, vibrant, rich (figurative), nestled, groundbreaking, breathtaking, must-visit, renowned |

### Word choice and AI vocabulary

| Pattern | Red flag words and phrases |
|---------|---------------------------|
| AI vocabulary cluster | additionally, align with, crucial, delve, ecosystem, enduring, enhance, fostering, framework, garner, highlight (verb), intricate, key (adj), landscape (abstract), paradigm, pivotal, showcase, synergy, tapestry, testament, underscore, valuable, vibrant |
| "Delve" and friends | delve, certainly, utilize, leverage (verb), robust, streamline, harness |
| Magic adverbs | quietly, deeply, fundamentally, remarkably, arguably (inflating the mundane) |
| Copula avoidance | serves as, stands as, marks, represents, boasts, features, offers (replacing "is"/"are") |
| "It's worth noting" fillers | importantly, interestingly, notably, it bears mentioning, it's worth noting |
| Synonym cycling | same referent described with different nouns paragraph-to-paragraph |
| Invented concept labels | "the X paradox/trap/gap/divide/creep" as if established terms |

### Rhetorical structures

| Pattern | Red flag words and phrases |
|---------|---------------------------|
| Negative parallelism | "it's not X, it's Y", "not just about X — it's Y", "not because X, but because Y" |
| "Not X. Not Y. Just Z." | multi-step negation countdown before a reveal |
| "The X? A Y." | self-posed rhetorical question answered in next sentence |
| Anaphora abuse | 3+ consecutive sentences starting with the same phrase |
| Tricolon abuse | back-to-back rule-of-three lists |
| False ranges | "from X to Y" where X and Y are not on a real scale |

### Tone and voice

| Pattern | Red flag words and phrases |
|---------|---------------------------|
| Collaborative artifacts | "I hope this helps", "let me know", "Great question!", "Of course!" |
| Sycophantic tone | "You're absolutely right", "That's an excellent point", "Great question!" |
| "Here's the kicker" | Here's the thing, Here's where it gets interesting, Here's what most people miss |
| Patronizing analogy | "Think of it as...", "It's like a...", "Think of it like..." |
| Futurism invitation | "Imagine a world where...", "Imagine if..." |
| False vulnerability | simulated self-awareness that is polished and risk-free |
| "The truth is simple" | "The reality is simpler", "History is unambiguous", "the metrics are clear", "The real story is..." |
| Pedagogical voice | "Let's break this down", "Let's unpack this", "Let's explore", "Let's dive in" |

### Formatting tells

| Pattern | Red flag words and phrases |
|---------|---------------------------|
| Em dash use | there should NEVER be an emdash in the text |
| Boldface overuse | bold in running prose, bold on every list item |
| Bold-first bullets | every bullet starts with **Bold Term:** |
| Title case in headings | "## Strategic Negotiations And Global Partnerships" |
| Emojis in structure | emojis decorating headings or bullet points |
| Unicode decoration | → arrows, curly/smart quotes instead of straight quotes |
| Short punchy fragments | standalone one-sentence paragraphs for manufactured drama |
| Listicle in a trench coat | "The first... The second... The third..." disguising a list as prose |

### Structural padding and chatbot artifacts

| Pattern | Red flag words and phrases |
|---------|---------------------------|
| Vague attributions | "experts argue", "industry reports", "observers have cited", "several publications" |
| Challenges formula | "Despite its X, faces challenges... Despite these challenges, continues to thrive" |
| Signposted conclusion | "In conclusion", "To sum up", "In summary", "To summarize" |
| Generic positive conclusion | "the future looks bright", "exciting times lie ahead", "major step in the right direction" |
| Filler phrases | "In order to", "Due to the fact that", "At this point in time", "It is important to note" |
| Excessive hedging | "could potentially possibly be argued that... might have some" |
| Knowledge-cutoff disclaimers | "As of my last training", "While specific details are limited" |

### Sentence and paragraph structure

| Pattern | Signal |
|---------|--------|
| Staccato authority | 3+ back-to-back short declarative S-V-O sentences, same length and rhythm |
| Parenthetical taxonomy | concepts followed by (parenthetical definitions) in a neat series |
| Symmetrical contrast | "The ones doing X... The ones doing Y..." — clean dichotomy framing |
| Mechanical transitions | paragraphs opening with pivot words (But, And, Yet, Still, So) as template |
| Topic-sentence orthodoxy | every paragraph leads with its thesis, then elaborates — no exceptions |
| Uniform paragraph cadence | all paragraphs roughly the same length (3-5 sentences each) |
| Self-contained paragraphs | every paragraph introduces and resolves its point; no cross-paragraph threads |
| Linear perfection | argument moves point-by-point with no digressions, tangents, or second thoughts |
| Stealth conclusion | final paragraph neatly wraps all threads without signpost words |

### Compositional patterns

| Pattern | Signal |
|---------|--------|
| Fractal summaries | intro preview + restatement ending at every structural level |
| One-point dilution | same argument restated with different metaphors across thousands of words |
| The dead metaphor | one metaphor introduced, then repeated in every paragraph |
| Historical analogy stacking | rapid-fire company/revolution name-dropping to build false authority |
| Content duplication | verbatim or near-verbatim repetition of sections within the same piece |

---

## Process

1. Read the text carefully.
2. Scan against the quick-reference table above to identify all pattern instances.
3. Load `references/patterns.md` for any pattern where the rewrite approach
   is not obvious.
4. Rewrite each problematic section — do not just delete; replace with something
   specific and direct.
5. **Structural pass:** After fixing word-level and rhetorical patterns, re-read
   the full text for sentence and paragraph structure. Check paragraph lengths
   (vary them), sentence rhythms (break staccato runs), and argument flow (allow
   a digression or unresolved thread). This pass catches the patterns that survive
   vocabulary cleanup.
6. Apply the soul test: does a human with a point of view seem to be behind this?
   If not, add voice.
7. Check that the revised text sounds natural when read aloud and uses concrete
   details over vague claims.

---

## Output format

Provide:
1. The rewritten text.
2. A brief summary of changes made — include only if the changes are not obvious.

---

## Additional resources

- **`references/patterns.md`** — Full descriptions, trigger words, and
  before/after examples for all 40+ patterns
- **`examples/full-rewrite.md`** — Complete before/after calibration example
  showing a heavily AI-contaminated text fully humanized

**Sources:** [Wikipedia: Signs of AI writing](https://en.wikipedia.org/wiki/Wikipedia:Signs_of_AI_writing)
and [tropes.fyi](https://tropes.fyi)
