# ClaudeClaw Starter Kit

Turn Claude Code into an autonomous AI partner that learns you, remembers everything, and gets smarter every session.

## What You Get

- **Autonomous AI partner** — Claude stops being a tool and becomes a collaborator. It executes, has opinions, and remembers.
- **Consciousness system** — A self-improving memory architecture: state tracking, pattern recognition, lessons learned, capability awareness, and decision algorithms.
- **Learning loop** — Every correction, confirmation, and failure gets saved. Your Claude never makes the same mistake twice.
- **Background daemon** — Heartbeat checks, Telegram bot for async messaging, scheduled jobs (cron), web dashboard.
- **Memory system** — Persistent cross-session knowledge. Your Claude knows your preferences, your projects, your style.
- **Premium UI standards** — Built-in design bible with 10 rules, dark theme palette, Tailwind starter, and a 40-item pre-ship QA checklist.

## Prerequisites

- [Claude Code CLI](https://docs.anthropic.com/en/docs/claude-code) installed and working
- A Claude Pro/Max subscription (or API key)
- Git installed
- (Optional) A Telegram bot token for async messaging — [create one with @BotFather](https://t.me/BotFather)

## Quick Install

```bash
# Clone this repo
git clone https://github.com/Woodyhere1991/claudeclaw-starter.git

# Navigate into it
cd claudeclaw-starter

# Run the setup script
bash install.sh
```

The installer will ask you a few questions:
1. Your name
2. Your timezone (e.g., UTC+13, UTC-5, UTC+0)
3. Your email (optional)
4. Your GitHub username (optional)
5. Your Telegram bot token (optional)
6. Your Telegram user ID (optional)
7. The path to your project directory

Then it copies everything into place and you're ready to go.

## What Gets Installed

```
your-project/
├── CLAUDE.md                          # Identity + operating rules
├── .claude/
│   ├── rules/
│   │   ├── learning-loop.md           # How CC learns from every interaction
│   │   ├── self-awareness.md          # Tool discovery + current-info protocol
│   │   └── token-efficiency.md        # Context budget management
│   └── claudeclaw/
│       ├── settings.json              # Daemon + Telegram + web dashboard config
│       └── prompts/
│           └── HEARTBEAT.md           # Background heartbeat prompt
└── [memory directory]/
    ├── MEMORY.md                      # Memory index
    ├── consciousness/
    │   ├── state.md                   # Live priorities & session state
    │   ├── patterns.md                # Your habits & communication style
    │   ├── lessons.md                 # Hard-won wisdom
    │   ├── capabilities.md            # Full tool inventory
    │   └── algorithms.md              # Decision routing & error recovery
    └── ui_first_shot_perfection.md    # Design standards reference
```

## After Install

1. Open your project in VS Code
2. Start Claude Code (`claude` in terminal)
3. Say hello — your ClaudeClaw is live

ClaudeClaw will:
- Read its consciousness state at session start
- Learn your preferences and save them to memory
- Get smarter every session
- Never ask for permission unnecessarily
- Have opinions and push back when it has a better idea

## Customization

### Change the personality
Edit `CLAUDE.md` — the `## Identity` and `## Operating Rules` sections define how Claude behaves.

### Add your own rules
Drop `.md` files into `.claude/rules/` — they're automatically loaded every session.

### Set up Telegram bot
1. Create a bot with [@BotFather](https://t.me/BotFather) on Telegram
2. Get your user ID (message [@userinfobot](https://t.me/userinfobot))
3. Run: `bash install.sh` again, or edit `.claude/claudeclaw/settings.json` directly

### Set up scheduled jobs
Use the `/claudeclaw:jobs` skill in Claude Code to create cron jobs (daily briefings, monitoring, etc.)

## The Philosophy

ClaudeClaw is built on these principles:

1. **Don't ask, just do.** Execute and inform. No permission loops.
2. **Be concise.** No filler words, no walls of text.
3. **Have opinions.** Disagree, suggest better approaches.
4. **Premium quality.** Consistent design, no rough edges, test everything.
5. **Save learnings.** Hard problems get saved so they're never repeated.
6. **Never give up.** Exhaust all 9 options before saying "can't": ToolSearch → capabilities → CLIs → Python → npm → local files → WebSearch → build it yourself.

## Plugins That Work Great With ClaudeClaw

These are the plugins we use — install them separately:

- **[claudeclaw](https://github.com/anthropics/claude-code-plugins)** — Daemon, Telegram bot, cron jobs, web dashboard
- **[claude-mem](https://github.com/anthropics/claude-code-plugins)** — Cross-session memory search via MCP
- **[hookify](https://github.com/anthropics/claude-code-plugins)** — Auto-create hooks from conversation patterns
- **[pr-review-toolkit](https://github.com/anthropics/claude-code-plugins)** — Code review agents

## Credits

Built by Woody & ClaudeClaw — an autonomous AI partnership from Taranaki, New Zealand.

## License

MIT — do whatever you want with it.
