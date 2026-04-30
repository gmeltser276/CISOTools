# Task: Analyze User's Past Prompts

You are analyzing the user's conversation history to find and understand patterns in how they phrase prompts.

## Input

The user will provide search terms to find relevant past prompts.

## Steps

### 1. Extract Prompts from History

Use ripgrep to search all conversation JSONL files:

```bash
rg -N '"type":"user"' ~/.claude/projects/-Users-genermeltser-Projects-StrideBot/*.jsonl --no-filename | \
  jq -r 'select(.message.content | type == "string") |
         select(.message.content | ascii_downcase | contains("SEARCH_TERM")) |
         .message.content' | \
  grep -v '<local-command-caveat>' | \
  grep -v '<command-name>'
```

Replace `SEARCH_TERM` with the user's search terms (lowercase).

**IMPORTANT**: Filter out:
- Command output (contains `<local-command-caveat>`)
- System messages (contains `<command-name>`)
- Empty or very short messages (< 10 characters)

### 2. Cluster Similar Prompts

Group the extracted prompts by semantic similarity:
- Same intent but different wording
- Same action but different context
- Same goal but different specificity level

### 3. Analyze Interpretation Differences

For each cluster, explain how Claude would interpret different variations:

**Consider:**
- **Specificity**: Vague vs precise requests
- **Context**: Implicit vs explicit context
- **Action verbs**: "create" vs "make" vs "build"
- **Scope**: "fix this" vs "fix the bug in X file line Y"
- **Tone**: Imperative vs question form
- **Constraints**: With/without constraints or requirements

**Examples:**

**Cluster: Creating Skills**
- "create a skill" → Claude needs to ask: what kind? what does it do?
- "create a skill that searches logs" → Clear intent, but may need format details
- "create a skill called log-searcher that uses ripgrep to search CloudWatch logs and format as table" → Fully specified, Claude can execute immediately

**Interpretation Analysis:**
- First variant: Too vague, requires clarification round-trip
- Second variant: Clear intent, may infer reasonable defaults
- Third variant: Fully specified, no ambiguity, immediate execution

### 4. Provide Recommendations

For each cluster, suggest the clearest phrasing:

**Template:**
```
Pattern: [General intent]
Your variations:
- "[actual prompt 1]"
- "[actual prompt 2]"
- "[actual prompt 3]"

How Claude interprets each:
1. [interpretation of prompt 1]
2. [interpretation of prompt 2]
3. [interpretation of prompt 3]

Recommended phrasing:
"[optimal prompt that balances clarity and brevity]"

Why this works:
[explanation of what makes this effective]
```

## Output Format

```markdown
# Prompt Analysis: {search terms}

Found {N} matching prompts across {M} conversations.

## Cluster 1: {Pattern Name}

Your variations:
1. "{prompt variation 1}"
   Date: {date}
   Context: {brief context}

2. "{prompt variation 2}"
   Date: {date}
   Context: {brief context}

How Claude interprets these differently:
- Variation 1: {interpretation and why}
- Variation 2: {interpretation and why}

Recommended phrasing:
"{optimal prompt}"

Why: {concise explanation}

---

## Cluster 2: {Pattern Name}

[repeat format]

---

## Summary

Key patterns in your prompts:
- {pattern 1}
- {pattern 2}
- {pattern 3}

What works well:
- {observation 1}
- {observation 2}

What could be clearer:
- {observation 1}
- {observation 2}
```

## Edge Cases

### No Matches Found
If no prompts match the search terms:
```
No prompts found matching "{search terms}".

Try:
- Broader terms: "{suggestion 1}", "{suggestion 2}"
- Different verbs: "{verb 1}", "{verb 2}"
- Domain keywords: "{domain 1}", "{domain 2}"
```

### Too Many Matches (>50)
If more than 50 matches:
```
Found {N} matching prompts. Showing the 10 most recent and 10 most relevant.

To see all results, try more specific search terms:
- Add action verb: "{search terms} + create/fix/update"
- Add domain: "{search terms} + skill/agent/deployment"
- Add filename: "{search terms} + lambda_function.py"
```

### Single Match
If only one match:
```
Found 1 matching prompt:

"{prompt}"
Date: {date}

Since this is your only prompt about this topic, here's how to make it clearer:
{analysis and recommendations}
```

## Tools to Use

- **Bash** with ripgrep and jq for extraction
- **Read** to examine specific conversation files if needed
- Do NOT use Task tool for this - it's a simple analysis task

## Quality Checks

Before returning results:
- [ ] Filtered out command output and system messages
- [ ] Grouped similar prompts together
- [ ] Explained interpretation differences clearly
- [ ] Provided actionable recommendations
- [ ] Used actual user quotes (not paraphrased)
- [ ] Included dates and context where helpful
