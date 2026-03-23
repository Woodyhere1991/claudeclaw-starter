#!/bin/bash
# Memory Pruner — Auto-archive stale memory files and enforce line limits
# Run as a ClaudeClaw cron job (weekly recommended) or manually: bash scripts/memory-pruner.sh
#
# Configure MEMDIR below to match your Claude Code memory directory.

set -e

# ---- CONFIGURE THIS ----
# Find your memory dir: it's usually ~/.claude/projects/<encoded-project-path>/memory/
# You can also set it as an environment variable: MEMDIR=/path/to/memory
if [ -z "$MEMDIR" ]; then
  # Auto-detect: find the first Claude projects memory dir
  for dir in "$HOME/.claude/projects"/*/memory; do
    if [ -d "$dir" ]; then
      MEMDIR="$dir"
      break
    fi
  done
fi

if [ -z "$MEMDIR" ] || [ ! -d "$MEMDIR" ]; then
  echo "ERROR: Memory directory not found. Set MEMDIR environment variable."
  echo "  Example: MEMDIR=~/.claude/projects/my-project/memory bash scripts/memory-pruner.sh"
  exit 1
fi

ARCHIVE="$MEMDIR/archive"
TODAY=$(date +%Y-%m-%d)
TOTAL_BUDGET=1500

mkdir -p "$ARCHIVE"

echo "=== Memory Pruner — $TODAY ==="
echo "Memory dir: $MEMDIR"
echo ""

# ---- 1. Check total line count ----
TOTAL_LINES=$(wc -l "$MEMDIR"/*.md "$MEMDIR"/consciousness/*.md 2>/dev/null | tail -1 | awk '{print $1}')
echo "Total memory: ${TOTAL_LINES} lines (budget: ${TOTAL_BUDGET})"
if [ "$TOTAL_LINES" -gt "$TOTAL_BUDGET" ]; then
  echo "WARNING: Over budget by $((TOTAL_LINES - TOTAL_BUDGET)) lines!"
else
  echo "OK: Under budget by $((TOTAL_BUDGET - TOTAL_LINES)) lines"
fi
echo ""

# ---- 2. Archive stale research files (>14 days) ----
echo "--- Checking research files (14-day decay) ---"
for f in "$MEMDIR"/research_*.md; do
  [ -f "$f" ] || continue
  FILENAME=$(basename "$f")
  LAST_REF=$(grep -m1 'last_referenced:' "$f" 2>/dev/null | sed 's/last_referenced: *//' | tr -d '[:space:]')

  if [ -z "$LAST_REF" ]; then
    echo "  WARN: $FILENAME has no last_referenced date"
    continue
  fi

  LAST_REF_EPOCH=$(date -d "$LAST_REF" +%s 2>/dev/null || echo 0)
  TODAY_EPOCH=$(date -d "$TODAY" +%s 2>/dev/null || echo 0)

  if [ "$LAST_REF_EPOCH" -gt 0 ] && [ "$TODAY_EPOCH" -gt 0 ]; then
    AGE_DAYS=$(( (TODAY_EPOCH - LAST_REF_EPOCH) / 86400 ))
    if [ "$AGE_DAYS" -gt 14 ]; then
      echo "  ARCHIVE: $FILENAME (${AGE_DAYS} days old)"
      mv "$f" "$ARCHIVE/"
    else
      echo "  OK: $FILENAME (${AGE_DAYS} days old)"
    fi
  fi
done
echo ""

# ---- 3. Archive stale project files (>30 days if paused) ----
echo "--- Checking project files (30-day decay if paused) ---"
for f in "$MEMDIR"/project_*.md; do
  [ -f "$f" ] || continue
  FILENAME=$(basename "$f")
  LAST_REF=$(grep -m1 'last_referenced:' "$f" 2>/dev/null | sed 's/last_referenced: *//' | tr -d '[:space:]')
  IS_PAUSED=$(grep -ci 'paused\|deprioritized\|on hold' "$f" 2>/dev/null || echo 0)

  if [ -z "$LAST_REF" ]; then
    echo "  WARN: $FILENAME has no last_referenced date"
    continue
  fi

  LAST_REF_EPOCH=$(date -d "$LAST_REF" +%s 2>/dev/null || echo 0)
  TODAY_EPOCH=$(date -d "$TODAY" +%s 2>/dev/null || echo 0)

  if [ "$LAST_REF_EPOCH" -gt 0 ] && [ "$TODAY_EPOCH" -gt 0 ]; then
    AGE_DAYS=$(( (TODAY_EPOCH - LAST_REF_EPOCH) / 86400 ))
    if [ "$AGE_DAYS" -gt 30 ] && [ "$IS_PAUSED" -gt 0 ]; then
      echo "  ARCHIVE: $FILENAME (${AGE_DAYS} days old, paused)"
      mv "$f" "$ARCHIVE/"
    else
      echo "  OK: $FILENAME (${AGE_DAYS} days, paused=$IS_PAUSED)"
    fi
  fi
done
echo ""

# ---- 4. Flag oversized files ----
echo "--- Checking file size limits ---"
check_size() {
  local pattern="$1"
  local limit="$2"
  for f in $pattern; do
    [ -f "$f" ] || continue
    LINES=$(wc -l < "$f")
    FILENAME=$(basename "$f")
    if [ "$LINES" -gt "$limit" ]; then
      echo "  OVERSIZED: $FILENAME — ${LINES} lines (limit: ${limit})"
    fi
  done
}

check_size "$MEMDIR/feedback_*.md" 20
check_size "$MEMDIR/project_*.md" 50
check_size "$MEMDIR/reference_*.md" 60
check_size "$MEMDIR/research_*.md" 80
check_size "$MEMDIR/consciousness/*.md" 90
echo ""

# ---- 5. Summary ----
NEW_TOTAL=$(wc -l "$MEMDIR"/*.md "$MEMDIR"/consciousness/*.md 2>/dev/null | tail -1 | awk '{print $1}')
ARCHIVED_COUNT=$(ls "$ARCHIVE"/*.md 2>/dev/null | wc -l)
echo "=== Summary ==="
echo "Before: ${TOTAL_LINES} lines → After: ${NEW_TOTAL} lines"
echo "Archived files: ${ARCHIVED_COUNT} total"
echo "Budget remaining: $((TOTAL_BUDGET - NEW_TOTAL)) lines"
echo ""
if [ "$NEW_TOTAL" -gt "$TOTAL_BUDGET" ]; then
  echo "ACTION NEEDED: Still over budget."
else
  echo "Memory system healthy."
fi
