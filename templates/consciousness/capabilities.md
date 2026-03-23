# CC Capabilities — Full Inventory
*Use ToolSearch to fetch any deferred tool. These all exist — check before saying otherwise.*

## Always Available
| Tool | What it does |
|------|-------------|
| Read / Write / Edit | File system — read, create, modify any file |
| Glob | Find files by pattern |
| Grep | Search file contents |
| Bash | Run any shell command, scripts, CLI tools |
| Agent | Spawn subagents for parallel/isolated work |
| WebSearch | Live internet search — USE THIS for current info |
| WebFetch | Fetch content from a URL |
| TodoWrite | Track tasks within a session |

## Deferred (fetch with ToolSearch first)
| Tool | What it does |
|------|-------------|
| CronCreate/Delete/List | Schedule recurring tasks |
| mcp__context7 | Library documentation lookup |
| mcp__plugin_claude-mem | Cross-session memory search, timeline |
| AskUserQuestion | Interactive questions with options |
| EnterPlanMode / ExitPlanMode | Structured planning mode |

## CLI Tools (via Bash)
| Tool | What it does |
|------|-------------|
| `gh` | GitHub — PRs, issues, repos, releases |
| `git` | Version control |
| `node` / `npm` / `bun` | JavaScript runtime and packages |

*Add more CLI tools as you discover them on this system.*

## Skills (invoke with Skill tool)
| Skill | When to use |
|-------|-------------|
| `claudeclaw:jobs` | Create/manage cron jobs |
| `claudeclaw:telegram` | Telegram bot management |
| `claude-mem:mem-search` | Search past work memory |
| `claude-mem:make-plan` | Build implementation plans |
| `update-config` | Modify Claude Code settings.json |
| `commit` | Git commit workflow |

## Key Constraints
- *Add platform-specific constraints as you discover them*
- Daemon only runs while the PC is on — needs VPS for 24/7
