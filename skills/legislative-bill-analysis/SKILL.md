---
name: legislative-bill-analysis
description: Use when analyzing legislative bills, proposed laws, executive orders, or regulatory frameworks that may affect state government operations, cybersecurity, or technology policy. Trigger on any request involving bill text, bill numbers, or legislative impact assessment.
---

# Legislative Bill Analysis

Structured analysis of legislation through dual lenses: general policy intent and CISO operational impact. Produces concise, decision-ready output.

## Workflow

### 1. Source the Bill Text

Obtain the full bill text before analysis. Prefer official sources:
- Your state legislature website (e.g. `cga.ct.gov` for Connecticut). If SSL fails, use `curl -skL` to fetch PDFs.
- Fallbacks: LegiScan, BillTrack50, TrackBill

Never analyze from summaries alone. Third-party AI summaries miss amendments to existing statutes, which often contain the most consequential changes.

### 2. Dispatch Comparison Agent (Background)

Launch a background agent to search for comparable legislation while you analyze. Agent instructions:
- Search for bills with similar subject matter in current and prior 2 legislative sessions
- Focus on passed laws (not just introduced) in comparator jurisdictions (e.g. neighboring states, CA, CO, IL, and EU)
- Note meaningful differences in scope, enforcement, and compliance requirements
- Report in under 200 words

### 3. Analyze and Output

Keep total output under 1500 words. Brevity forces prioritization.

## Output Format

### METADATA

Table: bill number, session, LCO number, committee, sponsors, effective date, current status, page count.

### SUMMARY

Two paragraphs max. What the bill does and who it affects. Plain language -- writable into an email to a commissioner.

### STATED INTENT

5-7 bullets mapped to section numbers. What the bill openly aims to accomplish.

### STRUCTURAL EFFECTS

5-7 bullets. Second-order consequences: compliance moats, power shifts, litigation surfaces, chilling effects, procurement gates, industry consolidation.

### AFFECTED PARTIES

Table mapping each obligated party to their duties and the sections that create them.

### EXISTING LAW CHANGES

Each statute amended, what it currently says, and what the bill changes. This is where consequential provisions hide.

### CISO IMPACT ASSESSMENT

Analyze across these domains. Skip any that genuinely don't apply. 1-2 sentences per domain with section references.

| Domain | What to assess |
|--------|---------------|
| Security tooling | EDR, SIEM, SOAR, insider threat, DLP, behavioral analytics, phishing simulation |
| Procurement | Approval gates, authorization requirements, vendor contract obligations |
| Workforce/HR intersection | Where security monitoring crosses into employment decisions |
| State agency obligations | What applies to your agency specifically vs. private sector only |
| Collective bargaining | Impact on deploying tools for unionized state employees |
| Data governance | Retention, disclosure, audit trail, bias audit recordkeeping |
| Public disclosure risk | Whether compliance creates information adversaries can exploit |
| Legal exposure | Private right of action, AG enforcement, discrimination claim surface |

### TIMELINE

Table of compliance deadlines, effective dates, audit windows, notice periods.

### RECOMMENDATION

2-3 sentences. Support, oppose, or amend -- with the specific provisions that drive the recommendation. Frame from CISO operational perspective.

### ACTION ITEMS

3-5 concrete next steps for BITS if this bill is likely to pass.

### COMPARABLE LEGISLATION

Incorporate comparison agent findings. 3-5 bullets comparing to similar laws in other jurisdictions.

## After Delivery

Offer testimony support as a follow-up:

> "Would you like me to prepare testimony talking points for this bill? I can draft points for support, opposition, or amendment recommendations aligned to your CISO position."

## Analysis Guidance

- Lead with what matters to a CISO, not what matters to a legislator.
- When a provision is ambiguous about whether security tools are covered, flag it -- ambiguity IS the risk.
- Always check for the "sleeper provision": the amendment to existing law buried late in the bill that has outsized impact.
- Don't editorialize in SUMMARY. Save judgment for STRUCTURAL EFFECTS and RECOMMENDATION.

## Attribution

Derived from danielmiessler/fabric `analyze_bill` pattern (MIT license).
Substantially rewritten for state CISO operational analysis.
