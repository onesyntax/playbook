# Pair Programming Standards
## Two Minds, Better Code

**Version:** 1.0  
**Created:** November 2025  
**Owner:** Kalpa (CEO)  
**Philosophy:** Pairing supplements code review, not replaces it

---

## Table of Contents

1. [Why Pair Programming](#why-pair-programming)
2. [When Pairing is Required](#when-pairing-is-required)
3. [Pairing Formats](#pairing-formats)
4. [Rotation Schedule](#rotation-schedule)
5. [Pairing with Juniors (Deliberate Practice)](#pairing-with-juniors-deliberate-practice)
6. [Remote Pairing Guidelines](#remote-pairing-guidelines)
7. [Roles During Pairing](#roles-during-pairing)
8. [Common Mistakes](#common-mistakes)
9. [Tools & Setup](#tools--setup)

---

## Why Pair Programming

### Benefits at OneSyntax

**Knowledge transfer:**
- Seniors teach juniors patterns in real-time
- Juniors learn by doing, not just watching
- Team spreads DDD/Clean Architecture knowledge faster
- No "knowledge silos" where one person knows critical code

**Quality improvement:**
- Real-time code review catches issues immediately
- Two perspectives on architecture decisions
- Less debugging time (catch bugs as you write)
- Better design discussions while coding

**Accountability:**
- Harder to cut corners with someone watching
- Natural enforcement of standards
- Immediate feedback on patterns
- Pairing makes quality non-negotiable

### What Pairing Is NOT

❌ **Not a replacement for code review**
- Still need async PR review
- Pairing catches different issues than PR review
- Both serve different purposes

❌ **Not constant supervision**
- Not watching over shoulders all day
- Not micromanaging
- Not lack of trust

❌ **Not for all work**
- Some tasks better solo (research, experimentation)
- Not every line of code requires pairing
- Use strategically where it adds value

---

## When Pairing is Required

### Mandatory Pairing Scenarios

**1. Complex architectural decisions**
- Defining bounded context boundaries
- Choosing aggregate patterns
- Major refactoring decisions
- New technical patterns

**2. New team member onboarding**
- First 2 weeks: 50% of coding time paired
- Learning company patterns
- Understanding existing codebase
- Building team relationships

**3. Deliberate practice assignments (Seniors + Juniors)**
- Weekly training exercises
- Senior guides junior through patterns
- Real-time feedback on technique
- Teaching moment, not just coding

**4. Production bug fixes (Critical)**
- High-impact bugs
- Complex root cause analysis
- Need second opinion
- Preventing similar bugs

### Recommended Pairing Scenarios

**Good candidates for pairing:**
- First implementation of new pattern
- Tricky algorithm or logic
- Unfamiliar part of codebase
- High-risk changes
- Features touching multiple bounded contexts

**Can be solo:**
- Routine CRUD operations
- Following established patterns
- Simple bug fixes
- Isolated feature work
- Research and spike work

### Minimum Pairing Requirements

**By role:**
- **Juniors:** 4 hours/week paired with senior
- **Mid-level:** 2 hours/week paired (mixed partners)
- **Seniors:** 4 hours/week teaching juniors
- **Everyone:** Ad-hoc pairing when beneficial

---

## Pairing Formats

### 1. Driver-Navigator (Most Common)

**Driver:**
- Has keyboard
- Writes actual code
- Implements tactical decisions
- Asks questions when stuck

**Navigator:**
- Reviews code as it's written
- Thinks strategically about design
- Suggests improvements
- Catches mistakes in real-time
- Looks up documentation

**Switch every 25 minutes (Pomodoro)**

**Best for:**
- Teaching juniors
- Complex implementations
- New patterns

### 2. Ping-Pong (TDD Pairing)

**Process:**
1. Person A writes failing test
2. Person B implements code to pass test
3. Person B writes next failing test
4. Person A implements code to pass test
5. Repeat

**Best for:**
- Test-driven development practice
- Equal skill levels
- Learning TDD rhythms

### 3. Strong-Style Pairing

**Rule:** "For an idea to go from your head to the computer, it must go through someone else's hands"

**Process:**
- Navigator has the ideas
- Driver implements without adding own ideas
- Forces verbalization of all decisions
- Driver asks clarifying questions

**Best for:**
- Teaching specific patterns
- Ensuring junior understands (they navigate, senior drives)
- Preventing the senior from "taking over"

### 4. Mob Programming (Special Cases)

**Process:**
- 3-5 people, one computer
- One driver, multiple navigators
- Rotate driver every 10 minutes
- Everyone participates in decisions

**Best for:**
- Architectural decisions affecting whole team
- Critical bug analysis
- New pattern introduction
- Kickoff of complex features

---

## Rotation Schedule

### Weekly Pairing Rotations

**Structure:**
- Rotate pairs every week
- Ensure juniors pair with different seniors
- Mix mid-level developers
- Avoid same pairs repeatedly

**Sample rotation (10 people: 4 seniors, 4 mid, 2 juniors):**

**Week 1:**
- Senior A + Junior 1 (Monday/Wednesday)
- Senior B + Junior 2 (Monday/Wednesday)
- Mid-level 1 + Mid-level 2 (Tuesday)
- Senior C + Mid-level 3 (Thursday)

**Week 2:**
- Senior B + Junior 1 (rotate seniors)
- Senior C + Junior 2
- Mid-level 3 + Mid-level 4
- Senior D + Mid-level 1

**Calendar management:**
- Block pairing time in calendars
- 2-hour blocks work well
- Morning sessions preferred (fresher minds)
- Recurring weekly schedule

### Ad-Hoc Pairing

**When you need help:**
- Post in #pairing-requests Slack channel
- "@channel anyone free for 30min pairing on X?"
- Specify: what you're working on, what you need help with
- First available person responds

**Pairing board:**
- Notion board with pairing availability
- "Available for pairing" status
- Topics you can help with
- When you're free

---

## Pairing with Juniors (Deliberate Practice)

### Weekly Training Exercises

**Structure:**
- Senior assigns exercise Monday morning
- Junior attempts solo first (1-2 hours)
- Pairing session Wednesday (2 hours)
- Junior completes solo afterward
- Review in next week's 1:1

**Senior's role during pairing:**
- Let junior drive (keyboard)
- Ask guiding questions, don't give answers
- "What pattern should we use here?" not "Use a Value Object"
- Catch mistakes immediately but explain why
- Show better approaches live

**Example session:**

```
Exercise: Convert anemic User entity to rich domain model

Junior drives:
- "Where should we start?"
Senior: "What makes an entity anemic?"
Junior: "Just getters/setters, no behavior"
Senior: "Right, so what behavior is missing from User?"
Junior: "Um... validation? Business rules?"
Senior: "Good! Show me User currently. What rules do you see in the controller?"
Junior: [navigates to UserController]
Senior: "See that email validation? Where should that live?"
Junior: "In the User entity?"
Senior: "Exactly! Let's move it. How do we make email validation part of User?"
[Continue guiding without taking keyboard]
```

### Pairing Anti-Patterns with Juniors

**❌ Don't:**
- Take keyboard away from junior
- Type for them "just to be faster"
- Get frustrated with their pace
- Give answers without explanation
- Let them struggle for hours without guidance

**✅ Do:**
- Let them struggle appropriately (learning happens)
- Guide with questions
- Explain the "why" behind every decision
- Celebrate small wins
- Be patient with pace

---

## Remote Pairing Guidelines

### Tools Setup

**Required:**
- VS Code Live Share (preferred) or
- Tuple (dedicated pair programming tool) or
- Screen sharing + one person types

**Communication:**
- Video call (required - see each other)
- Shared screen
- Both have microphone
- Quiet environment

**Best practices:**
- High quality internet connection
- Headphones to reduce echo
- Good microphone (not laptop mic if possible)
- Comfortable seating

### Remote Pairing Etiquette

**Video on:**
- Always have video during pairing
- See facial expressions and body language
- Know when partner is confused
- Build connection

**Communication:**
- Verbalize more than in-person
- "I'm thinking..." (not just silent)
- Ask if explanation makes sense
- Over-communicate intentions

**Breaks:**
- Pomodoro timer (25 min work, 5 min break)
- Stretch, get water during breaks
- Don't skip breaks (fatigue kills quality)

**Time zones:**
- Schedule during overlapping hours
- Don't pair early morning/late night
- Consider energy levels

---

## Roles During Pairing

### Navigator Responsibilities

**Strategic thinking:**
- Think about overall design
- Consider edge cases
- Plan next steps
- Keep bigger picture in mind

**Active participation:**
- Don't just watch silently
- Ask questions
- Suggest alternatives
- Spot typos and mistakes

**Support driver:**
- Look up documentation
- Find relevant code examples
- Remember previous decisions
- Think ahead to next steps

**What NOT to do:**
- Grab keyboard
- Dictate every character
- Point at screen constantly
- Criticize without helping

### Driver Responsibilities

**Implementation:**
- Write the code
- Make tactical decisions
- Ask questions when unclear
- Verbalize your thinking

**Communication:**
- Explain what you're doing
- Ask for input on decisions
- Alert when stuck
- Share context from your head

**Collaboration:**
- Listen to navigator
- Consider suggestions openly
- Don't rush ahead
- Be humble about own ideas

**What NOT to do:**
- Ignore navigator suggestions
- Go too fast to follow
- Type silently without explanation
- Defensive about feedback

---

## Common Mistakes

### Mistake 1: One Person Does Everything

**Problem:** Senior takes keyboard and junior watches.

**Why it happens:**
- Senior frustrated with pace
- "Faster if I just do it"
- Junior not confident

**Solution:**
- Junior must drive during training
- Senior forces themselves to only navigate
- Set explicit rule: "You have keyboard entire session"

### Mistake 2: Pairing as Watching

**Problem:** One person codes, other person scrolls phone.

**Why it happens:**
- Task not interesting to both
- Wrong pairing format
- Unclear roles

**Solution:**
- Switch roles if bored
- Choose tasks that benefit from pairing
- Navigator actively participates

### Mistake 3: No Breaks

**Problem:** 4-hour pairing session without breaks.

**Why it happens:**
- "In the flow"
- Deadline pressure
- Forgot about breaks

**Solution:**
- Set timer for 25 minutes
- Mandatory 5 minute breaks
- Quality drops without breaks

### Mistake 4: Unequal Partnership

**Problem:** One person dominates decisions.

**Why it happens:**
- Seniority imbalance
- Personality differences
- Lack of psychological safety

**Solution:**
- Explicitly balance input
- "What do you think?" before deciding
- Rotate who makes final call
- Create safe space for disagreement

### Mistake 5: Pairing on Wrong Tasks

**Problem:** Pairing on simple CRUD that doesn't need two people.

**Why it happens:**
- "We should always pair"
- Misunderstanding pairing purpose
- Schedule says "pairing time"

**Solution:**
- Choose tasks strategically
- Okay to cancel pairing if task doesn't need it
- Use time for code review instead

---

## Tools & Setup

### Required Tools

**VS Code Live Share:**
- Free, built into VS Code
- Both people can edit simultaneously
- Shared terminal
- Shared debugging

**Setup:**
1. Install Live Share extension
2. Sign in with GitHub
3. Click "Live Share" in status bar
4. Share link with pair

**Tuple (Alternative):**
- Paid tool ($30/month/person)
- Better performance than screen share
- Designed specifically for pairing
- Low latency

### Physical Setup (In-Office)

**Ideal setup:**
- Two keyboards, two mice, one monitor
- Both can type without asking
- Large monitor (27"+ or two monitors)
- Comfortable seating side-by-side

**Minimal setup:**
- One computer, two chairs
- Pass keyboard/mouse when switching
- Take breaks more frequently

---

## Measuring Success

### Individual Level

**You're pairing well when:**
- Both people contribute ideas
- Learn something every session
- Code quality improves
- Enjoy the collaboration
- Feel productive (not wasting time)

### Team Level

**Team pairs well when:**
- Knowledge spreads across team
- No knowledge silos forming
- Juniors progressing quickly
- Code quality consistent across team
- People request pairing naturally

---

## Starting Pair Programming

### Week 1: Introduction

**All-hands meeting:**
- Explain pairing benefits
- Show example session
- Assign initial pairs
- Set expectations

**Initial pairs:**
- All juniors pair with seniors
- Seniors model good pairing
- Mid-levels observe one session

### Week 2-4: Building Habit

**Scheduled pairing:**
- Recurring calendar blocks
- Rotate pairs weekly
- Start with 2 hours/week minimum
- Collect feedback

**Retrospective:**
- What's working?
- What's awkward?
- Adjust format as needed

### Month 2+: Ongoing Practice

**Established rhythm:**
- Pairing is normal part of workflow
- People request pairing naturally
- Quality benefits visible
- Part of company culture

---

## Common Questions

**Q: Does pairing slow us down?**
A: Short-term yes (30% slower coding). Long-term no (fewer bugs, better design, less rework). Net productivity gain.

**Q: What if personalities clash?**
A: Rotate pairs weekly. If serious conflict, involve manager. Sometimes people just don't pair well together.

**Q: Can I pair with someone remote?**
A: Yes! Use Live Share or Tuple. Video required. Works great if tools set up properly.

**Q: What if I'm stuck on a problem?**
A: Perfect time to request pairing. Post in #pairing-requests, get fresh perspective.

**Q: Do we still do code reviews?**
A: YES. Pairing doesn't replace PR reviews. Different benefits, both necessary.

**Q: How do we track pairing time?**
A: Honor system. Note in standup. Notion board for scheduling. Don't need to track every minute.

---

## Remember

**Pair programming is a skill that improves with practice.**

First sessions feel awkward. That's normal. After a few weeks, it becomes natural and valuable.

**The goal is better code through collaboration, not perfect pairing technique.**

---

*Related: [Collective Ownership](collective-ownership.md) | [Training](training.md) | [Code Review](code-review.md)*
