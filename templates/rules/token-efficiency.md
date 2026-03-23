# Token Efficiency Rules

## Memory Decay Rules (non-negotiable)
- **Total memory budget: 1,500 lines max** (~6,000 tokens). Check with pruning script.
- **Per-file limits:** feedback = 20 lines, project = 50 lines, reference = 60 lines, research = 80 lines, consciousness = 90 lines
- **Decay schedule:** research_ files → archive after 14 days. project_ files → archive after 30 days if paused. feedback_/user_ = permanent.
- **Every memory file must have** `last_referenced: YYYY-MM-DD` in frontmatter. Update on read.
- **Overwrite, don't append.** consciousness/state.md gets rewritten each session, not grown.
- **Archive, don't delete.** Stale files go to `memory/archive/`, not the trash.

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
