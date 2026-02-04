# Ralph Loops: Getting More From AI Coding Tools

---

## Agenda

1. What problem does this solve?
2. What is a Ralph Loop?
3. Extending the concept to your workflows

---

## The Problem: Context Rot

AI coding tools have a memory limit called a **context window**.

When that window gets too full, the AI starts forgetting earlier instructions.

---

### The Research

> "...models are better at using relevant information that occurs at the very beginning (primacy bias) or end of its input context (recency bias), and performance degrades significantly when models must access and use information located in the middle of its input context."

**Optimal utilization: 40-60% of the context window**

Going over this leads to what researchers call "lost in the middle."

---

### What This Looks Like in Practice

**Start of conversation:**
- AI understands your requirements clearly
- Produces accurate, relevant code

**After many exchanges:**
- AI "forgets" earlier requirements
- Code becomes inconsistent
- You spend time re-explaining things

---

## The Solution: Ralph Loops

A Ralph Loop gives each task a **fresh AI instance** with a clean context.

Instead of one long conversation, you get many focused ones.

---

### The Core Idea

```
┌────────────────────────────────────────────────────┐
│                                                    │
│   Task List ──► Fresh AI ──► Complete 1 Task       │
│       │              │              │              │
│       │              │              ▼              │
│       │              │        Update Progress      │
│       │              │              │              │
│       │              ▼              │              │
│       └──────── Next Iteration ◄────┘              │
│                                                    │
└────────────────────────────────────────────────────┘
```

Each iteration:
- Starts fresh (no accumulated context)
- Knows what's been done (reads progress file)
- Completes exactly one task
- Passes learnings forward

---

### How State Gets Passed

The **progress.txt** file acts as memory between iterations.

Each AI instance:
1. Reads progress.txt to understand what's done
2. Picks up where the last instance left off
3. Adds its own learnings before exiting

The AI forgets. The file remembers.

---

### The Script Is Simple

```bash
for i in {1..10}; do
  claude -p prompt.md
done
```

That's a Ralph Loop at its simplest: a bash loop running an AI tool repeatedly.

---

### A More Complete Version

```bash
MAX_ITERATIONS=10

for i in $(seq 1 $MAX_ITERATIONS); do
  OUTPUT=$(claude -p prompt.md)

  # Check if all tasks are complete
  if echo "$OUTPUT" | grep -q "COMPLETE"; then
    echo "All tasks finished!"
    exit 0
  fi
done
```

The loop continues until the AI signals completion or hits the max iterations.

---

## Extending the Concept

The power isn't just the loop—it's what you put in the prompt.

---

### The Prompt Template

Your prompt tells each iteration what to do:

```markdown
You are an automated coding agent.

Your Tasks:
1. Check tasks.json for unfinished tasks
2. Read progress.txt for past learnings
3. Implement ONE task
4. Run tests
5. Update tasks.json when complete
6. Add learnings to progress.txt
7. STOP - Next iteration handles the next task
```

---

### Why This Structure Works

| Step | Purpose |
|------|---------|
| Check tasks | Know what needs doing |
| Read progress | Learn from past iterations |
| Implement ONE | Stay focused, avoid context overload |
| Run tests | Verify before moving on |
| Update tasks | Track completion |
| Add learnings | Help future iterations |
| STOP | Prevent runaway execution |

---

### Customizing for Your Use Case

The prompt is fully customizable. Add steps for:

- Static analysis checks
- Code review criteria
- Documentation requirements
- Deployment steps
- Notification hooks

Since it loops, you only define the steps once.

---

## Real World Example: Building Features

### Step 1: Define Requirements (PRD Skill)

```bash
/prd Create a PRD for a mic monitoring app
```

The AI asks clarifying questions and generates a detailed spec.

---

### Step 2: Convert to Tasks (Ralph Skill)

```bash
/ralph convert @tasks/prd.md to prd.json
```

Breaks the PRD into right-sized user stories:

```json
{
  "stories": [
    {"id": "US-001", "title": "Project setup", "passes": false},
    {"id": "US-002", "title": "Settings manager", "passes": false},
    {"id": "US-003", "title": "Audio engine", "passes": false}
  ]
}
```

---

### Step 3: Run the Loop

```bash
./scripts/ralph/ralph.sh
```

Watch it work through each story:

```
═══════════════════════════════════════════════
  Ralph Iteration 1 of 10
═══════════════════════════════════════════════
US-001 complete. Initialized project, created requirements.txt...

═══════════════════════════════════════════════
  Ralph Iteration 2 of 10
═══════════════════════════════════════════════
US-002 complete. Implemented SettingsManager class...
```

---

### The Result

- Clean git history with atomic commits per story
- Each feature independently testable
- Progress is visible and resumable
- Works overnight or during meetings

---

## When to Use Ralph Loops

**Good fit:**
- Feature development with clear requirements
- Batch processing of similar tasks
- Overnight code generation
- Any workflow you can define as repeatable steps

**Not ideal for:**
- Exploratory prototyping
- Highly creative or ambiguous tasks
- Quick one-off fixes

---

## Key Takeaways

1. **Context windows have limits** — 40-60% is optimal, beyond that AI quality degrades

2. **Fresh instances beat long conversations** — Ralph Loops give each task a clean slate

3. **The concept is extensible** — Customize the prompt for any repeatable workflow

---

## Call to Action

The Ralph Loop is just a bash loop—something you learned early in your career.

Simple concepts can have large impact.

**Experiment with it.** What repetitive problems could you solve with a loop and a well-crafted prompt?

---

## Questions?

Resources:
- This repo: `ralph-explained`
- Similar tool: [Get Shit Done](https://github.com/glittercowboy/get-shit-done)
