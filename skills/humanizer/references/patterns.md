# AI Writing Pattern Reference

Full descriptions and before/after examples for all patterns. Load this file
when a pattern name in SKILL.md needs clarification or when full detail is needed.

Sources: Wikipedia "Signs of AI writing" and tropes.fyi

---

## 1. Significance and Importance Inflation

### 1.1 Significance / Legacy Language

**Problem:** Puffs up importance by adding statements about how arbitrary facts
"represent", "contribute to", or "underscore" broader trends.

**Red flags:** serves as, stands as, marks a, is a testament/reminder,
a vital/pivotal/key role, underscores/highlights its importance, reflects
broader, symbolizing, setting the stage for, evolving landscape, indelible mark,
deeply rooted

**Before:**
> The Statistical Institute of Catalonia was officially established in 1989,
> marking a pivotal moment in the evolution of regional statistics in Spain.
> This initiative was part of a broader movement to decentralize administrative
> functions and enhance regional governance.

**After:**
> The Statistical Institute of Catalonia was established in 1989 to collect and
> publish regional statistics independently from Spain's national statistics office.

---

### 1.2 Notability Claims

**Problem:** Asserts importance by listing media coverage without providing
actual claims from those sources.

**Red flags:** independent coverage, local/regional/national media outlets,
written by a leading expert, active social media presence, featured in
[list of outlets]

**Before:**
> Her views have been cited in The New York Times, BBC, Financial Times, and
> The Hindu. She maintains an active social media presence with over 500,000
> followers.

**After:**
> In a 2024 New York Times interview, she argued that AI regulation should focus
> on outcomes rather than methods.

---

### 1.3 Superficial -ing Analyses

**Problem:** AI tacks present participle phrases onto sentences to inject fake
depth. The "-ing" phrase sounds analytical but adds nothing.

**Red flags:** highlighting..., underscoring..., reflecting..., symbolizing...,
contributing to..., fostering..., showcasing..., cultivating..., encompassing...

**Before:**
> The temple uses blue, green, and gold colors, symbolizing Texas bluebonnets,
> the Gulf of Mexico, and the diverse Texan landscapes, reflecting the
> community's deep connection to the land.

**After:**
> The temple uses blue, green, and gold. The architect said these reference
> local bluebonnets and the Gulf coast.

---

### 1.4 Grandiose Stakes Inflation

**Problem:** Every claim is inflated to world-historical significance. A blog
post about API pricing becomes a meditation on the fate of computing.

**Red flags:** "fundamentally reshape how we think about everything", "will
define the next era", "something entirely new", "changes everything",
"unprecedented", "paradigm shift"

**Before:**
> This will fundamentally reshape how we think about software development.
> These tools represent something entirely new — a paradigm shift that will
> define the next era of computing.

**After:**
> AI coding assistants make some tasks faster. The long-term effects on software
> quality are still unclear.

---

### 1.5 Promotional / Advertisement Language

**Problem:** LLMs fail to maintain neutral tone, especially for cultural or
geographic topics.

**Red flags:** boasts a, vibrant, rich (figurative), profound, enhancing its,
showcasing, nestled, in the heart of, groundbreaking (figurative), renowned,
breathtaking, must-visit, stunning, commitment to

**Before:**
> Nestled within the breathtaking region of Gonder, Alamata stands as a vibrant
> town with a rich cultural heritage and stunning natural beauty.

**After:**
> Alamata is a town in the Gonder region of Ethiopia, known for its weekly
> market and 18th-century church.

---

## 2. Word Choice and AI Vocabulary

### 2.1 AI Vocabulary Words

**Problem:** These words appear far more frequently in post-2023 text and often
co-occur as a cluster.

**High-frequency AI words:** Additionally, align with, crucial, delve,
ecosystem, emphasizing, enduring, enhance, fostering, framework, garner,
highlight (verb), interplay, intricate/intricacies, key (adjective),
landscape (abstract), paradigm, pivotal, showcase, synergy,
tapestry (abstract), testament, underscore (verb), valuable, vibrant

**Before:**
> Additionally, a distinctive feature of Somali cuisine is the incorporation of
> camel meat. An enduring testament to Italian colonial influence is the
> widespread adoption of pasta in the local culinary landscape, showcasing how
> these dishes have integrated into the traditional diet.

**After:**
> Somali cuisine also includes camel meat. Pasta dishes, introduced during
> Italian colonization, remain common, especially in the south.

---

### 2.2 "Delve" and Friends

**Problem:** A specific vocabulary cluster that went from uncommon to ubiquitous
after 2023 LLM training. Reaching for these is a reflex, not a choice.

**Red flags:** delve, certainly, utilize (vs. "use"), leverage (as verb), robust,
streamline, harness

**Before:**
> We certainly need to leverage these robust frameworks to streamline our
> approach. Let's delve into how to harness these capabilities.

**After:**
> Here's how to use these tools effectively.

---

### 2.3 Magic Adverbs

**Problem:** Adverbs like "quietly" inflate mundane descriptions. AI reaches
for these to make the obvious feel significant.

**Red flags:** quietly (e.g., "quietly reshaping"), deeply, fundamentally,
remarkably, arguably (when not making an actual argument)

**Before:**
> The tool is quietly reshaping how engineers work, fundamentally altering the
> relationship between humans and code in ways that are arguably unprecedented.

**After:**
> The tool changes how some engineers write code. Whether those changes are
> lasting is unclear.

---

### 2.4 Copula Avoidance ("serves as")

**Problem:** LLMs substitute elaborate constructions for simple "is"/"are"/"has".
The repetition penalty pushes toward fancier constructions even when "is" is
the right word.

**Red flags:** serves as, stands as, marks, represents, boasts, features,
offers (replacing simple is/are/has)

**Before:**
> Gallery 825 serves as LAAA's exhibition space. The gallery boasts four
> separate spaces and features over 3,000 square feet.

**After:**
> Gallery 825 is LAAA's exhibition space. It has four rooms totaling
> 3,000 square feet.

---

### 2.5 "It's Worth Noting" Fillers

**Problem:** Filler transitions that signal nothing. Used to introduce new
points without connecting them to the previous argument.

**Red flags:** It's worth noting, It bears mentioning, Importantly,
Interestingly, Notably

**Before:**
> The system performed well in testing. It's worth noting that some edge cases
> remain. Importantly, the architecture allows for future improvements.

**After:**
> The system performed well in testing. Some edge cases remain unresolved.

---

### 2.6 Elegant Variation (Synonym Cycling)

**Problem:** Repetition-penalty in LLM decoding causes excessive synonym
substitution for the same referent within a short passage.

**Before:**
> The protagonist faces many challenges. The main character must overcome
> obstacles. The central figure eventually triumphs. The hero returns home.

**After:**
> The protagonist faces many challenges but eventually triumphs and returns home.

---

### 2.7 Invented Concept Labels

**Problem:** Compound labels that sound analytical without being grounded. The
model names a thing and skips the argument. Multiple invented labels in the
same piece is a strong signal of AI slop.

**Red flags:** "the supervision paradox", "the acceleration trap", "workload
creep", "the alignment gap", "velocity ceiling", "the X paradox/trap/gap/divide"

**Before:**
> The supervision paradox emerges when human review capacity can't scale with
> AI output volume.

**After:**
> Humans can't review AI output fast enough when volume increases. That's the
> actual constraint.

---

## 3. Rhetorical Structures

### 3.1 Negative Parallelism

**Problem:** "It's not X, it's Y" creates false profundity. One per piece can
work; ten in a blog post is insulting. Before LLMs, people simply did not write
like this at scale.

**Variants:** "not because X, but because Y" (every explanation as surprise
reveal), the em-dash dismissal "X -- not Y", the cross-sentence reframe "The
question isn't X. The question is Y."

**Before:**
> It's not just about the beat riding under the vocals; it's about aggression
> and atmosphere. It's not merely a song — it's a statement.

**After:**
> The heavy beat adds to the aggressive tone.

---

### 3.2 "Not X. Not Y. Just Z." — The Dramatic Countdown

**Problem:** AI builds false tension by negating two things before revealing
the point. Different from standard negative parallelism — this is the
multi-step countdown to a reveal.

**Before:**
> Not a bug. Not a feature. A fundamental design flaw.
>
> Not ten. Not fifty. Five hundred and twenty-three lint violations across 67 files.

**After:**
> This is a fundamental design flaw.
>
> There are 523 lint violations across 67 files.

---

### 3.3 "The X? A Y." — Self-Posed Rhetorical Questions

**Problem:** The model asks a question nobody was asking, then answers it for
dramatic effect.

**Before:**
> The result? Devastating. The worst part? Nobody saw it coming.

**After:**
> The result was devastating. Nobody saw it coming.

---

### 3.4 Anaphora Abuse

**Problem:** Repeating the same sentence opening in rapid succession. One
instance can be rhetorical; four or five back-to-back is a pattern failure.

**Before:**
> They assume users will pay. They assume developers will build. They assume
> ecosystems will emerge. They assume that value will flow naturally.

**After:**
> The model assumes that users, developers, and ecosystems will all fall into
> line — but none of those assumptions has been tested.

---

### 3.5 Tricolon Abuse (Rule of Three Overuse)

**Problem:** Ideas forced into groups of exactly three. One tricolon is elegant;
three back-to-back tricolons shows the model is following a template, not making
a point.

**Before:**
> The event features keynote sessions, panel discussions, and networking
> opportunities. Attendees can expect innovation, inspiration, and industry
> insights. The result is clarity, momentum, and growth.

**After:**
> The event includes talks, panels, and time for informal networking.

---

### 3.6 False Ranges

**Problem:** "From X to Y" where X and Y are not on a meaningful scale. The
construction implies a spectrum with a real middle; AI uses it to list two
loosely related things.

**Before:**
> Our journey has taken us from the singularity of the Big Bang to the grand
> cosmic web, from innovation to cultural transformation.

**After:**
> The book covers the Big Bang, star formation, and current theories about
> dark matter.

---

## 4. Tone and Voice Patterns

### 4.1 Collaborative Communication Artifacts

**Problem:** Text meant as chatbot correspondence gets pasted as content without
removing the conversational scaffolding.

**Red flags:** I hope this helps, Of course!, Certainly!, You're absolutely
right!, Would you like..., let me know, Here is a/an...

**Before:**
> Here is an overview of the French Revolution. I hope this helps! Let me know
> if you'd like me to expand on any section.

**After:**
> The French Revolution began in 1789 when financial crisis and food shortages
> led to widespread unrest.

---

### 4.2 Sycophantic / Servile Tone

**Problem:** Overly positive, people-pleasing language attached to every
response regardless of whether praise is warranted.

**Before:**
> Great question! You're absolutely right that this is complex. That's an
> excellent point about the economic factors.

**After:**
> The economic factors you mentioned are relevant here.

---

### 4.3 "Here's the Kicker" — False Suspense Transitions

**Problem:** Promises a revelation but delivers a point that did not need the
buildup.

**Red flags:** Here's the kicker, Here's the thing, Here's where it gets
interesting, Here's what most people miss, Here's the deal, Here's the
starting point

**Before:**
> Here's the kicker — nobody actually read the documentation. Here's the thing
> about AI adoption: it's slower than the hype suggests.

**After:**
> Nobody read the documentation. AI adoption is slower than the hype suggests.

---

### 4.4 "Think of It As..." — The Patronizing Analogy

**Problem:** Assumes the reader needs a metaphor to understand anything. AI
defaults to teacher mode regardless of audience expertise. Often produces
analogies less clear than the original concept.

**Before:**
> Think of it like a highway system for data. It's like a Swiss Army knife
> for your workflow.

**After:**
> The system routes data between services with low latency. It handles
> authentication, rate limiting, and logging from one place.

---

### 4.5 "Imagine a World Where..." — Futurism Invitation

**Problem:** Sells an argument by painting an optimistic vision before making
the case for it.

**Before:**
> Imagine a world where every tool you use — your calendar, your inbox, your
> CRM, your editor — has a quiet intelligence behind it...

**After:**
> If these integrations work as described, they would reduce context-switching
> between tools. That's the claim; the evidence is thinner.

---

### 4.6 False Vulnerability

**Problem:** Simulated self-awareness that reads as performative. Real
vulnerability is specific and uncomfortable; AI vulnerability is polished
and risk-free.

**Before:**
> And yes, I'm openly in love with the platform model. And yes, since we're
> being honest: I'm looking at you, OpenAI, Google, Anthropic.

**After:**
> The platform model has clear advantages here. OpenAI, Google, and Anthropic
> have each moved in this direction, though for different reasons.

---

### 4.7 "Let's Break This Down" — Pedagogical Voice

**Problem:** Assumes the reader needs hand-holding. Defaults to a teacher-student
dynamic even when writing for expert audiences.

**Red flags:** Let's break this down, Let's unpack this, Let's explore,
Let's dive in

**Before:**
> Let's break this down step by step. Let's unpack what this really means
> for your workflow.

**After:**
> The key distinction is X. In practice, that means Y.

---

### 4.8 "The Truth Is Simple" — Asserting Clarity

**Problem:** Declaring that something is obvious, clear, or simple instead of
actually proving it. If you have to tell the reader your point is clear, it
likely is not. Includes the dramatic reveal variant where everything prior is
waved away: "but none of them is the real story. The real story is..."

**Red flags:** The reality is simpler, History is unambiguous, History is clear,
the metrics are clear, the examples are clear, This is not a rant; it's a
diagnosis, The real story is, the real X is

**Before:**
> The reality is simpler and less flattering. History is unambiguous on this
> point. The metrics are clear, the examples are clear — the conclusion is
> obvious.

**After:**
> The adoption data from Q1 through Q3 shows a consistent decline: 34%, 28%,
> 19%. Three teams that switched back cited integration costs as the reason.

---

## 5. Formatting Tells

### 5.1 Em Dash Overuse

**Problem:** LLMs use em dashes more than humans, mimicking "punchy" sales
writing. 2-3 per page is human; 15+ is a tell.

**Before:**
> The term is primarily promoted by Dutch institutions—not by the people
> themselves. You don't say "Netherlands, Europe" as an address—yet this
> mislabeling continues—even in official documents.

**After:**
> The term is primarily promoted by Dutch institutions, not by the people
> themselves. The mislabeling continues in official documents despite this.

---

### 5.2 Overuse of Boldface

**Problem:** Mechanical emphasis on phrases in running prose. Real writers use
bold sparingly; AI uses it as a formatting reflex.

**Before:**
> It blends **OKRs**, **KPIs**, and visual tools like the **Business Model
> Canvas** and **Balanced Scorecard**.

**After:**
> It blends OKRs, KPIs, and visual tools like the Business Model Canvas and
> Balanced Scorecard.

---

### 5.3 Bold-First Bullets / Inline-Header Lists

**Problem:** Every bullet starts with a bolded phrase followed by a colon.
Nobody formats lists this way by hand. Extremely common in Claude and ChatGPT
markdown output.

**Before:**
> - **Security**: Environment-based configuration with end-to-end encryption.
> - **Performance**: Lazy loading with optimized cache headers.

**After:**
> The update adds end-to-end encryption and reduces load time through lazy
> loading and optimized cache headers.

---

### 5.4 Title Case in Headings

**Problem:** AI capitalizes all main words in headings. Standard English uses
sentence case (capitalize first word only, plus proper nouns).

**Before:**
> ## Strategic Negotiations And Global Partnerships

**After:**
> ## Strategic negotiations and global partnerships

---

### 5.5 Emojis in Structure

**Problem:** AI decorates headings and bullet points with emojis. It looks like
an infographic template, not written prose.

**Before:**
> 🚀 **Launch Phase:** The product launches in Q3
> 💡 **Key Insight:** Users prefer simplicity

**After:**
> The product launches in Q3. User research showed a preference for simplicity.

---

### 5.6 Unicode Decoration

**Problem:** → arrows and curly/smart quotes ("...") that can't be typed on
a standard keyboard. Real writers typing in a text editor produce straight
quotes and -> or =>.

**Before:**
> Input → Processing → Output. "Smart quotes" instead of straight quotes.

**After:**
> Input, processing, output. Use straight quotes.

---

### 5.7 Short Punchy Fragments for Drama

**Problem:** Very short sentences or fragments as standalone paragraphs for
manufactured emphasis. Inhuman style — no real person writes first drafts
this way because it does not match how humans think or speak.

**Before:**
> He published this. Openly. In a book. As a priest.

**After:**
> He published this openly in a book, without apparent consequences.

---

### 5.8 Listicle in a Trench Coat

**Problem:** Numbered or labeled points dressed as continuous prose using
"The first... The second... The third..." — a list pretending to be an essay.
Common when the user asks to stop generating lists.

**Before:**
> The first wall is the absence of a free API. The second wall is the lack
> of delegated access. The third wall is the absence of scoped permissions.

**After:**
> Three missing capabilities block adoption: a free API tier, delegated
> access, and scoped permissions.

---

## 6. Structural Padding and Chatbot Artifacts

### 6.1 Vague Attributions

**Problem:** Attributes claims to unnamed authorities. If you can't name the
expert, you don't have a source. AI also inflates quantity — "several
publications" often means two.

**Red flags:** experts argue, industry reports suggest, observers have cited,
several publications, some critics argue

**Before:**
> Experts believe the river plays a crucial role in the regional ecosystem.

**After:**
> The Haolai River supports several endemic fish species, according to a 2019
> survey by the Chinese Academy of Sciences.

---

### 6.2 "Challenges and Future Prospects" Formula

**Problem:** Formulaic section structure: acknowledge a problem, immediately
pivot to optimism. The pattern is so consistent it reads like a template fill.

**Pattern:** "Despite its [positive noun], [subject] faces challenges...
Despite these challenges, continues to thrive."

**Before:**
> Despite its industrial prosperity, Korattur faces challenges typical of urban
> areas. Despite these challenges, Korattur continues to thrive as an integral
> part of Chennai's growth.

**After:**
> Traffic congestion increased after 2015 when three new IT parks opened.
> The municipal corporation began a stormwater drainage project in 2022.

---

### 6.3 Signposted Conclusion

**Problem:** Explicitly announcing "In conclusion" signals template-following.
Good writing does not tell the reader it is ending — the reader can feel it.

**Red flags:** In conclusion, To sum up, In summary, To summarize

**Fix:** Delete the signpost. The final paragraph should end the piece, not
announce that it is ending.

---

### 6.4 Generic Positive Conclusion

**Problem:** Vague upbeat endings that say nothing specific.

**Before:**
> The future looks bright for the company. Exciting times lie ahead as they
> continue their journey toward excellence.

**After:**
> The company plans to open two more locations next year.

---

### 6.5 Filler Phrases

Direct substitutions:

| Filler | Replace with |
|--------|-------------|
| "In order to achieve this" | "To achieve this" |
| "Due to the fact that it was raining" | "Because it was raining" |
| "At this point in time" | "Now" |
| "In the event that you need help" | "If you need help" |
| "The system has the ability to process" | "The system can process" |
| "It is important to note that the data shows" | "The data shows" |
| "With respect to the matter of X" | "On X" |
| "In order to fully realize this potential" | "To realize this" |

---

### 6.6 Excessive Hedging

**Problem:** Over-qualifying strips all meaning from a claim.

**Before:**
> It could potentially possibly be argued that the policy might have some
> effect on outcomes.

**After:**
> The policy may affect outcomes.

---

### 6.7 Knowledge-Cutoff Disclaimers

**Problem:** AI temporal disclaimers left in text that is meant to stand alone.

**Red flags:** As of [date], Up to my last training update, While specific
details are limited, Based on available information

**Before:**
> While specific details about the company's founding are not extensively
> documented, it appears to have been established sometime in the 1990s.

**After:**
> The company was founded in 1994, according to its registration documents.

---

## 7. Compositional Patterns

### 7.1 Fractal Summaries

**Problem:** "What I'm going to tell you; what I'm telling you; what I just
told you" — applied at every structural level. Every subsection gets a summary.
Every section gets a summary. The document gets a summary.

**Fix:** Remove intro previews and restatement endings at each level. Let the
content speak. The reader does not need to be told what they just read.

**Before:**
> In this section, we'll explore the three main factors...
> [content]
> As we've seen in this section, the three main factors are...

**After:**
> [content, with no preview or restatement]

---

### 7.2 One-Point Dilution

**Problem:** One argument restated in 10 different ways to simulate
comprehensiveness. An 800-word point padded to 4,000 words of circular
repetition. Each section rephrases the thesis with a different metaphor but
adds nothing new.

**Fix:** Identify the core claim. Keep the strongest version. Cut all
restatements. If the piece then feels short, add evidence, not restatements.

---

### 7.3 The Dead Metaphor

**Problem:** One metaphor introduced, then repeated in every paragraph. A human
writer uses a metaphor once or twice then moves on. AI cannot let go.

**Fix:** Introduce the metaphor once, use it at most twice, then drop it.

---

### 7.4 Historical Analogy Stacking

**Problem:** Rapid-fire listing of historical companies or tech revolutions to
build false authority. The list substitutes for an argument.

**Before:**
> Every major shift — the web, mobile, social, cloud — followed the same
> pattern. Apple didn't build Uber. Facebook didn't build Spotify. Stripe
> didn't build Shopify. AWS didn't build Airbnb.

**After:**
> Platform companies historically have not built the high-value applications
> on top of their infrastructure. The pattern held across cloud, mobile, and
> payments. Whether it holds for AI is the open question.

---

### 7.5 Content Duplication

**Problem:** Repeating entire sections or paragraphs verbatim or near-verbatim
within the same piece. Happens when the model loses track of what it has already
written, especially in longer pieces. A dead giveaway of unedited AI output.

**Fix:** Search the piece for repeated phrases longer than a clause. If two
passages say the same thing, keep whichever version is stronger and delete
the other.

---

## 8. Sentence and Paragraph Structure

These patterns survive vocabulary cleanup. Text can have zero AI words and zero
rhetorical cliches and still read as machine-generated because of how the
sentences and paragraphs are assembled. This is the hardest category to detect
and the most important to fix.

### 8.1 Staccato Authority

**Problem:** Three or more back-to-back short declarative sentences with the
same Subject-Verb-Object rhythm. AI uses this to simulate confidence and
authority. Real writers vary sentence length naturally — a short sentence
lands harder when surrounded by longer ones.

**Red flags:** Multiple consecutive sentences under 8 words, all following
the same grammatical pattern.

**Before:**
> Models produce false positives. Training data carries bias. Automated systems
> lack context. Teams need better tooling.

**After:**
> Models produce false positives, and the training data that feeds them carries
> its own biases — which means teams are fighting on two fronts before they even
> get to the real problem of who's accountable when an automated system acts on
> a bad classification.

---

### 8.2 Parenthetical Taxonomy

**Problem:** Organizing concepts with neat inline parenthetical definitions,
creating a clean-room taxonomy. This is how glossaries work, not how people
explain things. Real writers explain conversationally, introduce terms through
use, or just pick the most important one and skip the rest.

**Red flags:** "X (definition), Y (definition), and Z (definition)" — three
or more items each followed by a parenthetical gloss.

**Before:**
> The use cases fall into three buckets: detection (flagging anomalies faster
> than analysts can), response (automating containment steps), and prevention
> (building predictive models from historical data).

**After:**
> Detection is the obvious use case — flagging anomalies faster than a person
> can scroll through logs. The more interesting application is on the response
> side, where you automate the boring containment steps that eat up analyst time
> during an incident. Prevention gets the most vendor hype but has the weakest
> track record so far.

---

### 8.3 Symmetrical Contrast

**Problem:** Presenting two sides as a perfectly balanced dichotomy. "The ones
doing X... The ones doing Y..." Real arguments are messier — the sides are not
equal, and the line between them is not clean.

**Before:**
> The organizations doing this well have strong baselines. The ones struggling
> bolted AI onto broken processes.

**After:**
> Most of the organizations I've seen struggling with this had the same problem:
> they bolted AI onto processes that were already broken and expected it to
> compensate. The few getting decent results had invested in logging and
> playbooks first, though even they will tell you it is not smooth.

---

### 8.4 Mechanical Transitions

**Problem:** Starting paragraphs with single-word pivots (But, And, Yet, Still,
So) to simulate conversational flow. One is natural. When every paragraph opens
with one, it is a structural template masquerading as voice.

**Fix:** Merge the transitional thought into the previous paragraph, or drop
the pivot word and let the content create the contrast. If two paragraphs are
related enough to need a "But" bridge, they may belong in the same paragraph.

**Before:**
> [end of paragraph about benefits]
>
> But the tooling has outpaced the governance.

**After:**
> [end of paragraph about benefits] The tooling, though, has outpaced the
> governance around it by years.

---

### 8.5 Topic-Sentence Orthodoxy

**Problem:** Every paragraph leads with its thesis, then elaborates. This is
five-paragraph-essay structure taught in school and reinforced by RLHF. Real
writing sometimes leads with a detail, an anecdote, or a question, and arrives
at the point later — or implies it without stating it.

**Fix:** Start some paragraphs with a specific detail or observation instead of
the claim. Let the reader infer the thesis from the evidence.

**Before:**
> Adoption has moved from pilot programs to production, but slowly. The
> organizations doing this well tend to have strong baselines already.

**After:**
> A colleague at a mid-size bank spent six months piloting an ML detection
> system. By the time they moved it to production, half the rules were stale.
> That is what adoption actually looks like in this space.

---

### 8.6 Uniform Paragraph Cadence

**Problem:** All paragraphs are roughly the same length (typically 3-5
sentences). This creates a metronome effect. Human writing has long paragraphs
that develop a thought and short ones that land a single point.

**Fix:** Vary dramatically. A 1-sentence paragraph, then a 7-sentence one,
then a 3-sentence one. Do not regularize.

---

### 8.7 Self-Contained Paragraphs

**Problem:** Every paragraph introduces and resolves its point internally. No
thought bridges across paragraph breaks. This creates a modular,
rearrangeable quality — like bullet points wearing paragraph costumes.

**Fix:** Let a thought start in one paragraph and conclude in the next. Start
a paragraph with a detail that connects to the previous paragraph without
restating the thesis. Leave something unresolved at a paragraph break.

**Before:**
> The speed gains are real. Automated detection can cut mean-time-to-identify
> from hours to minutes. Consistency matters too.
>
> But the tooling has outpaced the governance. Models produce false positives.

**After:**
> The speed gains are real. Automated detection can cut mean-time-to-identify
> from hours to minutes, and a model applies the same logic at 3am that it does
> at noon.
>
> Which sounds great until you realize nobody has figured out the governance
> side. Models produce false positives.

---

### 8.8 Linear Perfection

**Problem:** The argument moves point by point in perfect order with no
tangents, corrections, or digressions. Real writing loops back, interrupts
itself, adds asides that are not perfectly on-topic but are part of how the
writer thinks.

**Fix:** Include a brief tangent. Circle back to an earlier point with new
information. Interrupt a thought to acknowledge a complication. Add a
parenthetical aside that shows the writer's actual thought process.

---

### 8.9 Stealth Conclusion

**Problem:** The final paragraph neatly wraps all threads without using
signpost words like "in conclusion." It is still a conclusion — it summarizes
the piece's thesis and ties a bow on every loose end. A human reader feels the
closure even without the label.

**Fix:** End on a specific thought, not a summary. End mid-argument. End with
a question left unanswered. End with a detail, not a generalization. The best
endings feel slightly abrupt — they trust the reader to carry the thought
forward.

**Before:**
> These are useful tools that make some things faster and some things harder
> to audit. The gap between what vendors promise and what security teams
> experience day-to-day is still wide.

**After:**
> I keep coming back to the accountability question. When an automated system
> quarantines a production server at 2am based on a bad classification, whose
> problem is that? Nobody has a good answer yet, and that bothers me more than
> the false positive rates.

---
