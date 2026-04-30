---
description: Search conversation history for past user prompts, extract matching prompts, and analyze how Claude interprets different variations
---

# What Did I Say - Prompt History Analysis

Search your Claude Code conversation history to find and analyze your past prompts.

## Usage

```
/what-did-i-say <search-terms>
```

**Examples:**
- `/what-did-i-say create skill` - Find all prompts about creating skills
- `/what-did-i-say fix bug` - Find all prompts about fixing bugs
- `/what-did-i-say deploy` - Find all deployment-related prompts

## What This Does

1. **Searches** your conversation history in `~/.claude/projects/` using ripgrep
2. **Extracts** only the user prompts (not Claude's responses)
3. **Clusters** similar prompts together
4. **Analyzes** how Claude would interpret each variation differently
5. **Summarizes** the patterns and variations found

## Output Format

For each cluster of similar prompts:
- **Pattern**: The general intent/pattern
- **Variations**: Different phrasings you've used
- **Interpretation differences**: How Claude would understand each variation
- **Recommendations**: Clearest phrasing for your intent

## How It Works

The skill uses ripgrep to search through JSONL conversation files, extracting entries where:
- `type == "user"` (user messages only)
- `message.content` contains your search terms
- Content is actual text (not command output)

Then it analyzes the semantic differences and how they affect Claude's interpretation.

## Tips

- Use specific verbs: "create", "fix", "update", "explain"
- Search by domain: "skill", "agent", "deployment", "testing"
- Look for patterns: "how do I", "can you", "I need"
- Learn what works: Compare successful vs unclear prompts
