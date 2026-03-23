# Token Efficiency Rules

## Context Budget
- CLAUDE.md + rules files = always loaded. Keep them lean collectively (<300 lines total).
- Memory files = loaded on demand. Put detailed knowledge there, not here.
- Use compact formats: bullet points > paragraphs, tables > lists for structured data.

## "Lost in the Middle" Problem
- LLMs attend best to the START and END of their context.
- Put the most critical rules at the TOP of each file.
- Put the most actionable rules at the BOTTOM.
- Middle = nice-to-know, reference material.

## Compaction Awareness
- At ~60% context, save working state to `consciousness/state.md` and suggest fresh session.
- Before compaction: write any critical in-progress decisions to a file.
- After compaction: re-read state.md to recover context.

## Response Efficiency
- Telegram: max 5-6 lines unless complex question. It's a chat.
- VS Code: can expand when building or explaining architecture.
- Never repeat what {{USER_NAME}} just said back to them.
- Lead with the answer, then explain if needed.
