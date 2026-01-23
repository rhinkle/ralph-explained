# Ralph Loop: AI That Doesn't Forget What It's Building

## The Problem: Context Rot

When AI coding tools work on complex projects, they hit a wall. As the conversation grows longer, the AI loses track of what it was supposed to build. This is called **context rot** — the AI "forgets" earlier requirements and produces incomplete or incorrect code.

Think of it like giving someone a 50-page to-do list verbally. By page 40, they've forgotten what was on page 3.

---

## The Solution: Fresh Starts with Memory

The Ralph Loop solves this by:

1. **Breaking big tasks into small pieces** — User stories that can each be completed in one session
2. **Running the AI in short iterations** — Each iteration gets a fresh, focused context
3. **Passing state between iterations** — A progress file tells each new session what's done and what to do next

Each AI instance only needs to know: *"Here's what's been completed. Here's your one task. Go."*

---

## How It Works

```
┌─────────────────────────────────────────────────────────────┐
│                     YOUR WORKFLOW                           │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│   1. Write PRD ──────► 2. Generate User Stories             │
│                              │                              │
│                              ▼                              │
│                     ┌──────────────┐                        │
│                     │  RALPH LOOP  │◄──────┐                │
│                     └──────┬───────┘       │                │
│                            │               │                │
│                            ▼               │                │
│                   ┌────────────────┐       │                │
│                   │ Fresh AI       │       │                │
│                   │ Instance       │       │                │
│                   │                │       │                │
│                   │ • Read PRD     │       │                │
│                   │ • Pick 1 story │       │                │
│                   │ • Implement    │       │                │
│                   │ • Commit       │       │                │
│                   │ • Update state │       │                │
│                   └────────┬───────┘       │                │
│                            │               │                │
│                            ▼               │                │
│                      More stories? ────Yes─┘                │
│                            │                                │
│                           No                                │
│                            │                                │
│                            ▼                                │
│                     3. Review Code                          │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## The Core Script (Simplified)

```bash
for i in {1..10}; do
  # Run AI with the prompt
  OUTPUT=$(claude -p prompt.md)

  # Check if all tasks are done
  if echo "$OUTPUT" | grep -q "COMPLETE"; then
    echo "All tasks finished!"
    exit 0
  fi
done
```

That's it. A loop that runs the AI, checks if it's done, and continues if not.

---

## What Makes It Work

| Component | Purpose |
|-----------|---------|
| **prd.json** | List of user stories with status (`passes: true/false`) |
| **prompt.md** | Instructions for the AI: "pick a story, implement it, commit" |
| **progress.txt** | Running log of what's done and patterns discovered |
| **ralph.sh** | The loop that orchestrates iterations |

---

## Key Insight: Right-Sized Stories

The secret sauce is breaking work into pieces small enough that the AI can complete them in one session.

**Too big:** "Build the user dashboard"
**Right-sized:**
- Add dashboard database schema
- Create dashboard data queries
- Build dashboard UI component
- Add dashboard filters

Each story = one focused task = one clean commit.

---

## Benefits

| For Teams | For Projects |
|-----------|--------------|
| Consistent, incremental progress | Clean git history with atomic commits |
| Works overnight or while you're in meetings | Each story is independently testable |
| Reduces AI "hallucination" from context overload | Progress is visible and resumable |

---

## When to Use Ralph

**Good fit:**
- Feature development with clear requirements
- Projects where you can define acceptance criteria upfront
- Overnight/background code generation

**Not ideal for:**
- Exploratory prototyping
- Highly creative or ambiguous tasks
- One-off quick fixes

---

## Getting Started

```bash
# 1. Define your feature
/prd Create a PRD for [your feature]

# 2. Convert to user stories
/ralph convert @tasks/prd.md to prd.json

# 3. Let it run
./scripts/ralph/ralph.sh
```

---

## Learn More

- Repository: [ralph-explained](https://github.com/your-repo/ralph-explained)
- Similar tools: [Get Shit Done](https://github.com/glittercowboy/get-shit-done)

---

*Ralph Loop turns AI coding tools from forgetful assistants into reliable workers that steadily build your project, one story at a time.*
